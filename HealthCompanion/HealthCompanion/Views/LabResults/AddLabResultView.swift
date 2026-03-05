import SwiftUI
import SwiftData

struct AddLabResultView: View {
    let member: FamilyMember

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var testName = ""
    @State private var category: LabCategory = .bloodCount
    @State private var valueText = ""
    @State private var unit = ""
    @State private var refLow = ""
    @State private var refHigh = ""
    @State private var status: LabResultStatus = .normal
    @State private var testedAt = Date()
    @State private var lab = ""
    @State private var orderedBy = ""
    @State private var notes = ""
    @State private var showCommonTests = false
    @State private var showCamera = false
    @State private var capturedData: Data?
    @State private var extractedText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    // Quick fill from common tests
                    Button {
                        showCommonTests = true
                    } label: {
                        HStack {
                            Image(systemName: "list.star")
                            Text("Choose from Common Tests")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .font(AppTheme.Font.body)
                        .padding(AppTheme.Spacing.md)
                        .background(Color.accentColor.opacity(0.1))
                        .foregroundStyle(.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    .buttonStyle(.plain)

                    // Scan from document
                    CameraCaptureButton {
                        showCamera = true
                    }

                    Divider()

                    // Test name
                    FormField(label: "Test Name") {
                        VoiceTextField(placeholder: "e.g. Haemoglobin", text: $testName)
                    }

                    // Category
                    FormField(label: "Category") {
                        Picker("Category", selection: $category) {
                            ForEach(LabCategory.allCases, id: \.self) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    // Value + unit
                    HStack(alignment: .top, spacing: AppTheme.Spacing.md) {
                        FormField(label: "Result Value") {
                            TextField("e.g. 14.5", text: $valueText)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .padding(AppTheme.Spacing.md)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                        }

                        FormField(label: "Unit") {
                            VoiceTextField(placeholder: "g/dL", text: $unit)
                        }
                    }

                    // Reference range
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Normal Range (optional)", systemImage: "chart.bar.fill")
                            .font(AppTheme.Font.heading)
                        HStack(spacing: AppTheme.Spacing.md) {
                            TextField("Low", text: $refLow)
                                .keyboardType(.decimalPad)
                                .padding(AppTheme.Spacing.md)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                            Text("to")
                                .foregroundStyle(.secondary)
                            TextField("High", text: $refHigh)
                                .keyboardType(.decimalPad)
                                .padding(AppTheme.Spacing.md)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                        }
                    }

                    FormField(label: "Test Date") {
                        DatePicker("", selection: $testedAt, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Laboratory") {
                        VoiceTextField(placeholder: "e.g. City Path Lab", text: $lab)
                    }

                    FormField(label: "Ordered by Doctor") {
                        VoiceTextField(placeholder: "e.g. Dr. Smith", text: $orderedBy)
                    }

                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Any additional notes…", text: $notes, axis: .vertical)
                    }

                    PrimaryButton("Save Lab Result", icon: "checkmark.circle.fill", color: AppTheme.Section.labs) {
                        save()
                    }
                    .disabled(testName.isEmpty || valueText.isEmpty)
                    .opacity(testName.isEmpty || valueText.isEmpty ? 0.5 : 1)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Add Lab Result")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.font(AppTheme.Font.body)
                }
            }
            .sheet(isPresented: $showCommonTests) {
                CommonTestPickerView { test, sex in
                    testName = test.name
                    category = test.category
                    unit = test.unit
                    let low = sex == .male ? test.lowMale : test.lowFemale
                    let high = sex == .male ? test.highMale : test.highFemale
                    refLow = low.map { String(format: "%.2f", $0) } ?? ""
                    refHigh = high.map { String(format: "%.2f", $0) } ?? ""
                    showCommonTests = false
                }
            }
            .sheet(isPresented: $showCamera) {
                DocumentCaptureView(capturedData: $capturedData, extractedText: $extractedText)
            }
        }
    }

    private func save() {
        let result = LabResult(
            testName: testName,
            category: category,
            value: Double(valueText) ?? 0,
            unit: unit,
            referenceRangeLow: Double(refLow),
            referenceRangeHigh: Double(refHigh),
            testedAt: testedAt,
            lab: lab,
            orderedBy: orderedBy,
            notes: notes
        )
        result.member = member
        context.insert(result)
        try? context.save()
        dismiss()
    }
}

// MARK: - Common test picker

struct CommonTestPickerView: View {
    let onSelect: (CommonLabTest, BiologicalSex) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var sex: BiologicalSex = .male
    @State private var search = ""

    private var tests: [CommonLabTest] {
        search.isEmpty ? CommonLabTest.all
            : CommonLabTest.all.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Sex", selection: $sex) {
                    Text("Male values").tag(BiologicalSex.male)
                    Text("Female values").tag(BiologicalSex.female)
                }
                .pickerStyle(.segmented)
                .padding(AppTheme.Spacing.md)

                List(tests, id: \.name) { test in
                    Button {
                        onSelect(test, sex)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(test.name).font(AppTheme.Font.subhead)
                                Text(test.category.rawValue).font(AppTheme.Font.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                let low = sex == .male ? test.lowMale : test.lowFemale
                                let high = sex == .male ? test.highMale : test.highFemale
                                let range = [low.map { String(format: "%.1f", $0) }, high.map { String(format: "%.1f", $0) }]
                                    .compactMap { $0 }.joined(separator: " – ")
                                Text(range.isEmpty ? "–" : range)
                                    .font(AppTheme.Font.label)
                                    .foregroundStyle(.secondary)
                                Text(test.unit)
                                    .font(AppTheme.Font.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(minHeight: AppTheme.tapTargetHeight)
                    }
                    .buttonStyle(.plain)
                }
                .searchable(text: $search, prompt: "Search tests…")
            }
            .navigationTitle("Common Lab Tests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Form field helper

struct FormField<Content: View>: View {
    let label: String
    let content: Content
    init(label: String, @ViewBuilder content: () -> Content) {
        self.label = label
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(label)
                .font(AppTheme.Font.heading)
            content
        }
    }
}
