import SwiftUI
import SwiftData

struct DashboardView: View {
    let member: FamilyMember
    @State private var showQuickAdd = false
    @State private var showNotification = false
    
    // For UI demonstration, we simulate medications
    @State private var medications: [(id: UUID, name: String, time: String, taken: Bool)] = []

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                AppTheme.Background.main
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 0) {
                        headerSection
                        
                        // Overlapping card
                        overviewCard
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .offset(y: -16)
                            .zIndex(10)

                        VStack(spacing: AppTheme.Spacing.lg) {
                            todayMedications
                            quickActionsGrid
                        }
                        .padding(.top, 4) // adjust for the -16 offset
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.bottom, AppTheme.Spacing.xxl)
                    }
                }
                .ignoresSafeArea(edges: .top)

                if showNotification {
                    iosNotificationBanner
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(100)
                }
            }
            .onAppear {
                setupMockMedications()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showNotification = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 7.5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showNotification = false
                    }
                }
            }
            .sheet(isPresented: $showQuickAdd) {
                QuickAddView(member: member)
            }
        }
    }
    
    private func setupMockMedications() {
        if medications.isEmpty {
            medications = [
                (UUID(), "Lisinopril 10mg", "8:00 AM", true),
                (UUID(), "Atorvastatin 20mg", "9:00 PM", false),
                (UUID(), "Metformin 500mg", "1:00 PM", true)
            ]
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 0) {
            // Space for safe area / Dynamic Island
            Spacer().frame(height: 60)
            
            HStack(alignment: .top) {
                HStack(spacing: 12) {
                    // Profile Icon
                    ZStack {
                        Circle()
                            .fill(Color.blush)
                            .frame(width: 46, height: 46)
                            .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 2))
                        Text(member.firstName.first.map { String($0) } ?? "👩")
                            .font(.system(size: 18))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(greetingText)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.white.opacity(0.85))
                        Text(member.firstName)
                            .font(AppTheme.Font.heading.weight(.bold))
                            .foregroundStyle(Color.white)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation { showNotification = true }
                }) {
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "bell.fill")
                                    .foregroundStyle(.white)
                            )
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .overlay(Circle().stroke(Color.rose, lineWidth: 1.5))
                            .offset(x: -8, y: 8)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            
            Text(formattedDate)
                .font(.system(size: 13))
                .foregroundStyle(Color.white.opacity(0.75))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.top, 12)
                .padding(.bottom, 28)
        }
        .background(
            LinearGradient(
                colors: [Color.rose, Color(hex: "B8556A")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        // Decorative circles
        .overlay(alignment: .topTrailing) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 120, height: 120)
                    .offset(x: 30, y: -30)
                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 60, height: 60)
                    .offset(x: -30, y: 10)
            }
        }
        .clipped()
    }

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning,"
        case 12..<17: return "Good afternoon,"
        default:      return "Good evening,"
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM yyyy"
        return formatter.string(from: Date())
    }
    
    // MARK: - Overview Card
    private var overviewCard: some View {
        let takenCount = medications.filter { $0.taken }.count
        let totalCount = medications.count
        let progressRatio = totalCount > 0 ? Double(takenCount) / Double(totalCount) : 0

        return VStack(alignment: .leading, spacing: 12) {
            Text("TODAY'S OVERVIEW")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.textSecondary)
                .tracking(0.5)
            
            HStack(spacing: 12) {
                // Medications
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "pill.fill")
                            .foregroundStyle(Color.rose)
                            .font(.system(size: 14))
                        Text("Medications")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 2) {
                        Text("\(takenCount)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        Text("/\(totalCount)")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Text("taken today")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.rose)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.pink50)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                
                // Appointments
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Image(systemName: "stethoscope")
                            .foregroundStyle(Color.sageDark)
                            .font(.system(size: 14))
                        Text("Appointment")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Text("Dr. Chen")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("Today · 10:30 AM")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.sageDark)
                    
                    HStack(alignment: .top, spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.textSecondary)
                            .padding(.top, 1)
                        Text("City Medical Centre\n45 Park Lane, Level 2")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(2)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.sage50)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            
            // Progress Bar
            VStack(spacing: 8) {
                HStack {
                    Text("Medication progress")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    Spacer()
                    Text("\(Int(progressRatio * 100))%")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.rose)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.border)
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.rose)
                            .frame(width: geo.size.width * CGFloat(progressRatio), height: 6)
                            .animation(.spring(), value: progressRatio)
                    }
                }
                .frame(height: 6)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.12), radius: 10, x: 0, y: 4)
    }

    // MARK: - Today's Medications
    private var todayMedications: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "clock.fill")
                    .foregroundStyle(Color.rose)
                    .font(.system(size: 16))
                Text("Today's Medications")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.rose)
            }
            .padding(.bottom, 2)
            
            ForEach(Array(medications.enumerated()), id: \.element.id) { index, med in
                HStack(spacing: 10) {
                    if med.taken {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(Color(hex: "5DAB6F"))
                            .font(.system(size: 18))
                    } else {
                        Circle()
                            .strokeBorder(Color.border, lineWidth: 2)
                            .frame(width: 18, height: 18)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(med.name)
                            .font(.system(size: 14))
                            .foregroundStyle(Color.textPrimary)
                            .strikethrough(med.taken)
                            .opacity(med.taken ? 0.6 : 1.0)
                        Text(med.time)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    if !med.taken {
                        Button(action: {
                            if let idx = medications.firstIndex(where: { $0.id == med.id }) {
                                withAnimation {
                                    medications[idx].taken = true
                                }
                            }
                        }) {
                            Text("Take")
                                .font(AppTheme.Font.body.weight(.semibold))
                                .font(.system(size: 12))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 5)
                                .background(Color.rose)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                .padding(.vertical, 8)
                
                if index < medications.count - 1 {
                    Divider()
                        .background(Color.blush.opacity(0.5)) // F0B8B8
                }
            }
        }
        .padding(16)
        .background(Color.blush.opacity(0.40)) // .primaryLight + 40 opacity
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blush, lineWidth: 1)
        )
    }

    // MARK: - Quick Actions Grid
    private var quickActionsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.textPrimary)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                QuickActionBox(label: "Log Vitals", icon: "waveform.path.ecg", color: Color.rose, bg: Color.pink100) { showQuickAdd = true }
                QuickActionBox(label: "Test Results", icon: "flask.fill", color: Color.sageDark, bg: Color.sage50) {  }
                QuickActionBox(label: "Doctor Visit", icon: "stethoscope", color: Color.darkMid, bg: Color(hex: "F3EDE8")) {  }
                QuickActionBox(label: "Prescriptions", icon: "pill.fill", color: Color(hex: "8B6FA0"), bg: Color(hex: "F3EEF8")) {  }
                QuickActionBox(label: "My History", icon: "doc.text.fill", color: Color(hex: "C47C2F"), bg: Color(hex: "FDF3E7")) {  }
            }
        }
    }
    
    // MARK: - Notification Banner
    private var iosNotificationBanner: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(alignment: .center, spacing: 10) {
                // App Icon mock
                ZStack {
                    LinearGradient(colors: [Color.rose, Color(hex: "b8556a")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 9))
                    Text("❤️")
                        .font(.system(size: 18))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text("MYHEALTH COMPANION")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.primary)
                            .tracking(0.3)
                        Spacer()
                        Text("now")
                            .font(.system(size: 11))
                            .foregroundStyle(.secondary)
                    }
                    Text("💊 Prescription Refill Reminder")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.primary)
                    Text("Your Lisinopril refill is due in 10 days. Contact Dr. Chen to request a renewal.")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.primary.opacity(0.8))
                        .lineLimit(2)
                }
                
                Button(action: {
                    withAnimation { showNotification = false }
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.primary.opacity(0.4))
                }
                .padding(.bottom, 24) // align to top right
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.18), radius: 32, y: 8)
        .shadow(color: Color.black.opacity(0.08), radius: 8, y: 2)
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

fileprivate struct QuickActionBox: View {
    let label: String
    let icon: String
    let color: Color
    let bg: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color.opacity(0.22))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(color)
                }
                
                Text(label)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color.opacity(0.22), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Quick Add Sheet

struct QuickAddView: View {
    let member: FamilyMember
    @Environment(\.dismiss) private var dismiss

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

