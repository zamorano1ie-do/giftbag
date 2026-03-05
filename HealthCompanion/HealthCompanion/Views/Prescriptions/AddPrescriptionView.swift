import SwiftUI
import SwiftData

struct AddPrescriptionView: View {
    let member: FamilyMember

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var medicationName = ""
    @State private var genericName = ""
    @State private var dosage = ""
    @State private var form: MedicationForm = .tablet
    @State private var frequency = ""
    @State private var instructions = ""
    @State private var prescribedBy = ""
    @State private var startDate = Date()
    @State private var hasEndDate = false
    @State private var endDate = Date().addingTimeInterval(30 * 24 * 3600)
    @State private var refills = 0
    @State private var pharmacy = ""
    @State private var reason = ""
    @State private var sideEffectsNoted = ""
    @State private var notes = ""
    @State private var isActive = true
    @State private var showCamera = false
    @State private var capturedData: Data?
    @State private var extractedText = ""

    // Common frequencies for quick pick
    private let frequencies = ["Once daily", "Twice daily", "Three times daily", "Four times daily",
                               "Every 8 hours", "Every 12 hours", "Once weekly", "As needed (PRN)"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    // Scan prescription label
                    CameraCaptureButton { showCamera = true }

                    FormField(label: "Medication Name") {
                        VoiceTextField(placeholder: "e.g. Metformin", text: $medicationName)
                    }

                    FormField(label: "Generic Name (optional)") {
                        VoiceTextField(placeholder: "e.g. metformin hydrochloride", text: $genericName)
                    }

                    FormField(label: "Dosage") {
                        VoiceTextField(placeholder: "e.g. 500mg", text: $dosage)
                    }

                    FormField(label: "Form") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(MedicationForm.allCases, id: \.self) { f in
                                    Button {
                                        form = f
                                    } label: {
                                        VStack(spacing: 4) {
                                            Image(systemName: f.icon)
                                                .font(.title2)
                                            Text(f.rawValue)
                                                .font(AppTheme.Font.caption)
                                                .minimumScaleFactor(0.5)
                                                .lineLimit(1)
                                        }
                                        .frame(width: 80, height: 70)
                                        .background(form == f ? AppTheme.Section.prescriptions : Color(.tertiarySystemBackground))
                                        .foregroundStyle(form == f ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    FormField(label: "How Often") {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            VoiceTextField(placeholder: "e.g. Twice daily with food", text: $frequency)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppTheme.Spacing.sm) {
                                    ForEach(frequencies, id: \.self) { freq in
                                        Button {
                                            frequency = freq
                                        } label: {
                                            Text(freq)
                                                .font(AppTheme.Font.label)
                                                .minimumScaleFactor(0.7)
                                                .lineLimit(1)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(frequency == freq ? AppTheme.Section.prescriptions.opacity(0.2) : Color(.tertiarySystemBackground))
                                                .foregroundStyle(frequency == freq ? AppTheme.Section.prescriptions : .primary)
                                                .clipShape(Capsule())
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }

                    FormField(label: "Special Instructions") {
                        VoiceTextField(placeholder: "e.g. Take with food, avoid alcohol", text: $instructions, axis: .vertical)
                    }

                    FormField(label: "Prescribed By") {
                        VoiceTextField(placeholder: "e.g. Dr. Smith", text: $prescribedBy)
                    }

                    FormField(label: "Prescribed For (Reason)") {
                        VoiceTextField(placeholder: "e.g. Type 2 Diabetes", text: $reason)
                    }

                    FormField(label: "Start Date") {
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Toggle("Has an end date", isOn: $hasEndDate)
                                .font(AppTheme.Font.subhead)
                                .frame(minHeight: AppTheme.tapTargetHeight)
                            if hasEndDate {
                                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                                    .font(AppTheme.Font.body)
                                    .frame(minHeight: AppTheme.tapTargetHeight)
                            }
                        }
                    }

                    FormField(label: "Pharmacy") {
                        VoiceTextField(placeholder: "e.g. Boots Pharmacy, High Street", text: $pharmacy)
                    }

                    FormField(label: "Refills Remaining") {
                        Stepper("\(refills) refills", value: $refills, in: 0...99)
                            .font(AppTheme.Font.body)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Side Effects Noted") {
                        VoiceTextField(placeholder: "Any side effects you've noticed…", text: $sideEffectsNoted, axis: .vertical)
                    }

                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Anything else to remember…", text: $notes, axis: .vertical)
                    }

                    SectionCard {
                        Toggle("I am currently taking this", isOn: $isActive)
                            .font(AppTheme.Font.subhead)
                            .frame(minHeight: AppTheme.tapTargetHeight)
                    }

                    PrimaryButton("Save Medication", icon: "checkmark.circle.fill", color: AppTheme.Section.prescriptions) {
                        save()
                    }
                    .disabled(medicationName.isEmpty || dosage.isEmpty)
                    .opacity(medicationName.isEmpty || dosage.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Add Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.font(AppTheme.Font.body)
                }
            }
            .sheet(isPresented: $showCamera) {
                DocumentCaptureView(capturedData: $capturedData, extractedText: $extractedText)
            }
        }
    }

    private func save() {
        let rx = Prescription(
            medicationName: medicationName,
            genericName: genericName,
            dosage: dosage,
            form: form,
            frequency: frequency,
            instructions: instructions,
            prescribedBy: prescribedBy,
            startDate: startDate,
            endDate: hasEndDate ? endDate : nil,
            isActive: isActive,
            refillsRemaining: refills,
            pharmacy: pharmacy,
            reason: reason,
            sideEffectsNoted: sideEffectsNoted,
            notes: notes
        )
        rx.member = member
        context.insert(rx)
        try? context.save()
        dismiss()
    }
}
