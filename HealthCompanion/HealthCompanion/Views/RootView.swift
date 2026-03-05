import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var members: [FamilyMember]
    @State private var selectedTab: Tab = .dashboard
    @State private var selectedMember: FamilyMember?
    @State private var showAddMember = false

    enum Tab: String, CaseIterable {
        case dashboard = "Dashboard"
        case vitals = "Vitals"
        case labs = "Labs"
        case appointments = "Visits"
        case prescriptions = "Rx"
        case history = "History"

        var icon: String {
            switch self {
            case .dashboard:    return "heart.fill"
            case .vitals:       return "waveform.path.ecg"
            case .labs:         return "drop.fill"
            case .appointments: return "stethoscope"
            case .prescriptions: return "pill.fill"
            case .history:      return "clock.arrow.circlepath"
            }
        }
    }

    var body: some View {
        Group {
            if members.isEmpty {
                WelcomeView(showAddMember: $showAddMember)
            } else {
                mainView
            }
        }
        .sheet(isPresented: $showAddMember) {
            AddFamilyMemberView()
        }
        .onAppear {
            if selectedMember == nil {
                selectedMember = members.first
            }
        }
        .onChange(of: members) {
            if selectedMember == nil {
                selectedMember = members.first
            }
        }
    }

    @ViewBuilder
    private var mainView: some View {
        TabView(selection: $selectedTab) {
            DashboardView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.dashboard.rawValue, systemImage: Tab.dashboard.icon) }
                .tag(Tab.dashboard)

            VitalsListView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.vitals.rawValue, systemImage: Tab.vitals.icon) }
                .tag(Tab.vitals)

            LabResultsListView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.labs.rawValue, systemImage: Tab.labs.icon) }
                .tag(Tab.labs)

            AppointmentsListView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.appointments.rawValue, systemImage: Tab.appointments.icon) }
                .tag(Tab.appointments)

            PrescriptionsListView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.prescriptions.rawValue, systemImage: Tab.prescriptions.icon) }
                .tag(Tab.prescriptions)

            MedicalHistoryView(member: selectedMember ?? members[0])
                .tabItem { Label(Tab.history.rawValue, systemImage: Tab.history.icon) }
                .tag(Tab.history)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if members.count > 1 {
                    Menu {
                        ForEach(members) { member in
                            Button {
                                selectedMember = member
                            } label: {
                                Label(member.name, systemImage: member.avatarIcon)
                            }
                        }
                        Divider()
                        Button { showAddMember = true } label: {
                            Label("Add Family Member", systemImage: "person.badge.plus")
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: selectedMember?.avatarIcon ?? "person.circle.fill")
                            Text(selectedMember?.firstName ?? "")
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.down")
                                .font(.caption2)
                        }
                        .foregroundStyle(.primary)
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    ProfileView()
                } label: {
                    Image(systemName: "person.circle")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
