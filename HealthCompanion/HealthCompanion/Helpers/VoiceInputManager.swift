import Foundation
import Speech
import AVFoundation
import Combine
import SwiftUI
import UIKit

// MARK: - Voice Input Manager
// Allows users (especially elderly) to speak instead of type

@MainActor
@Observable
final class VoiceInputManager: NSObject {
    var transcript: String = ""
    var isRecording: Bool = false
    var errorMessage: String?

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    private var onFinish: ((String) -> Void)?

    override init() {
        super.init()
        speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    }

    func requestPermissions() async -> Bool {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        return speechStatus == .authorized
    }

    func startRecording(onFinish: @escaping (String) -> Void) {
        self.onFinish = onFinish
        guard !isRecording else { stopRecording(); return }

        Task {
            let permitted = await requestPermissions()
            guard permitted else {
                errorMessage = "Microphone access is needed for voice input. Please allow it in Settings."
                return
            }
            startSession()
        }
    }

    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        isRecording = false
    }

    private func startSession() {
        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            if let result {
                self.transcript = result.bestTranscription.formattedString
            }
            if error != nil || result?.isFinal == true {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.isRecording = false
                if let text = result?.bestTranscription.formattedString, !text.isEmpty {
                    self.onFinish?(text)
                }
            }
        }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            recognitionRequest.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
        isRecording = true
        transcript = ""
    }
}

// MARK: - Voice Input Field Modifier
// Attach to any TextField to show a mic button alongside it

struct VoiceTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var axis: Axis = .horizontal

    @State private var voiceManager = VoiceInputManager()
    @State private var showError = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 8) {
                TextField(placeholder, text: $text, axis: axis)
                    .font(AppTheme.Font.body)
                    .keyboardType(keyboardType)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 14)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))

                Button {
                    voiceManager.startRecording { recognised in
                        text = recognised
                    }
                } label: {
                    Image(systemName: voiceManager.isRecording ? "waveform.circle.fill" : "mic.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(voiceManager.isRecording ? .red : .accentColor)
                        .symbolEffect(.pulse, isActive: voiceManager.isRecording)
                }
                .frame(width: 44, height: 44)
                .accessibilityLabel(voiceManager.isRecording ? "Stop recording" : "Start voice input")
            }

            if voiceManager.isRecording {
                Label("Listening… speak now", systemImage: "waveform")
                    .font(AppTheme.Font.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .alert("Microphone Access", isPresented: $showError) {
            Button("OK") {}
        } message: {
            Text(voiceManager.errorMessage ?? "Unable to use microphone.")
        }
        .onChange(of: voiceManager.errorMessage) {
            showError = voiceManager.errorMessage != nil
        }
    }
}
