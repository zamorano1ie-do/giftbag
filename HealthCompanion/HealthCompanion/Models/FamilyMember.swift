import Foundation
import SwiftData

@Model
final class FamilyMember {
    var id: UUID
    var name: String
    var dateOfBirth: Date
    var biologicalSex: BiologicalSex
    var bloodType: BloodType
    var relationship: Relationship
    var email: String
    var phone: String
    var emergencyContactName: String
    var emergencyContactPhone: String
    var notes: String
    var createdAt: Date

    @Relationship(deleteRule: .cascade) var vitals: [VitalReading] = []
    @Relationship(deleteRule: .cascade) var labResults: [LabResult] = []
    @Relationship(deleteRule: .cascade) var appointments: [Appointment] = []
    @Relationship(deleteRule: .cascade) var prescriptions: [Prescription] = []
    @Relationship(deleteRule: .cascade) var conditions: [MedicalCondition] = []
    @Relationship(deleteRule: .cascade) var surgeries: [Surgery] = []
    @Relationship(deleteRule: .cascade) var allergies: [Allergy] = []
    @Relationship(deleteRule: .cascade) var vaccinations: [Vaccination] = []
    @Relationship(deleteRule: .cascade) var visionTests: [VisionTest] = []
    @Relationship(deleteRule: .cascade) var hearingTests: [HearingTest] = []
    @Relationship(deleteRule: .cascade) var documents: [Document] = []

    init(
        name: String,
        dateOfBirth: Date,
        biologicalSex: BiologicalSex = .notSpecified,
        bloodType: BloodType = .unknown,
        relationship: Relationship = .self_,
        email: String = "",
        phone: String = "",
        emergencyContactName: String = "",
        emergencyContactPhone: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.biologicalSex = biologicalSex
        self.bloodType = bloodType
        self.relationship = relationship
        self.email = email
        self.phone = phone
        self.emergencyContactName = emergencyContactName
        self.emergencyContactPhone = emergencyContactPhone
        self.notes = notes
        self.createdAt = Date()
    }

    var firstName: String {
        name.components(separatedBy: " ").first ?? name
    }

    var age: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: Date()).year ?? 0
    }

    var avatarIcon: String {
        switch relationship {
        case .self_:     return "person.circle.fill"
        case .spouse:    return "person.2.fill"
        case .child:     return "figure.child"
        case .parent:    return "person.fill"
        case .sibling:   return "person.fill"
        case .other:     return "person.crop.circle"
        }
    }

    var activePrescriptions: [Prescription] {
        prescriptions.filter { $0.isActive }
    }

    var activeConditions: [MedicalCondition] {
        conditions.filter { $0.isActive }
    }
}

// MARK: - Supporting Enums

enum BiologicalSex: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case notSpecified = "Prefer not to say"
}

enum BloodType: String, Codable, CaseIterable {
    case aPositive = "A+"
    case aNegative = "A-"
    case bPositive = "B+"
    case bNegative = "B-"
    case abPositive = "AB+"
    case abNegative = "AB-"
    case oPositive = "O+"
    case oNegative = "O-"
    case unknown = "Unknown"
}

enum Relationship: String, Codable, CaseIterable {
    case self_ = "Myself"
    case spouse = "Spouse / Partner"
    case child = "Child"
    case parent = "Parent"
    case sibling = "Sibling"
    case other = "Other"
}
