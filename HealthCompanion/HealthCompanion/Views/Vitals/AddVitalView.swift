import SwiftUI
import SwiftData

struct AddVitalView: View {
    let member: FamilyMember
    var preselectedType: VitalType = .bloodPressure

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: VitalType
    @State private var valueText = ""
    @State private var secondaryValueText = ""
    @State private var date = Date()
    @State private var notes = ""
    @State private var isSaving = false

    init(member: FamilyMember, preselectedType: VitalType = .bloodPressure) {
        self.member = member
        self.preselectedType = preselectedType
        _selectedType = State(initialValue: preselectedType)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    // Type picker
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("What are you recording?", systemImage: "list.bullet")
                            .font(AppTheme.Font.heading)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: AppTheme.Spacing.sm) {
                                ForEach(VitalType.allCases, id: \.self) { type in
                                    Button {
                                        selectedType = type
                                        valueText = ""
                                        secondaryValueText = ""
                                    } label: {
                                        VStack(spacing: 6) {
                                            Image(systemName: type.icon)
                                                .font(.title2)
                                            Text(type.rawValue)
                                                .font(AppTheme.Font.caption)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 90, height: 80)
                                        .background(selectedType == type ? AppTheme.Section.vitals : Color(.tertiarySystemBackground))
                                        .foregroundStyle(selectedType == type ? .white : .primary)
                                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    // Value input
                    valueInputSection

                    // Date & time
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("When was this measured?", systemImage: "calendar")
                            .font(AppTheme.Font.heading)
                        DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    // Notes
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Notes (optional)", systemImage: "note.text")
                            .font(AppTheme.Font.heading)
                        VoiceTextField(placeholder: "e.g. taken after resting for 5 minutes", text: $notes, axis: .vertical)
                    }

                    // Save button
                    PrimaryButton("Save Reading", icon: "checkmark.circle.fill", color: AppTheme.Section.vitals) {
                        save()
                    }
                    .disabled(!isValid)
                    .opacity(isValid ? 1 : 0.5)
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Record Vital")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(AppTheme.Font.body)
                }
            }
        }
    }

    // MARK: - Value Input

    @ViewBuilder
    private var valueInputSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Label("Enter the value", systemImage: selectedType.icon)
                .font(AppTheme.Font.heading)

            switch selectedType {
            case .bloodPressure:
                bloodPressureInput

            case .height:
                heightInput

            default:
                singleValueInput
            }

            if !valueText.isEmpty || !secondaryValueText.isEmpty {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.secondary)
                    Text("Unit: \(selectedType.defaultUnit)")
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var bloodPressureInput: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Systolic (top number)")
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
                TextField("e.g. 120", text: $valueText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
            }

            Text("/")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 4) {
                Text("Diastolic (bottom number)")
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
                TextField("e.g. 80", text: $secondaryValueText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
            }
        }
    }

    private var heightInput: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Feet")
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
                TextField("5", text: $valueText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Inches")
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
                TextField("8", text: $secondaryValueText)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
            }
        }
    }

    private var singleValueInput: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Enter value", text: $valueText)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .keyboardType(.decimalPad)
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))

            HStack {
                Spacer()
                Text(selectedType.defaultUnit)
                    .font(AppTheme.Font.subhead)
                    .foregroundStyle(.secondary)
                    .padding(.trailing)
            }
        }
    }

    // MARK: - Logic

    private var isValid: Bool {
        guard let _ = Double(valueText) else { return false }
        if selectedType == .bloodPressure { return Double(secondaryValueText) != nil }
        return true
    }

    private func save() {
        guard let value = Double(valueText) else { return }
        let secondary = Double(secondaryValueText)

        let reading = VitalReading(
            type: selectedType,
            value: value,
            secondaryValue: secondary,
            unit: selectedType.defaultUnit,
            recordedAt: date,
            notes: notes
        )
        reading.member = member
        context.insert(reading)
        try? context.save()
        dismiss()
    }
}
