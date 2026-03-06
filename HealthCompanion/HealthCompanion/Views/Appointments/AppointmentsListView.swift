import SwiftUI
import SwiftData

struct AppointmentsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var expandedApptId: PersistentIdentifier?
    @Environment(\.dismiss) private var dismiss

    private var upcoming: [Appointment] {
        member.appointments.filter { !$0.isPast }.sorted { $0.date < $1.date }
    }
    
    private var past: [Appointment] {
        member.appointments.filter { $0.isPast }.sorted { $0.date > $1.date }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom Header
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: [Color.darkMid, Color.dark], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges: .top)
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 100, height: 100)
                        .offset(x: 20, y: -20)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Doctor Visits")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("Appointments & consultations")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            Button {
                                showAdd = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Add")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.2))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                
                ScrollView {
                    VStack(spacing: 24) {
                        if !upcoming.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("UPCOMING")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(Color.textSecondary)
                                    .tracking(0.5)
                                    .padding(.horizontal, 16)
                                
                                ForEach(upcoming) { appt in
                                    UpcomingAppointmentCard(appointment: appt)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .offset(y: -16)
                            .zIndex(10)
                        } else {
                            Color.clear.frame(height: 16)
                        }
                        
                        if !past.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("PAST VISITS")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundStyle(Color.textSecondary)
                                    .tracking(0.5)
                                    .padding(.horizontal, 16)
                                
                                ForEach(past) { appt in
                                    PastAppointmentCard(
                                        appointment: appt,
                                        isExpanded: expandedApptId == appt.id
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                            if expandedApptId == appt.id {
                                                expandedApptId = nil
                                            } else {
                                                expandedApptId = appt.id
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        
                        if upcoming.isEmpty && past.isEmpty {
                            EmptyStateView(
                                icon: "stethoscope",
                                title: "No Visits Recorded",
                                message: "Log your GP visits, specialist appointments, and consultations.",
                                buttonTitle: "Add Appointment"
                            ) { showAdd = true }
                            .padding(.top, 40)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAdd) {
            AddAppointmentView(member: member)
        }
    }
}

struct UpcomingAppointmentCard: View {
    let appointment: Appointment
    
    var body: some View {
        HStack(spacing: 0) {
            Color.sageDark
                .frame(width: 4)
            
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.sageDark.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: appointment.specialty.icon)
                            .font(.system(size: 22))
                            .foregroundStyle(Color.sageDark)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(appointment.doctorName.isEmpty ? "Doctor" : "Dr. \(appointment.doctorName)")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        Text("\(appointment.specialty.rawValue)\(appointment.clinic.isEmpty ? "" : " · \(appointment.clinic)")")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                        
                        HStack(spacing: 6) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 11))
                                Text(appointment.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.bg)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(Color.textPrimary)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .font(.system(size: 11))
                                Text(appointment.date.formatted(date: .omitted, time: .shortened))
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.bg)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundStyle(Color.textPrimary)
                        }
                        .padding(.top, 4)
                        
                        if !appointment.reason.isEmpty {
                            Text(appointment.reason)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.textSecondary)
                                .padding(.top, 4)
                                .lineLimit(2)
                        }
                    }
                    Spacer(minLength: 0)
                }
                .padding(16)
                
                HStack(spacing: 8) {
                    Button {} label: {
                        Text("Directions")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.sageDark.opacity(0.1))
                            .foregroundStyle(Color.sageDark)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    
                    NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                        Text("Details")
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.sageDark)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.12), radius: 10, x: 0, y: 4)
    }
}

struct PastAppointmentCard: View {
    let appointment: Appointment
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.sageDark.opacity(0.1))
                            .frame(width: 38, height: 38)
                        Image(systemName: appointment.specialty.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(Color.sageDark)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(appointment.doctorName.isEmpty ? "Doctor" : "Dr. \(appointment.doctorName)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        Text("\(appointment.date.formatted(date: .abbreviated, time: .omitted)) · \(appointment.specialty.rawValue)")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.card)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 10) {
                    Divider().background(Color.border)
                        .padding(.bottom, 8)
                    
                    if !appointment.clinic.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textSecondary)
                            Text(appointment.clinic)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.textSecondary)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 4)
                    }
                    
                    if !appointment.reason.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("REASON")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.textSecondary)
                                .tracking(0.5)
                            Text(appointment.reason)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.sageDark)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.bg)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    if !appointment.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("NOTES")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(Color.textSecondary)
                                .tracking(0.5)
                            Text(appointment.notes)
                                .font(.system(size: 13))
                                .foregroundStyle(Color.textPrimary)
                                .lineSpacing(4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color.bg)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 16)
                    }
                    
                    NavigationLink(destination: AppointmentDetailView(appointment: appointment)) {
                        Text("View Full Details")
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.bg)
                            .foregroundStyle(Color.sageDark)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.border, lineWidth: 1))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
                .padding(.bottom, 16)
                .background(Color.card)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmBrown.opacity(0.06), radius: 10, x: 0, y: 2)
    }
}

struct AppointmentDetailView: View {
    let appointment: Appointment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    IconBadge(icon: appointment.specialty.icon, color: Color.sageDark, size: 60)
                    VStack(alignment: .leading, spacing: 4) {
                        if !appointment.doctorName.isEmpty {
                            Text("Dr. \(appointment.doctorName)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.textPrimary)
                        }
                        Text(appointment.specialty.rawValue)
                            .font(.subheadline)
                            .foregroundStyle(Color.textSecondary)
                        Text(appointment.formattedDate)
                            .font(.subheadline)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.card)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: Color.warmBrown.opacity(0.06), radius: 10)

                detailSection("Reason for Visit", text: appointment.reason, icon: "questionmark.circle.fill")
                detailSection("Diagnosis", text: appointment.diagnosis, icon: "cross.case.fill")
                detailSection("Treatment Plan", text: appointment.treatmentPlan, icon: "list.clipboard.fill")
                detailSection("Notes", text: appointment.notes, icon: "text.alignleft")

                if let followUp = appointment.followUpDate {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "calendar.badge.clock")
                                .foregroundStyle(Color.sageDark)
                            Text("Follow-up")
                                .font(.headline)
                                .foregroundStyle(Color.textPrimary)
                        }
                        Text(followUp.formatted(date: .long, time: .omitted))
                            .font(.subheadline)
                            .foregroundStyle(Color.textPrimary)
                        if !appointment.followUpNotes.isEmpty {
                            Text(appointment.followUpNotes)
                                .font(.body)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.warmBrown.opacity(0.06), radius: 10)
                }
            }
            .padding()
        }
        .background(Color.bg.ignoresSafeArea())
        .navigationTitle("Appointment Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func detailSection(_ title: String, text: String, icon: String) -> some View {
        if !text.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(Color.sageDark)
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(Color.textPrimary)
                }
                Text(text)
                    .font(.body)
                    .foregroundStyle(Color.textPrimary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.warmBrown.opacity(0.06), radius: 10)
        }
    }
}
