import SwiftUI
import SwiftData

struct AddFamilyMemberView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var dob = Calendar.current.date(byAdding: .year, value: -40, to: Date()) ?? Date()
    @State private var sex: BiologicalSex = .notSpecified
    @State private var bloodType: BloodType = .unknown
    @State private var relationship: Relationship = .self_
    @State private var email = ""
    @State private var phone = ""
    @State private var emergencyName = ""
    @State private var emergencyPhone = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    // Big avatar icon
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.accentColor)
                        Text("Who are we adding?")
                            .font(AppTheme.Font.heading)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top)

                    FormField(label: "Full Name") {
                        VoiceTextField(placeholder: "e.g. Margaret Smith", text: $name)
                    }

                    FormField(label: "Relationship to you") {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.sm) {
                            ForEach(Relationship.allCases, id: \.self) { rel in
                                Button { relationship = rel } label: {
                                    Text(rel.rawValue)
                                        .font(AppTheme.Font.label)
                                        .fontWeight(relationship == rel ? .semibold : .regular)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 52)
                                        .background(relationship == rel ? Color.accentColor : Color(.secondarySystemBackground))
                                        .foregroundStyle(relationship == rel ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }

                    FormField(label: "Date of Birth") {
                        DatePicker("", selection: $dob, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Biological Sex") {
                        Picker("Sex", selection: $sex) {
                            ForEach(BiologicalSex.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }

                    FormField(label: "Blood Type") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(BloodType.allCases, id: \.self) { bt in
                                    Button { bloodType = bt } label: {
                                        Text(bt.rawValue)
                                            .font(AppTheme.Font.label)
                                            .fontWeight(bloodType == bt ? .bold : .regular)
                                            .frame(width: 56, height: 48)
                                            .background(bloodType == bt ? Color.red : Color(.secondarySystemBackground))
                                            .foregroundStyle(bloodType == bt ? .white : .primary)
                                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    FormField(label: "Phone Number (optional)") {
                        VoiceTextField(placeholder: "e.g. 07712 345678", text: $phone, keyboardType: .phonePad)
                    }

                    FormField(label: "Email (optional)") {
                        VoiceTextField(placeholder: "e.g. margaret@email.com", text: $email, keyboardType: .emailAddress)
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Emergency Contact (optional)", systemImage: "phone.badge.plus")
                            .font(AppTheme.Font.heading)
                        VoiceTextField(placeholder: "Emergency contact name", text: $emergencyName)
                        VoiceTextField(placeholder: "Emergency contact phone", text: $emergencyPhone, keyboardType: .phonePad)
                    }

                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Any additional info…", text: $notes, axis: .vertical)
                    }

                    PrimaryButton("Add to Family", icon: "person.badge.plus") { save() }
                        .disabled(name.isEmpty).opacity(name.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Family Member")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.font(AppTheme.Font.body)
                }
            }
        }
    }

    private func save() {
        let m = FamilyMember(
            name: name, dateOfBirth: dob, biologicalSex: sex, bloodType: bloodType,
            relationship: relationship, email: email, phone: phone,
            emergencyContactName: emergencyName, emergencyContactPhone: emergencyPhone, notes: notes
        )
        context.insert(m)
        try? context.save()
        dismiss()
    }
}

// MARK: - Edit Family Member (same fields, pre-filled)

struct EditFamilyMemberView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var dob: Date
    @State private var sex: BiologicalSex
    @State private var bloodType: BloodType
    @State private var relationship: Relationship
    @State private var email: String
    @State private var phone: String
    @State private var emergencyName: String
    @State private var emergencyPhone: String
    @State private var notes: String

    init(member: FamilyMember) {
        self.member = member
        _name = State(initialValue: member.name)
        _dob = State(initialValue: member.dateOfBirth)
        _sex = State(initialValue: member.biologicalSex)
        _bloodType = State(initialValue: member.bloodType)
        _relationship = State(initialValue: member.relationship)
        _email = State(initialValue: member.email)
        _phone = State(initialValue: member.phone)
        _emergencyName = State(initialValue: member.emergencyContactName)
        _emergencyPhone = State(initialValue: member.emergencyContactPhone)
        _notes = State(initialValue: member.notes)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {
                FormField(label: "Full Name") { VoiceTextField(placeholder: "Full name", text: $name) }
                FormField(label: "Date of Birth") {
                    DatePicker("", selection: $dob, displayedComponents: .date)
                        .datePickerStyle(.compact).labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                }
                FormField(label: "Blood Type") {
                    Picker("Blood Type", selection: $bloodType) {
                        ForEach(BloodType.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                    }.pickerStyle(.menu)
                }
                FormField(label: "Phone") { VoiceTextField(placeholder: "Phone number", text: $phone, keyboardType: .phonePad) }
                FormField(label: "Email") { VoiceTextField(placeholder: "Email address", text: $email, keyboardType: .emailAddress) }
                FormField(label: "Emergency Contact") { VoiceTextField(placeholder: "Name", text: $emergencyName) }
                FormField(label: "Emergency Phone") { VoiceTextField(placeholder: "Phone number", text: $emergencyPhone, keyboardType: .phonePad) }
                FormField(label: "Notes") { VoiceTextField(placeholder: "Additional notes…", text: $notes, axis: .vertical) }
                PrimaryButton("Save Changes", icon: "checkmark.circle.fill") { save() }
                    .disabled(name.isEmpty).opacity(name.isEmpty ? 0.5 : 1)
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(member.firstName)
        .navigationBarTitleDisplayMode(.large)
    }

    private func save() {
        member.name = name; member.dateOfBirth = dob; member.biologicalSex = sex
        member.bloodType = bloodType; member.relationship = relationship
        member.email = email; member.phone = phone
        member.emergencyContactName = emergencyName; member.emergencyContactPhone = emergencyPhone
        member.notes = notes
        try? context.save()
        dismiss()
    }
}
