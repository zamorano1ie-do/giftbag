import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var members: [FamilyMember]
    @State private var showAddMember = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    
                    // Header
                    ProfileHeaderView()

                    // Quick Stats Row
                    HStack(spacing: 8) {
                        QuickStatCard(value: "4 active", label: "Medications")
                        QuickStatCard(value: "4 tracked", label: "Conditions")
                        QuickStatCard(value: "Mar 8", label: "Next Visit")
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)

                    // Family Members (Kept from original as it provides data functionality)
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("FAMILY MEMBERS")
                            .font(AppTheme.Font.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        ForEach(members) { member in
                            NavigationLink(destination: EditFamilyMemberView(member: member)) {
                                FamilyMemberRow(member: member)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal, AppTheme.Spacing.md)
                        }

                        PrimaryButton("Add Family Member", icon: "person.badge.plus") {
                            showAddMember = true
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }

                    // Health Records
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("HEALTH RECORDS")
                            .font(AppTheme.Font.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        VStack(spacing: 8) {
                            if let firstMember = members.first {
                                NavigationLink(destination: PrescriptionsListView(member: firstMember)) {
                                    MoreMenuLinkRow(icon: "pills.fill", label: "Prescriptions", desc: "Medications & refills", color: Color(hex: "8b6fa0"), bg: Color(hex: "f3eef8"))
                                }
                                NavigationLink(destination: MedicalHistoryView(member: firstMember)) {
                                    MoreMenuLinkRow(icon: "doc.text.fill", label: "Medical History", desc: "Conditions, allergies & more", color: Color(hex: "c47c2f"), bg: Color(hex: "fdf3e7"))
                                }
                            } else {
                                MoreMenuLinkRow(icon: "pills.fill", label: "Prescriptions", desc: "Medications & refills", color: Color(hex: "8b6fa0"), bg: Color(hex: "f3eef8"))
                                MoreMenuLinkRow(icon: "doc.text.fill", label: "Medical History", desc: "Conditions, allergies & more", color: Color(hex: "c47c2f"), bg: Color(hex: "fdf3e7"))
                            }
                            // Guidance not yet implemented, placeholder
                            MoreMenuLinkRow(icon: "book.fill", label: "Health Guidance", desc: "Tips & health education", color: Color(hex: "023F46"), bg: Color(hex: "023F46").opacity(0.1))
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }

                    // Tools
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("TOOLS")
                            .font(AppTheme.Font.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        SectionCard {
                            VStack(spacing: 0) {
                                MoreMenuToolRow(icon: "square.and.arrow.up", label: "Share My Records", desc: "Send to a doctor or family", color: Color(hex: "5a88c4"))
                                Divider()
                                MoreMenuToolRow(icon: "arrow.down.doc", label: "Export Health Report", desc: "Download as PDF", color: Color(hex: "023F46"))
                                Divider()
                                MoreMenuToolRow(icon: "phone.fill", label: "Emergency Contacts", desc: "Manage contacts", color: Color(hex: "c75050"))
                                Divider()
                                MoreMenuToolRow(icon: "shield.fill", label: "Privacy & Security", desc: "Data protection settings", color: Color(hex: "023F46"))
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }

                    // Settings & Support
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text("SETTINGS & SUPPORT")
                            .font(AppTheme.Font.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        SectionCard {
                            VStack(spacing: 0) {
                                MoreMenuSettingRow(icon: "bell.fill", label: "Reminders & Notifications")
                                Divider()
                                MoreMenuSettingRow(icon: "person.fill", label: "My Profile & ID")
                                Divider()
                                MoreMenuSettingRow(icon: "gearshape.fill", label: "App Settings")
                                Divider()
                                MoreMenuSettingRow(icon: "questionmark.circle.fill", label: "Help & Support")
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        HStack {
                            Text("RECENT ACTIVITY")
                                .font(AppTheme.Font.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                            Spacer()
                            Text("View all")
                                .font(AppTheme.Font.subhead)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color(hex: "023F46"))
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)

                        SectionCard {
                            VStack(spacing: 0) {
                                RecentActivityRow(icon: "waveform.path.ecg", color: Color(hex: "023F46"), label: "Weight logged — 72.0 kg", time: "Today, 7:30 AM")
                                Divider()
                                RecentActivityRow(icon: "pills.fill", color: Color(hex: "8b6fa0"), label: "Lisinopril taken", time: "Today, 8:05 AM")
                                Divider()
                                RecentActivityRow(icon: "stethoscope", color: Color.primary, label: "Dr. Chen appointment confirmed", time: "Yesterday")
                                Divider()
                                RecentActivityRow(icon: "flask.fill", color: Color(hex: "023F46"), label: "Blood test results added", time: "Feb 15")
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                    }

                    // Version
                    VStack(spacing: 4) {
                        Text("MyHealth Companion · Version 1.0.0")
                            .font(AppTheme.Font.caption)
                            .foregroundStyle(.secondary)
                        Text("Your health data is private and encrypted")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.gray.opacity(0.8))
                    }
                    .padding(.top, AppTheme.Spacing.md)
                    .padding(.bottom, AppTheme.Spacing.xxl)
                }
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Profile & More")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddMember) {
                AddFamilyMemberView()
            }
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [Color(hex: "023F46"), Color(hex: "b8556a")], startPoint: .topLeading, endPoint: .bottomTrailing)
            
            // Decorative circle
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 100, height: 100)
                .offset(x: 20, y: -20)
            
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "1F757D"))
                        .frame(width: 56, height: 56)
                        .overlay(Circle().stroke(Color.white.opacity(0.5), lineWidth: 3))
                    Text("👩")
                        .font(.system(size: 26))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Margaret Williams")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                    Text("DOB: 12 June 1960 · Age 65")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.8))
                    Text("Blood Type: A+ · GP: Dr. Sarah Chen")
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.top, 2)
                }
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.xl)
        }
    }
}

struct QuickStatCard: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundStyle(Color.white.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MoreMenuLinkRow: View {
    let icon: String
    let label: String
    let desc: String
    let color: Color
    let bg: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(bg)
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 22))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(Color.primary)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray.opacity(0.5))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.primary.opacity(0.06), radius: 5, x: 0, y: 2)
    }
}

struct MoreMenuToolRow: View {
    let icon: String
    let label: String
    let desc: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.primary)
                Text(desc)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray.opacity(0.5))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
    }
}

struct MoreMenuSettingRow: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.Background.grouped)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                    .font(.system(size: 18))
            }
            
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.primary)
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray.opacity(0.5))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
    }
}

struct RecentActivityRow: View {
    let icon: String
    let color: Color
    let label: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .foregroundStyle(color)
                    .font(.system(size: 18))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.primary)
                    .lineLimit(1)
                Text(time)
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.gray.opacity(0.5))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
    }
}

struct FamilyMemberRow: View {
    let member: FamilyMember
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            IconBadge(icon: member.avatarIcon, color: .accentColor, size: 52)
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name).font(AppTheme.Font.subhead).fontWeight(.semibold)
                Text(member.relationship.rawValue).font(AppTheme.Font.caption).foregroundStyle(.secondary)
                Text("Age \(member.age)  ·  \(member.bloodType.rawValue)").font(AppTheme.Font.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(AppTheme.Spacing.md)
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        .shadow(color: Color.primary.opacity(0.06), radius: 5, x: 0, y: 2)
        .frame(minHeight: AppTheme.tapTargetHeight)
    }
}
