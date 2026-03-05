import SwiftUI
import SwiftData

struct VisionHearingListView: View {
    let member: FamilyMember
    @State private var showAddVision = false
    @State private var showAddHearing = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.lg) {

                // Vision tests
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Label("Eye Tests", systemImage: "eye.fill")
                            .font(AppTheme.Font.heading)
                        Spacer()
                        Button { showAddVision = true } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(AppTheme.Section.vision)
                        }
                        .accessibilityLabel("Add eye test")
                    }

                    if member.visionTests.isEmpty {
                        emptyState("No Eye Tests", "Add your eye test results and prescriptions.")
                    } else {
                        ForEach(member.visionTests.sorted { $0.date > $1.date }) { test in
                            VisionTestCard(test: test)
                        }
                    }
                }

                Divider()

                // Hearing tests
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Label("Hearing Tests", systemImage: "ear.fill")
                            .font(AppTheme.Font.heading)
                        Spacer()
                        Button { showAddHearing = true } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundStyle(AppTheme.Section.hearing)
                        }
                        .accessibilityLabel("Add hearing test")
                    }

                    if member.hearingTests.isEmpty {
                        emptyState("No Hearing Tests", "Add your audiogram and hearing test results.")
                    } else {
                        ForEach(member.hearingTests.sorted { $0.date > $1.date }) { test in
                            HearingTestCard(test: test)
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(AppTheme.Background.grouped)
        .sheet(isPresented: $showAddVision) { AddVisionTestView(member: member) }
        .sheet(isPresented: $showAddHearing) { AddHearingTestView(member: member) }
    }
}

// MARK: - Vision Test Card

struct VisionTestCard: View {
    let test: VisionTest
    @State private var expanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button { withAnimation { expanded.toggle() } } label: {
                HStack(spacing: AppTheme.Spacing.md) {
                    IconBadge(icon: "eye.fill", color: AppTheme.Section.vision, size: 48)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(test.date.formatted(date: .long, time: .omitted))
                            .font(AppTheme.Font.subhead).fontWeight(.semibold)
                        if !test.optometrist.isEmpty {
                            Text("with \(test.optometrist)").font(AppTheme.Font.caption).foregroundStyle(.secondary)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("R: \(test.rightEyeAcuity)")
                            .font(AppTheme.Font.label).fontWeight(.semibold)
                        Text("L: \(test.leftEyeAcuity)")
                            .font(AppTheme.Font.label).fontWeight(.semibold)
                    }
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(AppTheme.Font.caption).foregroundStyle(.secondary)
                }
                .padding(AppTheme.Spacing.md)
                .frame(minHeight: AppTheme.tapTargetHeight)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expanded {
                Divider()
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    // Acuity
                    Text("Visual Acuity (unaided)")
                        .font(AppTheme.Font.label).foregroundStyle(.secondary)
                    HStack {
                        EyeValueBadge(eye: "Right", value: test.rightEyeAcuity, color: AppTheme.Section.vision)
                        Spacer()
                        EyeValueBadge(eye: "Left", value: test.leftEyeAcuity, color: AppTheme.Section.vision)
                    }

                    // Prescription
                    if test.rightEyeSphere != nil || test.leftEyeSphere != nil {
                        Divider()
                        Text("Glasses / Contact Lens Prescription")
                            .font(AppTheme.Font.label).foregroundStyle(.secondary)

                        VStack(spacing: AppTheme.Spacing.sm) {
                            HStack {
                                Text("").frame(width: 60)
                                Text("SPH").font(AppTheme.Font.caption).frame(maxWidth: .infinity)
                                Text("CYL").font(AppTheme.Font.caption).frame(maxWidth: .infinity)
                                Text("Axis").font(AppTheme.Font.caption).frame(maxWidth: .infinity)
                                Text("Add").font(AppTheme.Font.caption).frame(maxWidth: .infinity)
                            }
                            .foregroundStyle(.secondary)

                            HStack {
                                Text("Right").font(AppTheme.Font.label).fontWeight(.semibold).frame(width: 60)
                                Text(test.sphereDisplay(test.rightEyeSphere)).font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.sphereDisplay(test.rightEyeCylinder)).font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.rightEyeAxis.map { "\($0)°" } ?? "-").font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.rightEyeAdd.map { "+\(String(format: "%.2f", $0))" } ?? "-").font(AppTheme.Font.body).frame(maxWidth: .infinity)
                            }
                            HStack {
                                Text("Left").font(AppTheme.Font.label).fontWeight(.semibold).frame(width: 60)
                                Text(test.sphereDisplay(test.leftEyeSphere)).font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.sphereDisplay(test.leftEyeCylinder)).font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.leftEyeAxis.map { "\($0)°" } ?? "-").font(AppTheme.Font.body).frame(maxWidth: .infinity)
                                Text(test.leftEyeAdd.map { "+\(String(format: "%.2f", $0))" } ?? "-").font(AppTheme.Font.body).frame(maxWidth: .infinity)
                            }
                        }
                        .padding(AppTheme.Spacing.sm)
                        .background(Color(.tertiarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))

                        if let pd = test.pupillaryDistance {
                            LabelValueRow(label: "PD", value: "\(String(format: "%.1f", pd)) mm")
                        }
                    }

                    if let iop_r = test.intraocularPressureRight, let iop_l = test.intraocularPressureLeft {
                        Divider()
                        LabelValueRow(label: "Eye Pressure", value: "R: \(Int(iop_r)) / L: \(Int(iop_l)) mmHg")
                    }
                    if !test.notes.isEmpty {
                        LabelValueRow(label: "Notes", value: test.notes)
                    }
                }
                .padding([.horizontal, .bottom], AppTheme.Spacing.md)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }
}

// MARK: - Hearing Test Card

struct HearingTestCard: View {
    let test: HearingTest

    private func levelColor(_ level: HearingLevel) -> Color {
        switch level {
        case .normal: return .green
        case .mild: return .yellow
        case .moderate: return .orange
        case .moderatelySevere, .severe: return .red
        case .profound: return Color(red: 0.7, green: 0, blue: 0)
        }
    }

    var body: some View {
        SectionCard {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                HStack(spacing: AppTheme.Spacing.md) {
                    IconBadge(icon: "ear.fill", color: AppTheme.Section.hearing, size: 48)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(test.date.formatted(date: .long, time: .omitted))
                            .font(AppTheme.Font.subhead).fontWeight(.semibold)
                        Text(test.type.rawValue).font(AppTheme.Font.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                }

                HStack {
                    EyeValueBadge(eye: "Right", value: test.rightEarResult.rawValue, color: levelColor(test.rightEarResult))
                    Spacer()
                    EyeValueBadge(eye: "Left", value: test.leftEarResult.rawValue, color: levelColor(test.leftEarResult))
                }

                if test.tinnitus {
                    Label("Tinnitus reported", systemImage: "waveform").font(AppTheme.Font.label).foregroundStyle(.secondary)
                }
                if test.hearingAidRecommended {
                    Label("Hearing aid recommended", systemImage: "ear.badge.checkmark")
                        .font(AppTheme.Font.label).foregroundStyle(.orange)
                }
                if !test.notes.isEmpty {
                    Text(test.notes).font(AppTheme.Font.label).foregroundStyle(.secondary)
                }
            }
        }
    }
}

struct EyeValueBadge: View {
    let eye: String
    let value: String
    let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(eye).font(AppTheme.Font.caption).foregroundStyle(.secondary)
            Text(value).font(AppTheme.Font.label).fontWeight(.semibold)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .background(color.opacity(0.15)).foregroundStyle(color)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
