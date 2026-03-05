import SwiftUI
import SwiftData

struct AddAppointmentView: View {
    let member: FamilyMember

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var doctorName = ""
    @State private var specialty: MedicalSpecialty = .generalPractice
    @State private var clinic = ""
    @State private var reason = ""
    @State private var diagnosis = ""
    @State private var treatmentPlan = ""
    @State private var hasFollowUp = false
    @State private var followUpDate = Date().addingTimeInterval(30 * 24 * 3600)
    @State private var followUpNotes = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    FormField(label: "Date & Time of Visit") {
                        DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Doctor's Name") {
                        VoiceTextField(placeholder: "e.g. Dr. Johnson", text: $doctorName)
                    }

                    FormField(label: "Type of Visit") {
                        Picker("Specialty", selection: $specialty) {
                            ForEach(MedicalSpecialty.allCases, id: \.self) { spec in
                                Label(spec.rawValue, systemImage: spec.icon).tag(spec)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Clinic / Hospital") {
                        VoiceTextField(placeholder: "e.g. City Medical Centre", text: $clinic)
                    }

                    FormField(label: "Reason for Visit") {
                        VoiceTextField(placeholder: "Why did you go? e.g. Annual check-up, chest pain…", text: $reason, axis: .vertical)
                    }

                    FormField(label: "Diagnosis") {
                        VoiceTextField(placeholder: "What did the doctor say?", text: $diagnosis, axis: .vertical)
                    }

                    FormField(label: "Treatment Plan") {
                        VoiceTextField(placeholder: "What was recommended or prescribed?", text: $treatmentPlan, axis: .vertical)
                    }

                    // Follow-up
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Toggle("Follow-up appointment needed", isOn: $hasFollowUp)
                                .font(AppTheme.Font.subhead)
                                .frame(minHeight: AppTheme.tapTargetHeight)

                            if hasFollowUp {
                                DatePicker("Follow-up date", selection: $followUpDate, displayedComponents: .date)
                                    .font(AppTheme.Font.body)
                                    .frame(minHeight: AppTheme.tapTargetHeight)
                                VoiceTextField(placeholder: "Notes for follow-up…", text: $followUpNotes, axis: .vertical)
                            }
                        }
                    }

                    FormField(label: "Additional Notes") {
                        VoiceTextField(placeholder: "Anything else to remember…", text: $notes, axis: .vertical)
                    }

                    PrimaryButton("Save Visit", icon: "checkmark.circle.fill", color: AppTheme.Section.appointments) {
                        save()
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Log Doctor Visit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.font(AppTheme.Font.body)
                }
            }
        }
    }

    private func save() {
        let appt = Appointment(
            date: date,
            doctorName: doctorName,
            specialty: specialty,
            clinic: clinic,
            reason: reason,
            diagnosis: diagnosis,
            treatmentPlan: treatmentPlan,
            followUpDate: hasFollowUp ? followUpDate : nil,
            followUpNotes: followUpNotes,
            notes: notes
        )
        appt.member = member
        context.insert(appt)
        try? context.save()
        dismiss()
    }
}
