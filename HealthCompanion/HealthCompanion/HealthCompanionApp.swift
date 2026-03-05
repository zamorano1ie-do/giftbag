import SwiftUI
import SwiftData

@main
struct HealthCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: [
            FamilyMember.self,
            VitalReading.self,
            LabResult.self,
            Appointment.self,
            Prescription.self,
            MedicalCondition.self,
            Surgery.self,
            Allergy.self,
            Vaccination.self,
            VisionTest.self,
            HearingTest.self,
            Document.self
        ])
    }
}
