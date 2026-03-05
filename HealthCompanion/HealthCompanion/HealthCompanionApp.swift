import SwiftUI
import SwiftData

@main
struct SlainteApp: App {
    init() {
        applyGlobalAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                // Global accent colour = Pastel Garden deep rose
                .tint(.rose)
        }
        .modelContainer(for: [
            FamilyMember.self,
            VitalReading.self,
            LabResult.self,
            Appointment.self,
            Prescription.self,
            PrescriptionChange.self,
            MedicalCondition.self,
            Surgery.self,
            Allergy.self,
            Vaccination.self,
            VisionTest.self,
            HearingTest.self,
            Document.self
        ])
    }

    private func applyGlobalAppearance() {
        // Navigation bar — warm brown titles, blush background
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = UIColor(Color.blushBackground)
        navAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color.warmBrown),
            .font: UIFont(name: "OpenSans-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color.warmBrown),
            .font: UIFont(name: "OpenSans-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        UINavigationBar.appearance().standardAppearance   = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance    = navAppearance
        UINavigationBar.appearance().tintColor = UIColor(Color.rose)

        // Tab bar — blush-tinted background
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor(Color.blushBackground)
        // Selected item = rose, unselected = sage
        tabAppearance.stackedLayoutAppearance.selected.iconColor      = UIColor(Color.rose)
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.rose),
            .font: UIFont(name: "OpenSans-SemiBold", size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]
        tabAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.sage)
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.sage),
            .font: UIFont(name: "OpenSans-Regular", size: 10) ?? UIFont.systemFont(ofSize: 10)
        ]
        UITabBar.appearance().standardAppearance   = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        // Search bar & text fields tint
        UITextField.appearance().tintColor = UIColor(Color.rose)
        UITextView.appearance().tintColor  = UIColor(Color.rose)
    }
}
