import SwiftUI
import PhotosUI
import Vision
import VisionKit

// MARK: - Document Camera / Photo Picker sheet
// For capturing prescriptions, lab reports, etc.

struct DocumentCaptureView: View {
    @Binding var capturedData: Data?
    @Binding var extractedText: String
    @Environment(\.dismiss) private var dismiss

    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isProcessing = false
    @State private var previewImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.lg) {
                Spacer()

                Image(systemName: "doc.viewfinder.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.secondary)

                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Add a Document")
                        .font(AppTheme.Font.title)
                    Text("Photograph a prescription, lab report, or any health document. We'll read the text for you automatically.")
                        .font(AppTheme.Font.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                }

                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 220)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                        .padding(.horizontal)

                    if !extractedText.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Text we found", systemImage: "text.viewfinder")
                                .font(AppTheme.Font.label)
                                .foregroundStyle(.secondary)
                            ScrollView {
                                Text(extractedText)
                                    .font(AppTheme.Font.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .frame(maxHeight: 120)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                        .padding(.horizontal)
                    }
                }

                VStack(spacing: AppTheme.Spacing.md) {
                    if VNDocumentCameraViewController.isSupported {
                        PrimaryButton("Scan with Camera", icon: "camera.fill", color: .accentColor) {
                            showCamera = true
                        }
                    }

                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        HStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Choose from Photos")
                                .font(AppTheme.Font.subhead)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: AppTheme.tapTargetHeight)
                        .background(Color(.secondarySystemBackground))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                    }

                    if previewImage != nil {
                        PrimaryButton("Use This Document", icon: "checkmark", color: .green) {
                            dismiss()
                        }
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)

                if isProcessing {
                    ProgressView("Reading text…")
                        .font(AppTheme.Font.body)
                }

                Spacer()
            }
            .navigationTitle("Add Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(AppTheme.Font.body)
                }
            }
            .sheet(isPresented: $showCamera) {
                DocumentCameraSheet { scan in
                    process(scan: scan)
                }
            }
            .onChange(of: selectedPhoto) {
                Task { await loadPhoto() }
            }
        }
    }

    private func loadPhoto() async {
        guard let item = selectedPhoto,
              let data = try? await item.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }
        capturedData = data
        previewImage = image
        isProcessing = true
        extractedText = await recogniseText(in: image)
        isProcessing = false
    }

    private func process(scan: VNDocumentCameraScan) {
        guard scan.pageCount > 0 else { return }
        let image = scan.imageOfPage(at: 0)
        if let data = image.jpegData(compressionQuality: 0.85) {
            capturedData = data
        }
        previewImage = image
        isProcessing = true
        Task {
            extractedText = await recogniseText(in: image)
            isProcessing = false
        }
    }

    private func recogniseText(in image: UIImage) async -> String {
        guard let cgImage = image.cgImage else { return "" }
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { req, _ in
                let text = (req.results as? [VNRecognizedTextObservation])?
                    .compactMap { $0.topCandidates(1).first?.string }
                    .joined(separator: "\n") ?? ""
                continuation.resume(returning: text)
            }
            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true
            try? VNImageRequestHandler(cgImage: cgImage).perform([request])
        }
    }
}

// MARK: - Document Camera wrapper

struct DocumentCameraSheet: UIViewControllerRepresentable {
    let onScan: (VNDocumentCameraScan) -> Void

    func makeCoordinator() -> Coordinator { Coordinator(onScan: onScan) }

    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
        let vc = VNDocumentCameraViewController()
        vc.delegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}

    final class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
        let onScan: (VNDocumentCameraScan) -> Void
        init(onScan: @escaping (VNDocumentCameraScan) -> Void) { self.onScan = onScan }

        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
            onScan(scan)
            controller.dismiss(animated: true)
        }
        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
            controller.dismiss(animated: true)
        }
        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
            controller.dismiss(animated: true)
        }
    }
}
