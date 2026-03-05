import Foundation
import SwiftData

@Model
final class Appointment {
    var id: UUID
    var date: Date
    var doctorName: String
    var specialty: MedicalSpecialty
    var clinic: String
    var reason: String
    var diagnosis: String
    var treatmentPlan: String
    var followUpDate: Date?
    var followUpNotes: String
    var notes: String
    var member: FamilyMember?

    init(
        date: Date = Date(),
        doctorName: String = "",
        specialty: MedicalSpecialty = .generalPractice,
        clinic: String = "",
        reason: String = "",
        diagnosis: String = "",
        treatmentPlan: String = "",
        followUpDate: Date? = nil,
        followUpNotes: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.doctorName = doctorName
        self.specialty = specialty
        self.clinic = clinic
        self.reason = reason
        self.diagnosis = diagnosis
        self.treatmentPlan = treatmentPlan
        self.followUpDate = followUpDate
        self.followUpNotes = followUpNotes
        self.notes = notes
    }

    var isPast: Bool { date < Date() }

    var formattedDate: String {
        date.formatted(date: .long, time: .shortened)
    }
}

enum MedicalSpecialty: String, Codable, CaseIterable {
    case generalPractice  = "General Practice (GP)"
    case cardiology       = "Cardiology"
    case dermatology      = "Dermatology"
    case endocrinology    = "Endocrinology"
    case gastroenterology = "Gastroenterology"
    case gynaecology      = "Gynaecology"
    case haematology      = "Haematology"
    case nephrology       = "Nephrology"
    case neurology        = "Neurology"
    case oncology         = "Oncology"
    case ophthalmology    = "Ophthalmology (Eye)"
    case orthopaedics     = "Orthopaedics"
    case otolaryngology   = "ENT (Ear, Nose & Throat)"
    case physiotherapy    = "Physiotherapy"
    case psychiatry       = "Psychiatry / Mental Health"
    case pulmonology      = "Pulmonology (Lungs)"
    case rheumatology     = "Rheumatology"
    case urology          = "Urology"
    case other            = "Other"

    var icon: String {
        switch self {
        case .generalPractice:  return "stethoscope"
        case .cardiology:       return "heart.fill"
        case .ophthalmology:    return "eye.fill"
        case .otolaryngology:   return "ear.fill"
        case .psychiatry:       return "brain.head.profile"
        case .pulmonology:      return "lungs.fill"
        case .orthopaedics:     return "figure.walk"
        case .physiotherapy:    return "figure.strengthtraining.traditional"
        default:                return "cross.fill"
        }
    }
}
