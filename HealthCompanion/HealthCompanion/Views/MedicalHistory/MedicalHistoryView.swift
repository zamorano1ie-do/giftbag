import SwiftUI
import SwiftData

struct MedicalHistoryView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @Environment(\.dismiss) private var dismiss
    
    // Accordion State
    @State private var expandedSection: HistorySection? = .conditions

    enum HistorySection: String, CaseIterable {
        case conditions  = "Medical Conditions"
        case surgeries   = "Surgeries & Procedures"
        case allergies   = "Allergies & Reactions"
        case vaccinations = "Immunizations"
        case visionHearing = "Eyes & Ears"
        case documents   = "Documents"

        var icon: String {
            switch self {
            case .conditions:   return "heart.fill"
            case .surgeries:    return "scissors"
            case .allergies:    return "exclamationmark.triangle.fill"
            case .vaccinations: return "cross.vial.fill"
            case .visionHearing: return "eye.fill"
            case .documents:    return "doc.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .conditions:   return Color.sageDark
            case .surgeries:    return Color.darkMid
            case .allergies:    return Color(hex: "C47C2F") // Orange
            case .vaccinations: return Color(hex: "5DAB6F") // Green
            case .visionHearing: return Color(hex: "8B6FA0") // Purple
            case .documents:    return Color(hex: "5A88C4") // Blue
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: [Color(hex: "C47C2F"), Color(hex: "A85E10")], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .ignoresSafeArea(edges: .top)
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .offset(x: 20, y: -20)
                    
                    VStack(spacing: 16) {
                        HStack {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            Spacer()
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Medical History")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("\(member.firstName) · DOB: \(member.dateOfBirth.formatted(date: .abbreviated, time: .omitted))")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Button {
                                showAdd = true
                            } label: {
                                HStack(spacing: 6) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("Add")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(Color.white.opacity(0.25))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Emergency Card
                        EmergencyHealthSummary(member: member)
                            .padding(.horizontal, 16)
                            .offset(y: -16)
                            .zIndex(10)
                        
                        VStack(spacing: 8) {
                            ForEach(HistorySection.allCases, id: \.self) { section in
                                SectionAccordion(
                                    section: section,
                                    member: member,
                                    isExpanded: expandedSection == section
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                        if expandedSection == section {
                                            expandedSection = nil
                                        } else {
                                            expandedSection = section
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAdd) {
            AddHistorySheet(member: member, selectedSection: expandedSection ?? .conditions)
        }
    }
}

// Re-using the logic from the old MedicalHistoryView.swift for the "Add History" sheet
struct AddHistorySheet: View {
    let member: FamilyMember
    let selectedSection: MedicalHistoryView.HistorySection

    @ViewBuilder
    var body: some View {
        switch selectedSection {
        case .conditions:   AddConditionView(member: member)
        case .surgeries:    AddSurgeryView(member: member)
        case .allergies:    AddAllergyView(member: member)
        case .vaccinations: AddVaccinationView(member: member)
        case .visionHearing: AddVisionTestView(member: member)
        case .documents:    AddDocumentView(member: member)
        }
    }
}

struct EmergencyHealthSummary: View {
    let member: FamilyMember

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "shield.fill")
                    .foregroundStyle(Color.rose)
                Text("Emergency Health Summary")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.rose)
            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 6) {
                summaryItem(label: "Blood Type", value: member.bloodType.rawValue)
                
                let allergiesStr = member.allergies.isEmpty ? "None" : member.allergies.prefix(2).map { $0.allergen }.joined(separator: ", ") + (member.allergies.count > 2 ? ", ..." : "")
                summaryItem(label: "Allergies", value: allergiesStr)
                
                let conditionsStr = member.activeConditions.isEmpty ? "None" : member.activeConditions.prefix(2).map { $0.name }.joined(separator: ", ") + (member.activeConditions.count > 2 ? ", ..." : "")
                summaryItem(label: "Key Conditions", value: conditionsStr)
                
                let emName = member.emergencyContactName.isEmpty ? "Not set" : member.emergencyContactName
                let emPhone = member.emergencyContactPhone.isEmpty ? "" : " · \(member.emergencyContactPhone)"
                summaryItem(label: "Emergency Contact", value: "\(emName)\(emPhone)")
            }
        }
        .padding(14)
        .background(Color.rose.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Color.rose.opacity(0.15), lineWidth: 1))
        .shadow(color: Color.rose.opacity(0.12), radius: 10, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func summaryItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label.uppercased())
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color.rose)
                .tracking(0.3)
            Text(value)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct SectionAccordion: View {
    let section: MedicalHistoryView.HistorySection
    let member: FamilyMember
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var count: Int {
        switch section {
        case .conditions: return member.conditions.count
        case .surgeries: return member.surgeries.count
        case .allergies: return member.allergies.count
        case .vaccinations: return member.vaccinations.count
        case .visionHearing: return member.visionTests.count + member.hearingTests.count
        case .documents: return member.documents.count
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(section.color.opacity(0.1))
                            .frame(width: 40, height: 40)
                        Image(systemName: section.icon)
                            .font(.system(size: 20))
                            .foregroundStyle(section.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.rawValue)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        Text("\(count) \(count == 1 ? "entry" : "entries")")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
                .background(isExpanded ? section.color.opacity(0.05) : Color.clear)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 0) {
                    Divider().background(Color.border)
                    
                    if count == 0 {
                        Text("No entries yet.")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        switch section {
                        case .conditions: ConditionsContent(member: member)
                        case .surgeries: SurgeriesContent(member: member)
                        case .allergies: AllergiesContent(member: member)
                        case .vaccinations: VaccinationsContent(member: member)
                        case .visionHearing: VisionHearingContent(member: member)
                        case .documents: DocumentsContent(member: member)
                        }
                    }
                }
            }
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmBrown.opacity(0.06), radius: 10, x: 0, y: 2)
    }
}

// MARK: - Accordion Contents

struct ConditionsContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let sorted = member.conditions.sorted { $0.isActive && !$1.isActive }
            ForEach(Array(sorted.enumerated()), id: \.element.id) { index, cond in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        Text(cond.name)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        Spacer()
                        
                        let isActive = cond.isActive
                        let tagColor = isActive ? Color(hex: "C47C2F") : Color(hex: "5DAB6F")
                        
                        Text(isActive ? "Active" : "Resolved")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(tagColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(tagColor.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    let dateStr = cond.diagnosedDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown"
                    let drStr = cond.diagnosedBy.isEmpty ? "Unknown Dr." : cond.diagnosedBy
                    Text("Diagnosed: \(dateStr) · \(drStr)")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                    
                    if !cond.treatment.isEmpty || !cond.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            if !cond.treatment.isEmpty {
                                Text("Treatment: \(cond.treatment)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color.sageDark)
                            }
                            if !cond.notes.isEmpty {
                                Text(cond.notes)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.bg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 4)
                    }
                }
                .padding(16)
                
                if index < sorted.count - 1 {
                    Divider().background(Color.border)
                }
            }
        }
    }
}

struct SurgeriesContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let sorted = member.surgeries.sorted { $0.date > $1.date }
            ForEach(Array(sorted.enumerated()), id: \.element.id) { index, surg in
                VStack(alignment: .leading, spacing: 6) {
                    Text(surg.name)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    
                    Text("\(surg.date.formatted(date: .abbreviated, time: .omitted)) · \(surg.hospital)")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                    
                    if !surg.outcome.isEmpty || !surg.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            if !surg.outcome.isEmpty {
                                Text("Outcome: \(surg.outcome)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(Color(hex: "5DAB6F"))
                            }
                            if !surg.notes.isEmpty {
                                Text(surg.notes)
                                    .font(.system(size: 12))
                                    .foregroundStyle(Color.textPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.bg)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top, 4)
                    }
                }
                .padding(16)
                
                if index < sorted.count - 1 {
                    Divider().background(Color.border)
                }
            }
        }
    }
}

struct AllergiesContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let sorted = member.allergies.sorted { $0.severity.rawValue > $1.severity.rawValue }
            ForEach(Array(sorted.enumerated()), id: \.element.id) { index, allergy in
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("⚠️ \(allergy.allergen)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color.rose)
                            
                            let dateStr = allergy.diagnosedDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown"
                            Text("\(allergy.category.rawValue) · Noted: \(dateStr)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textSecondary)
                        }
                        Spacer()
                        
                        let isSevere = allergy.severity == .severe
                        let tagColor = isSevere ? Color.rose : Color(hex: "C47C2F")
                        
                        Text(allergy.severity.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(tagColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(tagColor.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    if !allergy.reaction.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reaction: \(allergy.reaction)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Color.rose)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.rose.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 4)
                    }
                    
                    if !allergy.notes.isEmpty {
                        Text(allergy.notes)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textPrimary)
                    }
                }
                .padding(16)
                
                if index < sorted.count - 1 {
                    Divider().background(Color.border)
                }
            }
        }
    }
}

struct VaccinationsContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let sorted = member.vaccinations.sorted { $0.date > $1.date }
            ForEach(Array(sorted.enumerated()), id: \.element.id) { index, vax in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(vax.name)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text(vax.date.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                        if let next = vax.nextDueDate {
                            Text("Next: \(next.formatted(date: .abbreviated, time: .omitted))")
                                .font(.system(size: 11))
                                .foregroundStyle(vax.isDue ? Color.rose : Color(hex: "5DAB6F"))
                        }
                    }
                    Spacer()
                    ZStack {
                        Circle()
                            .fill(Color(hex: "5DAB6F").opacity(0.15))
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color(hex: "5DAB6F"))
                    }
                }
                .padding(16)
                
                if index < sorted.count - 1 {
                    Divider().background(Color.border)
                }
            }
        }
    }
}

struct VisionHearingContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let entries = Array(member.visionTests.sorted { $0.date > $1.date })
            ForEach(Array(entries.enumerated()), id: \.element.id) { index, test in
                VStack(alignment: .leading, spacing: 4) {
                    Text("Vision Test")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text("\(test.date.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                    Text("L: \(String(format: "%.2f", test.leftEyeSphere ?? 0.0))  R: \(String(format: "%.2f", test.rightEyeSphere ?? 0.0))")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textPrimary)
                        .padding(.top, 4)
                }
                .padding(16)
                
                if index < entries.count - 1 {
                    Divider().background(Color.border)
                }
            }
            if member.visionTests.isEmpty && member.hearingTests.isEmpty {
                Text("No Eyes & Ears records")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary)
                    .padding()
            }
        }
    }
}

struct DocumentsContent: View {
    let member: FamilyMember
    var body: some View {
        VStack(spacing: 0) {
            let sorted = member.documents.sorted { $0.uploadedAt > $1.uploadedAt }
            ForEach(Array(sorted.enumerated()), id: \.element.id) { index, doc in
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: "5A88C4").opacity(0.1))
                            .frame(width: 40, height: 40)
                        Image(systemName: doc.category.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(Color(hex: "5A88C4"))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(doc.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                        Text("\(doc.category.rawValue) · Saved \(doc.uploadedAt.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.textSecondary)
                        .font(.system(size: 14, weight: .semibold))
                }
                .padding(16)
                
                if index < sorted.count - 1 {
                    Divider().background(Color.border)
                }
            }
        }
    }
}
