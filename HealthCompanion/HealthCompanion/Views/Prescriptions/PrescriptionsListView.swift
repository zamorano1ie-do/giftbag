import SwiftUI
import SwiftData

struct PrescriptionsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var showActiveOnly = true

    private var filtered: [Prescription] {
        member.prescriptions
            .filter { showActiveOnly ? $0.isActive : true }
            .sorted { $0.startDate > $1.startDate }
    }

    var body: some View {
        NavigationStack {
            Group {
                if member.prescriptions.isEmpty {
                    EmptyStateView(
                        icon: "pill.fill",
                        title: "No Medications Recorded",
                        message: "Add your current and past prescriptions to track what you're taking.",
                        buttonTitle: "Add Medication"
                    ) { showAdd = true }
                } else {
                    list
                }
            }
            .navigationTitle("Prescriptions")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus").font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddPrescriptionView(member: member)
            }
        }
    }

    private var list: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                Toggle("Current medications only", isOn: $showActiveOnly)
                    .font(AppTheme.Font.body)
                    .padding(AppTheme.Spacing.md)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))

                ForEach(filtered) { rx in
                    NavigationLink(destination: PrescriptionDetailView(prescription: rx)) {
                        PrescriptionCard(prescription: rx)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct PrescriptionCard: View {
    let prescription: Prescription

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.md) {
                IconBadge(icon: prescription.form.icon, color: AppTheme.Section.prescriptions, size: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(prescription.medicationName)
                        .font(AppTheme.Font.subhead)
                        .fontWeight(.semibold)
                    if !prescription.genericName.isEmpty {
                        Text(prescription.genericName)
                            .font(AppTheme.Font.caption)
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                    Text(prescription.displayDosage)
                        .font(AppTheme.Font.label)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    StatusPill(
                        label: prescription.isActive ? "Active" : "Stopped",
                        color: prescription.isActive ? .green : .secondary
                    )
                    if prescription.isExpiringSoon {
                        StatusPill(label: "Expiring soon", color: .orange)
                    }
                    Text(prescription.frequency)
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                }
            }

            if !prescription.reason.isEmpty {
                Text("For: \(prescription.reason)")
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
            }

            HStack {
                if !prescription.prescribedBy.isEmpty {
                    Label("Dr. \(prescription.prescribedBy)", systemImage: "person.fill")
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("Started \(prescription.startDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(AppTheme.Font.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }
}

struct PrescriptionDetailView: View {
    let prescription: Prescription

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                // Header
                HStack(spacing: AppTheme.Spacing.md) {
                    IconBadge(icon: prescription.form.icon, color: AppTheme.Section.prescriptions, size: 60)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(prescription.medicationName)
                            .font(AppTheme.Font.title)
                            .fontWeight(.bold)
                        if !prescription.genericName.isEmpty {
                            Text(prescription.genericName)
                                .font(AppTheme.Font.body)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                        StatusPill(
                            label: prescription.isActive ? "Currently Taking" : "No Longer Taking",
                            color: prescription.isActive ? .green : .secondary
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))

                SectionCard {
                    VStack(spacing: 0) {
                        DetailRow(label: "Dosage", value: prescription.displayDosage)
                        Divider()
                        DetailRow(label: "Frequency", value: prescription.frequency)
                        if !prescription.instructions.isEmpty {
                            Divider()
                            DetailRow(label: "Instructions", value: prescription.instructions)
                        }
                        if !prescription.reason.isEmpty {
                            Divider()
                            DetailRow(label: "Prescribed For", value: prescription.reason)
                        }
                        if !prescription.prescribedBy.isEmpty {
                            Divider()
                            DetailRow(label: "Prescribed By", value: "Dr. \(prescription.prescribedBy)")
                        }
                        if !prescription.pharmacy.isEmpty {
                            Divider()
                            DetailRow(label: "Pharmacy", value: prescription.pharmacy)
                        }
                        Divider()
                        DetailRow(label: "Start Date", value: prescription.startDate.formatted(date: .long, time: .omitted))
                        if let end = prescription.endDate {
                            Divider()
                            DetailRow(label: "End Date", value: end.formatted(date: .long, time: .omitted))
                        }
                        if prescription.refillsRemaining > 0 {
                            Divider()
                            DetailRow(label: "Refills Remaining", value: "\(prescription.refillsRemaining)")
                        }
                    }
                }

                if !prescription.sideEffectsNoted.isEmpty {
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Side Effects Noted", systemImage: "exclamationmark.triangle.fill")
                                .font(AppTheme.Font.heading)
                                .foregroundStyle(.orange)
                            Text(prescription.sideEffectsNoted)
                                .font(AppTheme.Font.body)
                        }
                    }
                }

                if !prescription.changes.isEmpty {
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Dosage History", systemImage: "clock.arrow.circlepath")
                            .font(AppTheme.Font.heading)

                        ForEach(prescription.changes.sorted { $0.date > $1.date }) { change in
                            SectionCard {
                                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                                    Text(change.date.formatted(date: .long, time: .omitted))
                                        .font(AppTheme.Font.label)
                                        .foregroundStyle(.secondary)
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("Was").font(AppTheme.Font.caption).foregroundStyle(.secondary)
                                            Text(change.previousDosage).font(AppTheme.Font.subhead).strikethrough()
                                        }
                                        Image(systemName: "arrow.right").foregroundStyle(.secondary)
                                        VStack(alignment: .leading) {
                                            Text("Changed to").font(AppTheme.Font.caption).foregroundStyle(.secondary)
                                            Text(change.newDosage).font(AppTheme.Font.subhead).fontWeight(.semibold)
                                        }
                                    }
                                    if !change.reason.isEmpty {
                                        Text("Reason: \(change.reason)").font(AppTheme.Font.label).foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }

                if !prescription.notes.isEmpty {
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Notes", systemImage: "note.text")
                                .font(AppTheme.Font.heading)
                            Text(prescription.notes)
                                .font(AppTheme.Font.body)
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Medication")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(AppTheme.Font.label)
                .foregroundStyle(.secondary)
                .frame(width: 150, alignment: .leading)
            Text(value)
                .font(AppTheme.Font.body)
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, AppTheme.Spacing.md)
        .frame(minHeight: 44)
    }
}
