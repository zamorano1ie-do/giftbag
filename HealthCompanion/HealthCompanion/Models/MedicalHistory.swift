import Foundation
import SwiftData

// MARK: - Medical Conditions

@Model
final class MedicalCondition {
    var id: UUID
    var name: String
    var category: ConditionCategory
    var diagnosedDate: Date?
    var diagnosedBy: String
    var isActive: Bool
    var isChronic: Bool
    var severity: ConditionSeverity
    var treatment: String
    var notes: String
    var member: FamilyMember?

    init(
        name: String,
        category: ConditionCategory = .other,
        diagnosedDate: Date? = nil,
        diagnosedBy: String = "",
        isActive: Bool = true,
        isChronic: Bool = false,
        severity: ConditionSeverity = .mild,
        treatment: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.diagnosedDate = diagnosedDate
        self.diagnosedBy = diagnosedBy
        self.isActive = isActive
        self.isChronic = isChronic
        self.severity = severity
        self.treatment = treatment
        self.notes = notes
    }
}

enum ConditionCategory: String, Codable, CaseIterable {
    case cardiovascular = "Heart & Blood Vessels"
    case respiratory    = "Lungs & Breathing"
    case diabetes       = "Diabetes"
    case musculoskeletal = "Bones & Muscles"
    case neurological   = "Brain & Nerves"
    case mentalHealth   = "Mental Health"
    case gastrointestinal = "Digestive System"
    case endocrine      = "Hormones & Thyroid"
    case renal          = "Kidneys"
    case autoimmune     = "Autoimmune"
    case cancer         = "Cancer"
    case infection      = "Infection"
    case other          = "Other"
}

enum ConditionSeverity: String, Codable, CaseIterable {
    case mild     = "Mild"
    case moderate = "Moderate"
    case severe   = "Severe"
}

// MARK: - Surgeries & Procedures

@Model
final class Surgery {
    var id: UUID
    var name: String
    var date: Date
    var surgeon: String
    var hospital: String
    var reason: String
    var outcome: String
    var notes: String
    var member: FamilyMember?

    init(
        name: String,
        date: Date,
        surgeon: String = "",
        hospital: String = "",
        reason: String = "",
        outcome: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.surgeon = surgeon
        self.hospital = hospital
        self.reason = reason
        self.outcome = outcome
        self.notes = notes
    }
}

// MARK: - Allergies

@Model
final class Allergy {
    var id: UUID
    var allergen: String
    var category: AllergyCategory
    var reaction: String
    var severity: AllergySeverity
    var diagnosedDate: Date?
    var notes: String
    var member: FamilyMember?

    init(
        allergen: String,
        category: AllergyCategory = .other,
        reaction: String = "",
        severity: AllergySeverity = .mild,
        diagnosedDate: Date? = nil,
        notes: String = ""
    ) {
        self.id = UUID()
        self.allergen = allergen
        self.category = category
        self.reaction = reaction
        self.severity = severity
        self.diagnosedDate = diagnosedDate
        self.notes = notes
    }
}

enum AllergyCategory: String, Codable, CaseIterable {
    case medication  = "Medication"
    case food        = "Food"
    case environmental = "Environmental"
    case insect      = "Insect"
    case latex       = "Latex"
    case other       = "Other"
}

enum AllergySeverity: String, Codable, CaseIterable {
    case mild        = "Mild"
    case moderate    = "Moderate"
    case severe      = "Severe (Anaphylaxis)"
}

// MARK: - Vaccinations

@Model
final class Vaccination {
    var id: UUID
    var name: String
    var date: Date
    var nextDueDate: Date?
    var provider: String
    var batchNumber: String
    var notes: String
    var member: FamilyMember?

    init(
        name: String,
        date: Date,
        nextDueDate: Date? = nil,
        provider: String = "",
        batchNumber: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.date = date
        self.nextDueDate = nextDueDate
        self.provider = provider
        self.batchNumber = batchNumber
        self.notes = notes
    }

    var isDue: Bool {
        guard let next = nextDueDate else { return false }
        return next < Date()
    }

    var isDueSoon: Bool {
        guard let next = nextDueDate else { return false }
        return next.timeIntervalSinceNow < 30 * 24 * 3600 && next > Date()
    }
}

// MARK: - Documents

@Model
final class Document {
    var id: UUID
    var title: String
    var category: DocumentCategory
    var fileData: Data
    var mimeType: String
    var uploadedAt: Date
    var notes: String
    var member: FamilyMember?

    init(
        title: String,
        category: DocumentCategory = .other,
        fileData: Data,
        mimeType: String = "application/pdf",
        notes: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.fileData = fileData
        self.mimeType = mimeType
        self.uploadedAt = Date()
        self.notes = notes
    }
}

enum DocumentCategory: String, Codable, CaseIterable {
    case prescription    = "Prescription"
    case labReport       = "Lab Report"
    case imagingReport   = "Imaging (X-Ray, MRI, etc.)"
    case referral        = "Referral Letter"
    case dischargeSummary = "Discharge Summary"
    case insurance       = "Insurance"
    case other           = "Other"

    var icon: String {
        switch self {
        case .prescription:    return "pill.fill"
        case .labReport:       return "drop.fill"
        case .imagingReport:   return "photo.fill"
        case .referral:        return "envelope.fill"
        case .dischargeSummary: return "clipboard.fill"
        case .insurance:       return "shield.fill"
        case .other:           return "doc.fill"
        }
    }
}
