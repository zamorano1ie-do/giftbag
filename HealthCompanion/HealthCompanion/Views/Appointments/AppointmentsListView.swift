import SwiftUI
import SwiftData

struct AppointmentsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var showUpcomingOnly = false

    private var sorted: [Appointment] {
        member.appointments
            .filter { showUpcomingOnly ? !$0.isPast : true }
            .sorted { $0.date > $1.date }
    }

    var body: some View {
        NavigationStack {
            Group {
                if member.appointments.isEmpty {
                    EmptyStateView(
                        icon: "stethoscope",
                        title: "No Visits Recorded",
                        message: "Log your GP visits, specialist appointments, and consultations.",
                        buttonTitle: "Add Appointment"
                    ) { showAdd = true }
                } else {
                    list
                }
            }
            .navigationTitle("Doctor Visits")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus").font(.title3)
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddAppointmentView(member: member)
            }
        }
    }

    private var list: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                Toggle("Upcoming only", isOn: $showUpcomingOnly)
                    .font(AppTheme.Font.body)
                    .padding(AppTheme.Spacing.md)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.sm))

                ForEach(sorted) { appt in
                    NavigationLink(destination: AppointmentDetailView(appointment: appt)) {
                        AppointmentCard(appointment: appt)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct AppointmentCard: View {
    let appointment: Appointment

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            HStack(spacing: AppTheme.Spacing.md) {
                IconBadge(icon: appointment.specialty.icon, color: AppTheme.Section.appointments, size: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(appointment.doctorName.isEmpty ? "Doctor" : "Dr. \(appointment.doctorName)")
                        .font(AppTheme.Font.subhead)
                        .fontWeight(.semibold)
                    Text(appointment.specialty.rawValue)
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                    if !appointment.clinic.isEmpty {
                        Text(appointment.clinic)
                            .font(AppTheme.Font.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(appointment.date.formatted(date: .abbreviated, time: .omitted))
                        .font(AppTheme.Font.label)
                        .fontWeight(.semibold)
                    Text(appointment.date.formatted(date: .omitted, time: .shortened))
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                    StatusPill(
                        label: appointment.isPast ? "Past" : "Upcoming",
                        color: appointment.isPast ? .secondary : .green
                    )
                }
            }

            if !appointment.reason.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "text.bubble.fill")
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                    Text("Reason: \(appointment.reason)")
                        .font(AppTheme.Font.label)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        .frame(minHeight: AppTheme.tapTargetHeight)
    }
}

struct AppointmentDetailView: View {
    let appointment: Appointment

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                // Header
                HStack(spacing: AppTheme.Spacing.md) {
                    IconBadge(icon: appointment.specialty.icon, color: AppTheme.Section.appointments, size: 60)
                    VStack(alignment: .leading, spacing: 4) {
                        if !appointment.doctorName.isEmpty {
                            Text("Dr. \(appointment.doctorName)")
                                .font(AppTheme.Font.title)
                                .fontWeight(.bold)
                        }
                        Text(appointment.specialty.rawValue)
                            .font(AppTheme.Font.body)
                            .foregroundStyle(.secondary)
                        Text(appointment.formattedDate)
                            .font(AppTheme.Font.body)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(AppTheme.Spacing.md)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))

                detailSection("Reason for Visit", text: appointment.reason, icon: "questionmark.circle.fill")
                detailSection("Diagnosis", text: appointment.diagnosis, icon: "cross.case.fill")
                detailSection("Treatment Plan", text: appointment.treatmentPlan, icon: "list.clipboard.fill")
                detailSection("Notes", text: appointment.notes, icon: "note.text")

                if let followUp = appointment.followUpDate {
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Follow-up", systemImage: "calendar.badge.clock")
                                .font(AppTheme.Font.heading)
                            Text(followUp.formatted(date: .long, time: .omitted))
                                .font(AppTheme.Font.subhead)
                            if !appointment.followUpNotes.isEmpty {
                                Text(appointment.followUpNotes)
                                    .font(AppTheme.Font.body)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Appointment")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailSection(_ title: String, text: String, icon: String) -> some View {
        if !text.isEmpty {
            SectionCard {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Label(title, systemImage: icon)
                        .font(AppTheme.Font.heading)
                    Text(text)
                        .font(AppTheme.Font.body)
                }
            }
        }
    }
}
