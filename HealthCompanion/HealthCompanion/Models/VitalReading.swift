import Foundation
import SwiftData

@Model
final class VitalReading {
    var id: UUID
    var type: VitalType
    var value: Double
    var secondaryValue: Double?   // for BP diastolic, or height ft+in
    var unit: String
    var recordedAt: Date
    var notes: String
    var member: FamilyMember?

    init(
        type: VitalType,
        value: Double,
        secondaryValue: Double? = nil,
        unit: String,
        recordedAt: Date = Date(),
        notes: String = ""
    ) {
        self.id = UUID()
        self.type = type
        self.value = value
        self.secondaryValue = secondaryValue
        self.unit = unit
        self.recordedAt = recordedAt
        self.notes = notes
    }

    var displayValue: String {
        switch type {
        case .bloodPressure:
            let diastolic = Int(secondaryValue ?? 0)
            return "\(Int(value))/\(diastolic) \(unit)"
        case .height:
            if let inches = secondaryValue {
                return "\(Int(value))ft \(Int(inches))in"
            }
            return "\(String(format: "%.1f", value)) \(unit)"
        case .weight:
            return "\(String(format: "%.1f", value)) \(unit)"
        case .temperature:
            return "\(String(format: "%.1f", value)) \(unit)"
        case .bloodGlucose:
            return "\(String(format: "%.1f", value)) \(unit)"
        default:
            return "\(Int(value)) \(unit)"
        }
    }

    var statusColor: VitalStatus {
        switch type {
        case .bloodPressure:
            let systolic = value
            let diastolic = secondaryValue ?? 0
            if systolic < 120 && diastolic < 80 { return .normal }
            if systolic < 130 && diastolic < 80 { return .elevated }
            if systolic < 140 || diastolic < 90 { return .high }
            return .critical
        case .heartRate:
            if value >= 60 && value <= 100 { return .normal }
            if value < 50 || value > 120 { return .critical }
            return .elevated
        case .oxygenSaturation:
            if value >= 95 { return .normal }
            if value >= 90 { return .elevated }
            return .critical
        case .temperature:
            if value >= 36.1 && value <= 37.2 { return .normal }
            if value >= 37.3 && value <= 38.0 { return .elevated }
            return .critical
        case .bloodGlucose:
            if value >= 70 && value <= 99 { return .normal }
            if value >= 100 && value <= 125 { return .elevated }
            return .critical
        default:
            return .normal
        }
    }
}

enum VitalType: String, Codable, CaseIterable {
    case bloodPressure    = "Blood Pressure"
    case heartRate        = "Heart Rate"
    case weight           = "Weight"
    case height           = "Height"
    case temperature      = "Temperature"
    case oxygenSaturation = "Oxygen Saturation"
    case bloodGlucose     = "Blood Glucose"
    case bmi              = "BMI"
    case respiratoryRate  = "Respiratory Rate"
    case waistCircumference = "Waist Circumference"

    var icon: String {
        switch self {
        case .bloodPressure:     return "heart.fill"
        case .heartRate:         return "waveform.path.ecg.rectangle.fill"
        case .weight:            return "scalemass.fill"
        case .height:            return "ruler.fill"
        case .temperature:       return "thermometer.medium"
        case .oxygenSaturation:  return "lungs.fill"
        case .bloodGlucose:      return "drop.fill"
        case .bmi:               return "figure.stand"
        case .respiratoryRate:   return "wind"
        case .waistCircumference: return "pencil.and.ruler.fill"
        }
    }

    var defaultUnit: String {
        switch self {
        case .bloodPressure:     return "mmHg"
        case .heartRate:         return "bpm"
        case .weight:            return "kg"
        case .height:            return "cm"
        case .temperature:       return "°C"
        case .oxygenSaturation:  return "%"
        case .bloodGlucose:      return "mmol/L"
        case .bmi:               return "kg/m²"
        case .respiratoryRate:   return "breaths/min"
        case .waistCircumference: return "cm"
        }
    }
}

enum VitalStatus {
    case normal, elevated, high, critical

    var color: String {
        switch self {
        case .normal:   return "green"
        case .elevated: return "yellow"
        case .high:     return "orange"
        case .critical: return "red"
        }
    }

    var label: String {
        switch self {
        case .normal:   return "Normal"
        case .elevated: return "Elevated"
        case .high:     return "High"
        case .critical: return "Needs Attention"
        }
    }
}
