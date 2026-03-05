import SwiftUI
import SwiftData

struct MedicalHistoryView: View {
    let member: FamilyMember
    @State private var selectedSection: HistorySection = .conditions
    @State private var showAdd = false

    enum HistorySection: String, CaseIterable {
        case conditions  = "Conditions"
        case surgeries   = "Surgeries"
        case allergies   = "Allergies"
        case vaccinations = "Vaccinations"
        case visionHearing = "Eyes & Ears"
        case documents   = "Documents"

        var icon: String {
            switch self {
            case .conditions:   return "cross.fill"
            case .surgeries:    return "scissors"
            case .allergies:    return "allergens.fill"
            case .vaccinations: return "syringe.fill"
            case .visionHearing: return "eye.fill"
            case .documents:    return "doc.fill"
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                sectionPicker
                content
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Medical History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus").font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                addSheet
            }
        }
    }

    private var sectionPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                ForEach(HistorySection.allCases, id: \.self) { section in
                    Button {
                        selectedSection = section
                    } label: {
                        Label(section.rawValue, systemImage: section.icon)
                            .font(AppTheme.Font.label)
                            .fontWeight(selectedSection == section ? .semibold : .regular)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(selectedSection == section ? Color.accentColor : Color(.secondarySystemBackground))
                            .foregroundStyle(selectedSection == section ? .white : .primary)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.secondarySystemBackground))
    }

    @ViewBuilder
    private var content: some View {
        switch selectedSection {
        case .conditions:   ConditionsSection(member: member)
        case .surgeries:    SurgeriesSection(member: member)
        case .allergies:    AllergiesSection(member: member)
        case .vaccinations: VaccinationsSection(member: member)
        case .visionHearing: VisionHearingListView(member: member)
        case .documents:    DocumentsSection(member: member)
        }
    }

    @ViewBuilder
    private var addSheet: some View {
        switch selectedSection {
        case .conditions:   AddConditionView(member: member)
        case .surgeries:    AddSurgeryView(member: member)
        case .allergies:    AddAllergyView(member: member)
        case .vaccinations: AddVaccinationView(member: member)
        case .visionHearing: AddVisionTestView(member: member)
        case .documents:    AddDocumentView(member: member)
        }
    }
}

// MARK: - Conditions

struct ConditionsSection: View {
    let member: FamilyMember

    var body: some View {
        ScrollView {
            if member.conditions.isEmpty {
                emptyState("No Conditions Recorded", "Add any medical conditions, chronic illnesses, or past diagnoses.")
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(member.conditions.sorted { $0.isActive && !$1.isActive }) { cond in
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                HStack {
                                    Text(cond.name)
                                        .font(AppTheme.Font.subhead)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    StatusPill(label: cond.isActive ? "Active" : "Resolved", color: cond.isActive ? .orange : .green)
                                    if cond.isChronic {
                                        StatusPill(label: "Chronic", color: .red)
                                    }
                                }
                                Text(cond.category.rawValue)
                                    .font(AppTheme.Font.caption)
                                    .foregroundStyle(.secondary)
                                if let date = cond.diagnosedDate {
                                    LabelValueRow(label: "Diagnosed", value: date.formatted(date: .long, time: .omitted))
                                }
                                if !cond.diagnosedBy.isEmpty {
                                    LabelValueRow(label: "By", value: "Dr. \(cond.diagnosedBy)")
                                }
                                if !cond.treatment.isEmpty {
                                    LabelValueRow(label: "Treatment", value: cond.treatment)
                                }
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}

// MARK: - Allergies

struct AllergiesSection: View {
    let member: FamilyMember

    private func severityColor(_ s: AllergySeverity) -> Color {
        switch s {
        case .mild: return .yellow
        case .moderate: return .orange
        case .severe: return .red
        }
    }

    var body: some View {
        ScrollView {
            if member.allergies.isEmpty {
                emptyState("No Allergies Recorded", "Add medication, food, and environmental allergies.")
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(member.allergies.sorted { $0.severity.rawValue > $1.severity.rawValue }) { allergy in
                        SectionCard {
                            HStack(spacing: AppTheme.Spacing.md) {
                                IconBadge(icon: "allergens.fill", color: severityColor(allergy.severity), size: 44)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(allergy.allergen)
                                        .font(AppTheme.Font.subhead)
                                        .fontWeight(.semibold)
                                    Text(allergy.category.rawValue)
                                        .font(AppTheme.Font.caption)
                                        .foregroundStyle(.secondary)
                                    if !allergy.reaction.isEmpty {
                                        Text("Reaction: \(allergy.reaction)")
                                            .font(AppTheme.Font.label)
                                    }
                                }
                                Spacer()
                                StatusPill(label: allergy.severity.rawValue, color: severityColor(allergy.severity))
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}

// MARK: - Surgeries

struct SurgeriesSection: View {
    let member: FamilyMember

    var body: some View {
        ScrollView {
            if member.surgeries.isEmpty {
                emptyState("No Surgeries Recorded", "Add any operations or major procedures you've had.")
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(member.surgeries.sorted { $0.date > $1.date }) { surgery in
                        SectionCard {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                HStack {
                                    Text(surgery.name)
                                        .font(AppTheme.Font.subhead)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(surgery.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(AppTheme.Font.label)
                                        .foregroundStyle(.secondary)
                                }
                                if !surgery.surgeon.isEmpty { LabelValueRow(label: "Surgeon", value: "Dr. \(surgery.surgeon)") }
                                if !surgery.hospital.isEmpty { LabelValueRow(label: "Hospital", value: surgery.hospital) }
                                if !surgery.reason.isEmpty { LabelValueRow(label: "Reason", value: surgery.reason) }
                                if !surgery.outcome.isEmpty { LabelValueRow(label: "Outcome", value: surgery.outcome) }
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}

// MARK: - Vaccinations

struct VaccinationsSection: View {
    let member: FamilyMember

    var body: some View {
        ScrollView {
            if member.vaccinations.isEmpty {
                emptyState("No Vaccinations Recorded", "Keep track of your vaccines and when the next dose is due.")
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    let overdue = member.vaccinations.filter { $0.isDue }
                    let dueSoon = member.vaccinations.filter { !$0.isDue && $0.isDueSoon }

                    if !overdue.isEmpty {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Overdue", systemImage: "exclamationmark.circle.fill")
                                .font(AppTheme.Font.heading).foregroundStyle(.red)
                            ForEach(overdue) { v in VaccinationRow(vaccination: v) }
                        }
                    }
                    if !dueSoon.isEmpty {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Due Soon", systemImage: "clock.fill")
                                .font(AppTheme.Font.heading).foregroundStyle(.orange)
                            ForEach(dueSoon) { v in VaccinationRow(vaccination: v) }
                        }
                    }
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("All Vaccinations", systemImage: "syringe.fill")
                            .font(AppTheme.Font.heading)
                        ForEach(member.vaccinations.sorted { $0.date > $1.date }) { v in VaccinationRow(vaccination: v) }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}

struct VaccinationRow: View {
    let vaccination: Vaccination
    var body: some View {
        SectionCard {
            HStack(spacing: AppTheme.Spacing.md) {
                IconBadge(icon: "syringe.fill", color: vaccination.isDue ? .red : .green, size: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(vaccination.name).font(AppTheme.Font.subhead).fontWeight(.semibold)
                    Text("Given: \(vaccination.date.formatted(date: .abbreviated, time: .omitted))")
                        .font(AppTheme.Font.caption).foregroundStyle(.secondary)
                    if let next = vaccination.nextDueDate {
                        Text("Next due: \(next.formatted(date: .abbreviated, time: .omitted))")
                            .font(AppTheme.Font.caption)
                            .foregroundStyle(vaccination.isDue ? .red : .secondary)
                    }
                }
                Spacer()
            }
        }
    }
}

// MARK: - Documents

struct DocumentsSection: View {
    let member: FamilyMember

    var body: some View {
        ScrollView {
            if member.documents.isEmpty {
                emptyState("No Documents", "Scan or upload prescriptions, lab reports, referrals, and more.")
            } else {
                VStack(spacing: AppTheme.Spacing.md) {
                    ForEach(member.documents.sorted { $0.uploadedAt > $1.uploadedAt }) { doc in
                        SectionCard {
                            HStack(spacing: AppTheme.Spacing.md) {
                                IconBadge(icon: doc.category.icon, color: AppTheme.Section.history, size: 44)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(doc.title).font(AppTheme.Font.subhead).fontWeight(.semibold)
                                    Text(doc.category.rawValue).font(AppTheme.Font.caption).foregroundStyle(.secondary)
                                    Text("Saved \(doc.uploadedAt.formatted(date: .abbreviated, time: .omitted))")
                                        .font(AppTheme.Font.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right").foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
        }
    }
}

// MARK: - Helper

@ViewBuilder
func emptyState(_ title: String, _ message: String) -> some View {
    VStack(spacing: AppTheme.Spacing.md) {
        Spacer()
        Image(systemName: "tray")
            .font(.system(size: 56))
            .foregroundStyle(.secondary)
        Text(title)
            .font(AppTheme.Font.heading)
            .multilineTextAlignment(.center)
        Text(message)
            .font(AppTheme.Font.body)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppTheme.Spacing.xl)
        Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 60)
}
