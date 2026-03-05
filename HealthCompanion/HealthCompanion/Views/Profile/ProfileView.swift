import SwiftUI
import SwiftData

struct ProfileView: View {
    @Query private var members: [FamilyMember]
    @State private var showAddMember = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {

                    // Family Members
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("Family Members", systemImage: "person.2.fill")
                            .font(AppTheme.Font.heading)

                        ForEach(members) { member in
                            NavigationLink(destination: EditFamilyMemberView(member: member)) {
                                FamilyMemberRow(member: member)
                            }
                            .buttonStyle(.plain)
                        }

                        PrimaryButton("Add Family Member", icon: "person.badge.plus") {
                            showAddMember = true
                        }
                    }

                    Divider()

                    // App info
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Label("About", systemImage: "info.circle.fill")
                            .font(AppTheme.Font.heading)

                        SectionCard {
                            VStack(spacing: 0) {
                                InfoRow(label: "App", value: "Sláinte")
                                Divider()
                                InfoRow(label: "Version", value: "1.0")
                                Divider()
                                InfoRow(label: "Storage", value: "On-device only — private & secure")
                                Divider()
                                InfoRow(label: "Data Sharing", value: "None — your data never leaves your phone")
                            }
                        }
                    }

                    // Accessibility settings reminder
                    SectionCard {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Label("Accessibility Tip", systemImage: "accessibility.fill")
                                .font(AppTheme.Font.subhead)
                            Text("You can make text larger in iPhone Settings → Display & Brightness → Text Size. This app supports all Dynamic Type sizes.")
                                .font(AppTheme.Font.label)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .padding(AppTheme.Spacing.md)
            }
            .background(AppTheme.Background.grouped)
            .navigationTitle("Profile & Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddMember) {
                AddFamilyMemberView()
            }
        }
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
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
        .frame(minHeight: AppTheme.tapTargetHeight)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).font(AppTheme.Font.label).foregroundStyle(.secondary).frame(width: 130, alignment: .leading)
            Text(value).font(AppTheme.Font.body)
            Spacer()
        }
        .padding(.vertical, 12).padding(.horizontal, AppTheme.Spacing.md)
        .frame(minHeight: AppTheme.tapTargetHeight)
    }
}
