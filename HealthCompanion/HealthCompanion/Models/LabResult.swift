import Foundation
import SwiftData

@Model
final class LabResult {
    var id: UUID
    var testName: String
    var category: LabCategory
    var value: Double
    var unit: String
    var referenceRangeLow: Double?
    var referenceRangeHigh: Double?
    var referenceRangeText: String
    var status: LabResultStatus
    var testedAt: Date
    var lab: String
    var orderedBy: String
    var notes: String
    var member: FamilyMember?

    init(
        testName: String,
        category: LabCategory = .general,
        value: Double,
        unit: String,
        referenceRangeLow: Double? = nil,
        referenceRangeHigh: Double? = nil,
        referenceRangeText: String = "",
        status: LabResultStatus = .normal,
        testedAt: Date = Date(),
        lab: String = "",
        orderedBy: String = "",
        notes: String = ""
    ) {
        self.id = UUID()
        self.testName = testName
        self.category = category
        self.value = value
        self.unit = unit
        self.referenceRangeLow = referenceRangeLow
        self.referenceRangeHigh = referenceRangeHigh
        self.referenceRangeText = referenceRangeText
        self.status = status
        self.testedAt = testedAt
        self.lab = lab
        self.orderedBy = orderedBy
        self.notes = notes
    }

    var displayValue: String { "\(String(format: "%.2f", value)) \(unit)" }

    var computedStatus: LabResultStatus {
        guard let low = referenceRangeLow, let high = referenceRangeHigh else { return status }
        if value < low * 0.85 || value > high * 1.15 { return .critical }
        if value < low || value > high { return .abnormal }
        return .normal
    }
}

enum LabCategory: String, Codable, CaseIterable {
    case general         = "General"
    case bloodCount      = "Blood Count (CBC)"
    case metabolic       = "Metabolic Panel"
    case lipids          = "Lipid Panel"
    case thyroid         = "Thyroid"
    case liver           = "Liver Function"
    case kidney          = "Kidney Function"
    case diabetes        = "Diabetes"
    case hormones        = "Hormones"
    case vitamins        = "Vitamins & Minerals"
    case urine           = "Urinalysis"
    case other           = "Other"

    var icon: String {
        switch self {
        case .general:    return "list.clipboard.fill"
        case .bloodCount: return "drop.fill"
        case .metabolic:  return "bolt.fill"
        case .lipids:     return "heart.fill"
        case .thyroid:    return "butterfly.fill"
        case .liver:      return "cross.fill"
        case .kidney:     return "cross.fill"
        case .diabetes:   return "drop.triangle.fill"
        case .hormones:   return "person.fill"
        case .vitamins:   return "leaf.fill"
        case .urine:      return "cross.vial.fill"
        case .other:      return "questionmark.circle.fill"
        }
    }
}

enum LabResultStatus: String, Codable, CaseIterable {
    case normal   = "Normal"
    case abnormal = "Abnormal"
    case critical = "Critical"
    case pending  = "Pending"
}

// MARK: - Common Lab Tests Reference Data

struct CommonLabTest {
    let name: String
    let category: LabCategory
    let unit: String
    let lowMale: Double?
    let highMale: Double?
    let lowFemale: Double?
    let highFemale: Double?

    static let all: [CommonLabTest] = [
        // Blood Count
        CommonLabTest(name: "Haemoglobin", category: .bloodCount, unit: "g/dL", lowMale: 13.5, highMale: 17.5, lowFemale: 12.0, highFemale: 15.5),
        CommonLabTest(name: "White Blood Cells", category: .bloodCount, unit: "×10³/µL", lowMale: 4.5, highMale: 11.0, lowFemale: 4.5, highFemale: 11.0),
        CommonLabTest(name: "Platelets", category: .bloodCount, unit: "×10³/µL", lowMale: 150, highMale: 400, lowFemale: 150, highFemale: 400),
        CommonLabTest(name: "Red Blood Cells", category: .bloodCount, unit: "×10⁶/µL", lowMale: 4.5, highMale: 5.9, lowFemale: 4.0, highFemale: 5.2),
        // Lipids
        CommonLabTest(name: "Total Cholesterol", category: .lipids, unit: "mmol/L", lowMale: nil, highMale: 5.2, lowFemale: nil, highFemale: 5.2),
        CommonLabTest(name: "LDL Cholesterol", category: .lipids, unit: "mmol/L", lowMale: nil, highMale: 3.4, lowFemale: nil, highFemale: 3.4),
        CommonLabTest(name: "HDL Cholesterol", category: .lipids, unit: "mmol/L", lowMale: 1.0, highMale: nil, lowFemale: 1.3, highFemale: nil),
        CommonLabTest(name: "Triglycerides", category: .lipids, unit: "mmol/L", lowMale: nil, highMale: 1.7, lowFemale: nil, highFemale: 1.7),
        // Metabolic
        CommonLabTest(name: "Blood Glucose (Fasting)", category: .diabetes, unit: "mmol/L", lowMale: 3.9, highMale: 5.6, lowFemale: 3.9, highFemale: 5.6),
        CommonLabTest(name: "HbA1c", category: .diabetes, unit: "%", lowMale: nil, highMale: 5.7, lowFemale: nil, highFemale: 5.7),
        CommonLabTest(name: "Creatinine", category: .kidney, unit: "µmol/L", lowMale: 62, highMale: 115, lowFemale: 53, highFemale: 97),
        CommonLabTest(name: "eGFR", category: .kidney, unit: "mL/min/1.73m²", lowMale: 60, highMale: nil, lowFemale: 60, highFemale: nil),
        // Thyroid
        CommonLabTest(name: "TSH", category: .thyroid, unit: "mIU/L", lowMale: 0.4, highMale: 4.0, lowFemale: 0.4, highFemale: 4.0),
        CommonLabTest(name: "T4 (Free)", category: .thyroid, unit: "pmol/L", lowMale: 10, highMale: 20, lowFemale: 10, highFemale: 20),
        // Vitamins
        CommonLabTest(name: "Vitamin D", category: .vitamins, unit: "nmol/L", lowMale: 50, highMale: 250, lowFemale: 50, highFemale: 250),
        CommonLabTest(name: "Vitamin B12", category: .vitamins, unit: "pmol/L", lowMale: 148, highMale: 738, lowFemale: 148, highFemale: 738),
        CommonLabTest(name: "Ferritin", category: .vitamins, unit: "µg/L", lowMale: 30, highMale: 400, lowFemale: 13, highFemale: 150),
        CommonLabTest(name: "Iron", category: .vitamins, unit: "µmol/L", lowMale: 11, highMale: 32, lowFemale: 11, highFemale: 32),
    ]
}
