import Foundation
import SwiftData

@Model
final class Prescription {
    var id: UUID
    var medicationName: String
    var genericName: String
    var dosage: String
    var form: MedicationForm
    var frequency: String
    var instructions: String
    var prescribedBy: String
    var prescribedAt: Date
    var startDate: Date
    var endDate: Date?
    var isActive: Bool
    var refillsRemaining: Int
    var pharmacy: String
    var reason: String
    var sideEffectsNoted: String
    var notes: String
    var member: FamilyMember?

    // History of dosage changes
    @Relationship(deleteRule: .cascade) var changes: [PrescriptionChange] = []

    init(
        medicationName: String,
        genericName: String = "",
        dosage: String,
        form: MedicationForm = .tablet,
        frequency: String,
        instructions: String = "",
        prescribedBy: String = "",
        prescribedAt: Date = Date(),
        startDate: Date = Date(),
        endDate: Date? = nil,
        isActive: Bool = true,
        refillsRemaining: Int = 0,
        pharmacy: String = "",
        reason: String = "",
        sideEffectsNoted: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.medicationName = medicationName
        self.genericName = genericName
        self.dosage = dosage
        self.form = form
        self.frequency = frequency
        self.instructions = instructions
        self.prescribedBy = prescribedBy
        self.prescribedAt = prescribedAt
        self.startDate = startDate
        self.endDate = endDate
        self.isActive = isActive
        self.refillsRemaining = refillsRemaining
        self.pharmacy = pharmacy
        self.reason = reason
        self.sideEffectsNoted = sideEffectsNoted
        self.notes = notes
    }

    var displayDosage: String { "\(dosage) \(form.rawValue)" }

    var isExpiringSoon: Bool {
        guard let end = endDate else { return false }
        return end.timeIntervalSinceNow < 7 * 24 * 3600 && end > Date()
    }
}

@Model
final class PrescriptionChange {
    var id: UUID
    var date: Date
    var previousDosage: String
    var newDosage: String
    var reason: String
    var changedBy: String
    var prescription: Prescription?

    init(date: Date = Date(), previousDosage: String, newDosage: String, reason: String = "", changedBy: String = "") {
        self.id = UUID()
        self.date = date
        self.previousDosage = previousDosage
        self.newDosage = newDosage
        self.reason = reason
        self.changedBy = changedBy
    }
}

enum MedicationForm: String, Codable, CaseIterable {
    case tablet      = "Tablet"
    case capsule     = "Capsule"
    case liquid      = "Liquid"
    case injection   = "Injection"
    case patch       = "Patch"
    case inhaler     = "Inhaler"
    case drops       = "Drops"
    case cream       = "Cream / Ointment"
    case suppository = "Suppository"
    case other       = "Other"

    var icon: String {
        switch self {
        case .tablet:   return "pill.fill"
        case .capsule:  return "capsule.fill"
        case .inhaler:  return "wind"
        case .drops:    return "drop.fill"
        case .patch:    return "bandage.fill"
        case .injection: return "syringe.fill"
        default:        return "pill.fill"
        }
    }
}
