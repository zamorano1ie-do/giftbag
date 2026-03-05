import SwiftUI
import SwiftData

// MARK: - Add Vision Test

struct AddVisionTestView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var optometrist = ""
    @State private var clinic = ""
    // Acuity
    @State private var rNum = "6"; @State private var rDen = "6"
    @State private var lNum = "6"; @State private var lDen = "6"
    // Prescription
    @State private var hasPrescription = false
    @State private var rSph = ""; @State private var rCyl = ""; @State private var rAxis = ""; @State private var rAdd = ""
    @State private var lSph = ""; @State private var lCyl = ""; @State private var lAxis = ""; @State private var lAdd = ""
    @State private var pd = ""
    // IOP
    @State private var hasIOP = false
    @State private var iopR = ""; @State private var iopL = ""
    @State private var colourNormal = true
    @State private var notes = ""

    private let commonDenominators = ["5", "6", "9", "12", "18", "24", "36", "60"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    FormField(label: "Date of Test") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact).labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    FormField(label: "Optometrist") {
                        VoiceTextField(placeholder: "e.g. Mr. Patel", text: $optometrist)
                    }
                    FormField(label: "Clinic / Practice") {
                        VoiceTextField(placeholder: "e.g. SpecSavers, High Street", text: $clinic)
                    }

                    // Visual acuity
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Visual Acuity (without glasses)", systemImage: "eye")
                            .font(AppTheme.Font.heading)
                        Text("This is your 'reading the chart' score. Normal is 6/6.")
                            .font(AppTheme.Font.label).foregroundStyle(.secondary)
                        HStack(spacing: AppTheme.Spacing.md) {
                            AcuityInput(label: "Right Eye", numerator: $rNum, denominator: $rDen, options: commonDenominators)
                            AcuityInput(label: "Left Eye", numerator: $lNum, denominator: $lDen, options: commonDenominators)
                        }
                    }

                    // Prescription
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Toggle("I have a glasses/contact lens prescription", isOn: $hasPrescription)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            if hasPrescription {
                                Text("Leave blank if not applicable")
                                    .font(AppTheme.Font.caption).foregroundStyle(.secondary)
                                PrescriptionGrid(
                                    eye: "Right Eye",
                                    sph: $rSph, cyl: $rCyl, axis: $rAxis, add: $rAdd
                                )
                                PrescriptionGrid(
                                    eye: "Left Eye",
                                    sph: $lSph, cyl: $lCyl, axis: $lAxis, add: $lAdd
                                )
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("PD (Pupillary Distance) in mm")
                                        .font(AppTheme.Font.label).foregroundStyle(.secondary)
                                    TextField("e.g. 64.5", text: $pd)
                                        .keyboardType(.decimalPad)
                                        .font(.system(size: 22, weight: .bold, design: .rounded))
                                        .padding(AppTheme.Spacing.md)
                                        .background(Color(.tertiarySystemBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                }
                            }
                        }
                    }

                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                            Toggle("Eye pressure (IOP) measured", isOn: $hasIOP)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            if hasIOP {
                                HStack(spacing: AppTheme.Spacing.md) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Right (mmHg)").font(AppTheme.Font.label).foregroundStyle(.secondary).minimumScaleFactor(0.5).lineLimit(1)
                                        TextField("e.g. 16", text: $iopR).keyboardType(.decimalPad)
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                            .padding(AppTheme.Spacing.md)
                                            .background(Color(.tertiarySystemBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Left (mmHg)").font(AppTheme.Font.label).foregroundStyle(.secondary).minimumScaleFactor(0.5).lineLimit(1)
                                        TextField("e.g. 16", text: $iopL).keyboardType(.decimalPad)
                                            .font(.system(size: 22, weight: .bold, design: .rounded))
                                            .padding(AppTheme.Spacing.md)
                                            .background(Color(.tertiarySystemBackground))
                                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                                    }
                                }
                            }
                        }
                    }

                    SectionCard {
                        Toggle("Colour vision normal", isOn: $colourNormal)
                            .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                    }

                    FormField(label: "Notes") {
                        VoiceTextField(placeholder: "Any additional notes from the optometrist…", text: $notes, axis: .vertical)
                    }

                    PrimaryButton("Save Eye Test", icon: "checkmark.circle.fill", color: AppTheme.Section.vision) { save() }
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Add Eye Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let t = VisionTest(
            date: date, optometrist: optometrist, clinic: clinic,
            rightEyeAcuityNumerator: Int(rNum) ?? 6,
            rightEyeAcuityDenominator: Int(rDen) ?? 6,
            leftEyeAcuityNumerator: Int(lNum) ?? 6,
            leftEyeAcuityDenominator: Int(lDen) ?? 6,
            rightEyeSphere: hasPrescription ? Double(rSph) : nil,
            rightEyeCylinder: hasPrescription ? Double(rCyl) : nil,
            rightEyeAxis: hasPrescription ? Int(rAxis) : nil,
            rightEyeAdd: hasPrescription ? Double(rAdd) : nil,
            leftEyeSphere: hasPrescription ? Double(lSph) : nil,
            leftEyeCylinder: hasPrescription ? Double(lCyl) : nil,
            leftEyeAxis: hasPrescription ? Int(lAxis) : nil,
            leftEyeAdd: hasPrescription ? Double(lAdd) : nil,
            pupillaryDistance: Double(pd),
            intraocularPressureRight: hasIOP ? Double(iopR) : nil,
            intraocularPressureLeft: hasIOP ? Double(iopL) : nil,
            colourVisionNormal: colourNormal, notes: notes
        )
        t.member = member; context.insert(t); try? context.save(); dismiss()
    }
}

struct AcuityInput: View {
    let label: String
    @Binding var numerator: String
    @Binding var denominator: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(label).font(AppTheme.Font.label).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                TextField("6", text: $numerator)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(width: 44)
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(Color(.tertiarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                Text("/").font(.system(size: 24, weight: .light))
                Menu {
                    ForEach(options, id: \.self) { opt in
                        Button(opt) { denominator = opt }
                    }
                } label: {
                    Text(denominator)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .frame(minWidth: 44)
                        .padding(8)
                        .background(Color.accentColor.opacity(0.1))
                        .foregroundStyle(.tint)
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                }
            }
        }
    }
}

struct PrescriptionGrid: View {
    let eye: String
    @Binding var sph: String
    @Binding var cyl: String
    @Binding var axis: String
    @Binding var add: String

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(eye).font(AppTheme.Font.subhead).fontWeight(.semibold)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.sm) {
                RxField(label: "SPH", placeholder: "e.g. -1.25", text: $sph)
                RxField(label: "CYL", placeholder: "e.g. -0.50", text: $cyl)
                RxField(label: "Axis", placeholder: "e.g. 90", text: $axis, isNumber: true)
                RxField(label: "Add", placeholder: "e.g. +1.00", text: $add)
            }
        }
        .padding(AppTheme.Spacing.sm)
        .background(Color(.tertiarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
    }
}

struct RxField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isNumber: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(AppTheme.Font.caption).foregroundStyle(.secondary)
            TextField(placeholder, text: $text)
                .keyboardType(isNumber ? .numberPad : .decimalPad)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(8)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Add Hearing Test

struct AddHearingTestView: View {
    let member: FamilyMember
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var audiologist = ""
    @State private var clinic = ""
    @State private var type: HearingTestType = .puretone
    @State private var rightResult: HearingLevel = .normal
    @State private var leftResult: HearingLevel = .normal
    @State private var tinnitus = false
    @State private var hearingAidRecommended = false
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    FormField(label: "Date of Test") {
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.compact).labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(AppTheme.Spacing.md)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }
                    FormField(label: "Audiologist") { VoiceTextField(placeholder: "e.g. Dr. Williams", text: $audiologist) }
                    FormField(label: "Clinic") { VoiceTextField(placeholder: "e.g. Hearing Centre", text: $clinic) }
                    FormField(label: "Type of Test") {
                        Picker("Type", selection: $type) {
                            ForEach(HearingTestType.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(AppTheme.Spacing.md)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Results", systemImage: "ear.fill").font(AppTheme.Font.heading)
                        HStack(spacing: AppTheme.Spacing.md) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Right Ear").font(AppTheme.Font.label).foregroundStyle(.secondary)
                                Picker("Right", selection: $rightResult) {
                                    ForEach(HearingLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTheme.Spacing.sm)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Left Ear").font(AppTheme.Font.label).foregroundStyle(.secondary)
                                Picker("Left", selection: $leftResult) {
                                    ForEach(HearingLevel.allCases, id: \.self) { Text($0.rawValue).tag($0) }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(AppTheme.Spacing.sm)
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                            }
                        }
                    }

                    SectionCard {
                        VStack(spacing: 0) {
                            Toggle("Tinnitus (ringing in ears) reported", isOn: $tinnitus)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                            Divider()
                            Toggle("Hearing aid recommended", isOn: $hearingAidRecommended)
                                .font(AppTheme.Font.subhead).frame(minHeight: AppTheme.tapTargetHeight)
                        }
                    }

                    FormField(label: "Notes") { VoiceTextField(placeholder: "Any notes from the audiologist…", text: $notes, axis: .vertical) }

                    PrimaryButton("Save Hearing Test", icon: "checkmark.circle.fill", color: AppTheme.Section.hearing) { save() }
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Add Hearing Test")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } } }
        }
    }

    private func save() {
        let t = HearingTest(date: date, audiologist: audiologist, clinic: clinic, type: type,
                            rightEarResult: rightResult, leftEarResult: leftResult,
                            tinnitus: tinnitus, hearingAidRecommended: hearingAidRecommended, notes: notes)
        t.member = member; context.insert(t); try? context.save(); dismiss()
    }
}
