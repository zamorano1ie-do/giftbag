import Foundation
import SwiftData

// MARK: - Vision Test

@Model
final class VisionTest {
    var id: UUID
    var date: Date
    var optometrist: String
    var clinic: String

    // Visual acuity (unaided)
    var rightEyeAcuityNumerator: Int   // e.g. 6 in 6/6
    var rightEyeAcuityDenominator: Int // e.g. 6 in 6/6
    var leftEyeAcuityNumerator: Int
    var leftEyeAcuityDenominator: Int

    // Prescription (glasses/contacts)
    var rightEyeSphere: Double?    // SPH in dioptres
    var rightEyeCylinder: Double?  // CYL
    var rightEyeAxis: Int?
    var rightEyeAdd: Double?       // reading addition
    var leftEyeSphere: Double?
    var leftEyeCylinder: Double?
    var leftEyeAxis: Int?
    var leftEyeAdd: Double?

    // PD
    var pupillaryDistance: Double?

    var intraocularPressureRight: Double?  // mmHg
    var intraocularPressureLeft: Double?

    var colourVisionNormal: Bool
    var notes: String
    var member: FamilyMember?

    init(
        date: Date = Date(),
        optometrist: String = "",
        clinic: String = "",
        rightEyeAcuityNumerator: Int = 6,
        rightEyeAcuityDenominator: Int = 6,
        leftEyeAcuityNumerator: Int = 6,
        leftEyeAcuityDenominator: Int = 6,
        rightEyeSphere: Double? = nil,
        rightEyeCylinder: Double? = nil,
        rightEyeAxis: Int? = nil,
        rightEyeAdd: Double? = nil,
        leftEyeSphere: Double? = nil,
        leftEyeCylinder: Double? = nil,
        leftEyeAxis: Int? = nil,
        leftEyeAdd: Double? = nil,
        pupillaryDistance: Double? = nil,
        intraocularPressureRight: Double? = nil,
        intraocularPressureLeft: Double? = nil,
        colourVisionNormal: Bool = true,
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.optometrist = optometrist
        self.clinic = clinic
        self.rightEyeAcuityNumerator = rightEyeAcuityNumerator
        self.rightEyeAcuityDenominator = rightEyeAcuityDenominator
        self.leftEyeAcuityNumerator = leftEyeAcuityNumerator
        self.leftEyeAcuityDenominator = leftEyeAcuityDenominator
        self.rightEyeSphere = rightEyeSphere
        self.rightEyeCylinder = rightEyeCylinder
        self.rightEyeAxis = rightEyeAxis
        self.rightEyeAdd = rightEyeAdd
        self.leftEyeSphere = leftEyeSphere
        self.leftEyeCylinder = leftEyeCylinder
        self.leftEyeAxis = leftEyeAxis
        self.leftEyeAdd = leftEyeAdd
        self.pupillaryDistance = pupillaryDistance
        self.intraocularPressureRight = intraocularPressureRight
        self.intraocularPressureLeft = intraocularPressureLeft
        self.colourVisionNormal = colourVisionNormal
        self.notes = notes
    }

    var rightEyeAcuity: String { "\(rightEyeAcuityNumerator)/\(rightEyeAcuityDenominator)" }
    var leftEyeAcuity: String  { "\(leftEyeAcuityNumerator)/\(leftEyeAcuityDenominator)" }

    func sphereDisplay(_ value: Double?) -> String {
        guard let v = value else { return "-" }
        return v >= 0 ? "+\(String(format: "%.2f", v))" : "\(String(format: "%.2f", v))"
    }
}

// MARK: - Hearing Test

@Model
final class HearingTest {
    var id: UUID
    var date: Date
    var audiologist: String
    var clinic: String
    var type: HearingTestType

    // Pure-tone audiogram thresholds in dBHL at standard frequencies
    // Right ear
    var right250Hz: Int?
    var right500Hz: Int?
    var right1000Hz: Int?
    var right2000Hz: Int?
    var right4000Hz: Int?
    var right8000Hz: Int?
    // Left ear
    var left250Hz: Int?
    var left500Hz: Int?
    var left1000Hz: Int?
    var left2000Hz: Int?
    var left4000Hz: Int?
    var left8000Hz: Int?

    var rightEarResult: HearingLevel
    var leftEarResult: HearingLevel
    var tinnitus: Bool
    var hearingAidRecommended: Bool
    var notes: String
    var member: FamilyMember?

    init(
        date: Date = Date(),
        audiologist: String = "",
        clinic: String = "",
        type: HearingTestType = .puretone,
        rightEarResult: HearingLevel = .normal,
        leftEarResult: HearingLevel = .normal,
        tinnitus: Bool = false,
        hearingAidRecommended: Bool = false,
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = date
        self.audiologist = audiologist
        self.clinic = clinic
        self.type = type
        self.rightEarResult = rightEarResult
        self.leftEarResult = leftEarResult
        self.tinnitus = tinnitus
        self.hearingAidRecommended = hearingAidRecommended
        self.notes = notes
    }
}

enum HearingTestType: String, Codable, CaseIterable {
    case puretone     = "Pure Tone Audiometry"
    case speech       = "Speech Audiometry"
    case otoscopy     = "Otoscopy"
    case tympanometry = "Tympanometry"
    case other        = "Other"
}

enum HearingLevel: String, Codable, CaseIterable {
    case normal           = "Normal (0–25 dB)"
    case mild             = "Mild Loss (26–40 dB)"
    case moderate         = "Moderate Loss (41–55 dB)"
    case moderatelySevere = "Moderately Severe (56–70 dB)"
    case severe           = "Severe Loss (71–90 dB)"
    case profound         = "Profound Loss (91+ dB)"
}
