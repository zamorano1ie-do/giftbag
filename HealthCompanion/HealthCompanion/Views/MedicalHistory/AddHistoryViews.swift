import SwiftUI
import SwiftData

// MARK: - Add Condition

struct AddConditionView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var category: ConditionCategory = .other
    @State private var diagnosedDate: Date = Date()
    @State private var hasDiagnosedDate = false
    @State private var diagnosedBy = ""
    @State private var isActive = true
    @State private var isChronic = false
    @State private var severity: ConditionSeverity = .mild
    @State private var treatment = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    FormField(label: "Condition Name") {
                        VoiceTextField(placeholder: "e.g. Type 2 Diabetes, Hypertension", text: $name)
                    }
                    FormField(label: "Category") {
                        Picker("Category", selection: $category) {
                            ForEach(ConditionCategory.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    SectionCard {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Toggle("I have the diagnosis date", isOn: $hasDiagnosedDate)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            if hasDiagnosedDate {
                                DatePicker("Diagnosed on", selection: $diagnosedDate, displayedComponents: .date)
                                    .font(AppTheme.Font.body).frame(minHeight: AppTheme.tapTargetHeight)
                            }
                        }
                    }
                    FormField(label: "Diagnosed By") {
                        VoiceTextField(placeholder: "e.g. Dr. Smith", text: $diagnosedBy)
                    }
                    SectionCard {
                        VStack(spacing: 0) {
                            Toggle("Currently active", isOn: $isActive)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            Divider()
                            Toggle("Chronic (long-term) condition", isOn: $isChronic)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                        }
                    }
                    FormField(label: "Severity") {
                        Picker("Severity", selection: $severity) {
                            ForEach(ConditionSeverity.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                    FormField(label: "Treatment / Management") {
                        VoiceTextField(placeholder: "How is this being managed or treated?", text: $treatment, axis: .vertical)
                    }
                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Any other details…", text: $notes, axis: .vertical)
                    }
                    PrimaryButton("Save Condition", icon: "checkmark.circle.fill", color: AppTheme.Section.history) { save() }
                        .disabled(name.isEmpty).opacity(name.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Condition")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let c = MedicalCondition(name: name, category: category,
            diagnosedDate: hasDiagnosedDate ? diagnosedDate : nil,
            diagnosedBy: diagnosedBy, isActive: isActive, isChronic: isChronic,
            severity: severity, treatment: treatment, notes: notes)
        c.member = member; context.insert(c); try? context.save(); dismiss()
    }
}

// MARK: - Add Surgery

struct AddSurgeryView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var surgeon = ""
    @State private var hospital = ""
    @State private var reason = ""
    @State private var outcome = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    FormField(label: "Procedure / Surgery Name") {
                        VoiceTextField(placeholder: "e.g. Appendectomy, Hip Replacement", text: $name)
                    }
                    FormField(label: "Date") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact).labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    FormField(label: "Surgeon") { VoiceTextField(placeholder: "e.g. Dr. Jones", text: $surgeon) }
                    FormField(label: "Hospital") { VoiceTextField(placeholder: "e.g. City General Hospital", text: $hospital) }
                    FormField(label: "Reason") { VoiceTextField(placeholder: "Why was this procedure needed?", text: $reason, axis: .vertical) }
                    FormField(label: "Outcome / Result") { VoiceTextField(placeholder: "How did it go?", text: $outcome, axis: .vertical) }
                    FormField(label: "Notes") { VoiceTextField(placeholder: "Additional notes…", text: $notes, axis: .vertical) }
                    PrimaryButton("Save Surgery", icon: "checkmark.circle.fill", color: AppTheme.Section.history) { save() }
                        .disabled(name.isEmpty).opacity(name.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Surgery / Procedure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let s = Surgery(name: name, date: date, surgeon: surgeon, hospital: hospital, reason: reason, outcome: outcome, notes: notes)
        s.member = member; context.insert(s); try? context.save(); dismiss()
    }
}

// MARK: - Add Allergy

struct AddAllergyView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var allergen = ""
    @State private var category: AllergyCategory = .medication
    @State private var reaction = ""
    @State private var severity: AllergySeverity = .mild
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    FormField(label: "Allergen") {
                        VoiceTextField(placeholder: "e.g. Penicillin, Peanuts, Pollen", text: $allergen)
                    }
                    FormField(label: "Category") {
                        Picker("Category", selection: $category) {
                            ForEach(AllergyCategory.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    FormField(label: "Reaction") {
                        VoiceTextField(placeholder: "e.g. Rash, difficulty breathing, anaphylaxis", text: $reaction, axis: .vertical)
                    }
                    FormField(label: "Severity") {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            ForEach(AllergySeverity.allCases, id: \.self) { sev in
                                Button { severity = sev } label: {
                                    HStack {
                                        Image(systemName: severity == sev ? "largecircle.fill.circle" : "circle")
                                            .foregroundStyle(severity == sev ? .accentColor : .secondary)
                                        Text(sev.rawValue).font(AppTheme.Font.body)
                                        Spacer()
                                    }
                                    .frame(minHeight: AppTheme.tapTargetHeight)
                                    .padding(.horizontal)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    FormField(label: "Notes") { VoiceTextField(placeholder: "Additional details…", text: $notes, axis: .vertical) }
                    PrimaryButton("Save Allergy", icon: "checkmark.circle.fill", color: AppTheme.Section.vitals) { save() }
                        .disabled(allergen.isEmpty).opacity(allergen.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Allergy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let a = Allergy(allergen: allergen, category: category, reaction: reaction, severity: severity, notes: notes)
        a.member = member; context.insert(a); try? context.save(); dismiss()
    }
}

// MARK: - Add Vaccination

struct AddVaccinationView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var date = Date()
    @State private var hasNextDue = false
    @State private var nextDueDate = Date().addingTimeInterval(365 * 24 * 3600)
    @State private var provider = ""
    @State private var batchNumber = ""
    @State private var notes = ""

    private let commonVaccines = ["COVID-19 Booster", "Annual Flu", "Pneumococcal", "Shingles (Zostavax/Shingrix)",
                                   "Tetanus/Td Booster", "Hepatitis B", "HPV", "MMR", "Meningococcal"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    FormField(label: "Vaccine Name") {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            VoiceTextField(placeholder: "e.g. Annual Flu Vaccine", text: $name)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppTheme.Spacing.sm) {
                                    ForEach(commonVaccines, id: \.self) { v in
                                        Button { name = v } label: {
                                            Text(v).font(AppTheme.Font.label)
                                                .padding(.horizontal, 12).padding(.vertical, 8)
                                                .background(name == v ? Color.accentColor.opacity(0.2) : Color(.tertiarySystemBackground))
                                                .foregroundStyle(name == v ? .accentColor : .primary)
                                                .clipShape(Capsule())
                                        }.buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                    FormField(label: "Date Given") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact).labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    SectionCard {
                        VStack(spacing: AppTheme.Spacing.sm) {
                            Toggle("Next dose / booster is needed", isOn: $hasNextDue)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            if hasNextDue {
                                DatePicker("Next due date", selection: $nextDueDate, displayedComponents: .date)
                                    .font(AppTheme.Font.body).frame(minHeight: AppTheme.tapTargetHeight)
                            }
                        }
                    }
                    FormField(label: "Given By (Provider)") { VoiceTextField(placeholder: "e.g. GP Surgery, Pharmacy", text: $provider) }
                    FormField(label: "Batch Number (optional)") { VoiceTextField(placeholder: "From the vaccine label", text: $batchNumber) }
                    FormField(label: "Notes") { VoiceTextField(placeholder: "e.g. Arm was sore for 1 day", text: $notes, axis: .vertical) }
                    PrimaryButton("Save Vaccination", icon: "checkmark.circle.fill", color: .green) { save() }
                        .disabled(name.isEmpty).opacity(name.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Vaccination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let v = Vaccination(name: name, date: date, nextDueDate: hasNextDue ? nextDueDate : nil,
                            provider: provider, batchNumber: batchNumber, notes: notes)
        v.member = member; context.insert(v); try? context.save(); dismiss()
    }
}

// MARK: - Add Document

struct AddDocumentView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var category: DocumentCategory = .prescription
    @State private var notes = ""
    @State private var capturedData: Data?
    @State private var extractedText = ""
    @State private var showCapture = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    PrimaryButton("Scan or Choose Document", icon: "doc.viewfinder.fill") {
                        showCapture = true
                    }

                    if let data = capturedData {
                        Label("\(data.count / 1024)KB captured", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(AppTheme.Font.body)
                    }

                    if !extractedText.isEmpty {
                        FormField(label: "Text found in document") {
                            Text(extractedText)
                                .font(AppTheme.Font.label)
                                .padding(AppTheme.Spacing.md)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                        }
                    }

                    FormField(label: "Document Title") {
                        VoiceTextField(placeholder: "e.g. Blood Test Results June 2024", text: $title)
                    }

                    FormField(label: "Document Type") {
                        Picker("Category", selection: $category) {
                            ForEach(DocumentCategory.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Any notes about this document…", text: $notes, axis: .vertical)
                    }

                    PrimaryButton("Save Document", icon: "checkmark.circle.fill", color: AppTheme.Section.history) { save() }
                        .disabled(title.isEmpty || capturedData == nil)
                        .opacity(title.isEmpty || capturedData == nil ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Add Document")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
            .sheet(isPresented: $showCapture) {
                DocumentCaptureView(capturedData: $capturedData, extractedText: $extractedText)
            }
        }
    }

    private func save() {
        guard let data = capturedData else { return }
        let doc = Document(title: title, category: category, fileData: data, notes: notes)
        doc.member = member; context.insert(doc); try? context.save(); dismiss()
    }
}
