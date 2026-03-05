import SwiftUI
import SwiftData

struct DashboardView: View {
    let member: FamilyMember
    @State private var showQuickAdd = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Greeting banner
                    greetingBanner

                    // Alerts (overdue vaccinations, expiring Rx, abnormal labs)
                    alertsSection

                    // Quick stats grid
                    quickStatsGrid

                    // Recent activity
                    recentActivity

                    // Quick add section
                    quickAddSection
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("My Health")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showQuickAdd) {
                QuickAddView(member: member)
            }
        }
    }

    // MARK: - Greeting

    private var greetingBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(AppTheme.Font.heading)
                    .foregroundStyle(Color.sage)
                Text(member.firstName)
                    .font(AppTheme.Font.hero)
                    .foregroundStyle(Color.warmBrown)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .font(AppTheme.Font.label)
                    .foregroundStyle(.secondary)
                if member.age > 0 {
                    Text("Age \(member.age)")
                        .font(AppTheme.Font.label)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(Color.blush.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default:      return "Good evening,"
        }
    }

    // MARK: - Alerts

    @ViewBuilder
    private var alertsSection: some View {
        let alerts = buildAlerts()
        if !alerts.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Label("Things to Check", systemImage: "bell.badge.fill")
                    .font(AppTheme.Font.heading)
                    .foregroundStyle(Color.rose)

                ForEach(alerts, id: \.self) { alert in
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(Color.rose)
                            .font(.title3)
                        Text(alert)
                            .font(AppTheme.Font.body)
                            .foregroundStyle(Color.warmBrown)
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(Color.blush.opacity(0.22))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                }
            }
        }
    }

    private func buildAlerts() -> [String] {
        var alerts: [String] = []

        // Expiring prescriptions
        let expiringRx = member.prescriptions.filter { $0.isActive && $0.isExpiringSoon }
        for rx in expiringRx {
            alerts.append("\(rx.medicationName) prescription expires soon")
        }

        // Overdue vaccinations
        let overdueVaccines = member.vaccinations.filter { $0.isDue }
        for vax in overdueVaccines {
            alerts.append("\(vax.name) vaccination is overdue")
        }

        // Abnormal lab results in last 3 months
        let recentAbnormalLabs = member.labResults.filter {
            $0.computedStatus != .normal && $0.computedStatus != .pending &&
            $0.testedAt > Calendar.current.date(byAdding: .month, value: -3, to: Date())!
        }
        if !recentAbnormalLabs.isEmpty {
            alerts.append("\(recentAbnormalLabs.count) recent lab result(s) outside normal range")
        }

        // Upcoming appointments
        let upcoming = member.appointments.filter {
            !$0.isPast && $0.date.timeIntervalSinceNow < 7 * 24 * 3600
        }
        for appt in upcoming {
            alerts.append("Appointment with \(appt.doctorName) on \(appt.date.formatted(date: .abbreviated, time: .shortened))")
        }
        _ = upcoming // suppress warning

        return Array(alerts.prefix(4))
    }

    // MARK: - Quick Stats Grid

    private var quickStatsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: AppTheme.Spacing.md) {
            StatCard(
                title: "Active Medications",
                value: "\(member.activePrescriptions.count)",
                icon: "pill.fill",
                color: AppTheme.Section.prescriptions
            )
            StatCard(
                title: "Conditions",
                value: "\(member.activeConditions.count)",
                icon: "cross.fill",
                color: AppTheme.Section.history
            )
            StatCard(
                title: "Appointments",
                value: "\(member.appointments.filter { !$0.isPast }.count)",
                icon: "stethoscope",
                color: AppTheme.Section.appointments,
                subtitle: "upcoming"
            )
            StatCard(
                title: "Allergies",
                value: "\(member.allergies.count)",
                icon: "allergens.fill",
                color: AppTheme.Section.vitals
            )
        }
    }

    // MARK: - Recent Activity

    @ViewBuilder
    private var recentActivity: some View {
        let recentVitals = Array(member.vitals.sorted { $0.recordedAt > $1.recordedAt }.prefix(3))
        if !recentVitals.isEmpty {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Recent Vitals")
                    .font(AppTheme.Font.heading)

                ForEach(recentVitals) { vital in
                    HStack {
                        IconBadge(icon: vital.type.icon, color: AppTheme.Section.vitals, size: 40)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(vital.type.rawValue)
                                .font(AppTheme.Font.subhead)
                            Text(vital.recordedAt.formatted(date: .abbreviated, time: .omitted))
                                .font(AppTheme.Font.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(vital.displayValue)
                            .font(AppTheme.Font.subhead)
                            .fontWeight(.semibold)
                    }
                    .padding(AppTheme.Spacing.md)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))
                }
            }
        }
    }

    // MARK: - Quick Add

    private var quickAddSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text("Record Something")
                .font(AppTheme.Font.heading)

            PrimaryButton("Add Health Information", icon: "plus.circle.fill") {
                showQuickAdd = true
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    var subtitle: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            IconBadge(icon: icon, color: color, size: 40)
            Spacer()
            Text(value)
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Text(subtitle.isEmpty ? title : subtitle)
                .font(AppTheme.Font.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(AppTheme.Spacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        .frame(minHeight: 130)
    }
}

// MARK: - Quick Add Sheet

struct QuickAddView: View {
    let member: FamilyMember
    @Environment(\.dismiss) private var dismiss

    private let options: [(String, String, Color, AnyView)] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.md) {
                    Text("What would you like to record?")
                        .font(AppTheme.Font.heading)
                        .multilineTextAlignment(.center)
                        .padding(.top)

                    QuickAddButton(title: "Blood Pressure\nor Pulse", icon: "heart.fill", color: AppTheme.Section.vitals, destination: AnyView(AddVitalView(member: member, preselectedType: .bloodPressure)))
                    QuickAddButton(title: "Weight", icon: "scalemass.fill", color: AppTheme.Section.vitals, destination: AnyView(AddVitalView(member: member, preselectedType: .weight)))
                    QuickAddButton(title: "Lab Result", icon: "drop.fill", color: AppTheme.Section.labs, destination: AnyView(AddLabResultView(member: member)))
                    QuickAddButton(title: "Doctor Visit", icon: "stethoscope", color: AppTheme.Section.appointments, destination: AnyView(AddAppointmentView(member: member)))
                    QuickAddButton(title: "Medication", icon: "pill.fill", color: AppTheme.Section.prescriptions, destination: AnyView(AddPrescriptionView(member: member)))
                    QuickAddButton(title: "Upload Document", icon: "doc.badge.plus", color: AppTheme.Section.history, destination: AnyView(AddDocumentView(member: member)))
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Record Health Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .font(AppTheme.Font.body)
                }
            }
        }
    }
}

struct QuickAddButton: View {
    let title: String
    let icon: String
    let color: Color
    let destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            HStack(spacing: AppTheme.Spacing.md) {
                IconBadge(icon: icon, color: color, size: 52)
                Text(title)
                    .font(AppTheme.Font.subhead)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(AppTheme.Spacing.md)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
            .frame(minHeight: AppTheme.tapTargetHeight)
        }
        .buttonStyle(.plain)
    }
}
