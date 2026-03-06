import SwiftUI
import SwiftData

struct PrescriptionsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var expandedMed: UUID? = nil
    @Environment(\.dismiss) private var dismiss

    var activeMeds: [Prescription] {
        member.prescriptions.filter { $0.isActive }.sorted { $0.startDate > $1.startDate }
    }
    
    var pastMeds: [Prescription] {
        member.prescriptions.filter { !$0.isActive }.sorted { $0.endDate ?? Date() > $1.endDate ?? Date() }
    }
    
    var takenToday: Int {
        // Mocking: Just saying half of them are taken today if we don't have tracking in model yet
        // In a real app we'd have a tracking log model. 
        activeMeds.filter { _ in Bool.random() }.count
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: [Color(hex: "8B6FA0"), Color(hex: "7A5C90")], startPoint: .topLeading, endPoint: .bottomTrailing)
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
                                Text("Prescriptions")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("Medications & refill tracker")
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
                        
                        // Today's Summary
                        if !activeMeds.isEmpty {
                            TodaysDosesSummary(activeMeds: activeMeds)
                                .padding(.horizontal, 16)
                                .offset(y: -16)
                                .zIndex(10)
                        }
                        
                        // Refill Alert
                        if let expiring = activeMeds.first(where: { $0.isExpiringSoon }) {
                            RefillAlertBanner(prescription: expiring)
                        }

                        // Active Medications
                        if !activeMeds.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Active Medications")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.textPrimary)
                                    .padding(.horizontal, 16)
                                    .padding(.top, activeMeds.isEmpty ? 16 : 0)
                                
                                ForEach(activeMeds) { med in
                                    ActiveMedicationCard(
                                        med: med,
                                        isExpanded: expandedMed == med.id,
                                        onToggle: {
                                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                if expandedMed == med.id {
                                                    expandedMed = nil
                                                } else {
                                                    expandedMed = med.id
                                                }
                                            }
                                        }
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        
                        // Past Medications
                        if !pastMeds.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Past Medications")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.textPrimary)
                                    .padding(.horizontal, 16)
                                
                                ForEach(pastMeds) { med in
                                    PastMedicationRow(med: med)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 16)
                        }
                        
                        if activeMeds.isEmpty && pastMeds.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "pill.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color.textSecondary.opacity(0.5))
                                Text("No Medications Recorded")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.textPrimary)
                                Text("Add your current and past prescriptions to track what you're taking.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                            .padding(.horizontal, 32)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAdd) {
            AddPrescriptionView(member: member)
        }
    }
}

// MARK: - Subcomponents

struct TodaysDosesSummary: View {
    let activeMeds: [Prescription]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("TODAY'S DOSES")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.textSecondary)
                .tracking(0.5)
            
            HStack(spacing: 8) {
                // For demonstration, taking up to first 5
                ForEach(activeMeds.prefix(5)) { med in
                    // We arbitrarily decide if taken for demo since tracking model isn't there
                    let taken = Int.random(in: 0...1) == 1
                    let medColor = medicationColor(for: med)
                    VStack(spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(taken ? medColor : Color.bg)
                                .frame(width: 40, height: 40)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(taken ? medColor : Color.border, lineWidth: 2))
                            
                            if taken {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 18))
                            } else {
                                Text("💊")
                                    .font(.system(size: 14))
                            }
                        }
                        
                        Text(med.medicationName.components(separatedBy: " ").first ?? med.medicationName)
                            .font(.system(size: 10))
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                            .frame(maxWidth: 50)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            
            VStack(spacing: 4) {
                HStack {
                    Text("Progress today")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.textSecondary)
                    Spacer()
                    // Random progress for mockup
                    let takenCount = activeMeds.filter{ _ in Bool.random() }.count
                    Text("\(takenCount)/\(activeMeds.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: "8B6FA0"))
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.border)
                            .frame(height: 6)
                        Capsule()
                            .fill(Color(hex: "8B6FA0"))
                            .frame(width: geo.size.width * 0.6, height: 6) // Example fixed mock ratio
                    }
                }
                .frame(height: 6)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.1), radius: 16, x: 0, y: 4)
    }
}

struct RefillAlertBanner: View {
    let prescription: Prescription
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(Color(hex: "C47C2F"))
                .font(.system(size: 20))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Refill needed soon")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color(hex: "9A5E00"))
                Text("\(prescription.medicationName) — \(prescription.refillsRemaining) refills left. Contact Dr. \(prescription.prescribedBy).")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: "B87820"))
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(Color(hex: "FFF3E0"))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "FFD180"), lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct ActiveMedicationCard: View {
    let med: Prescription
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var medColor: Color {
        medicationColor(for: med)
    }

    // Mock taken state
    var taken: Bool {
        med.medicationName.count % 2 == 0 // Deterministic mock
    }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(medColor.opacity(0.15))
                            .frame(width: 44, height: 44)
                        Text("💊") // Use icon field if available, but for now simple string
                            .font(.system(size: 20))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 8) {
                            Text(med.medicationName)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(Color.textPrimary)
                            Text(med.displayDosage)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(medColor)
                        }
                        Text("\(med.frequency) · \(med.startDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                        if !med.reason.isEmpty {
                            Text("For: \(med.reason)")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        if taken {
                            HStack(spacing: 3) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 12))
                                Text("Taken")
                                    .font(.system(size: 11, weight: .semibold))
                            }
                            .foregroundStyle(Color(hex: "5DAB6F"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "EEF8F1"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            HStack(spacing: 3) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: 12))
                                Text("Due")
                                    .font(.system(size: 11, weight: .semibold))
                            }
                            .foregroundStyle(Color(hex: "C47C2F"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(hex: "FFF3E0"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(Color.border)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.clear)
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 0) {
                    Divider().background(Color.border)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Quick details grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            detailBox(label: "PRESCRIBED BY", value: med.prescribedBy.isEmpty ? "Dr. Unknown" : "Dr. \(med.prescribedBy)", highlight: false)
                            detailBox(label: "STARTED", value: med.startDate.formatted(date: .abbreviated, time: .omitted), highlight: false)
                            
                            // Mocking next refill
                            let daysLeft = med.refillsRemaining * 30
                            let highlightRefill = daysLeft <= 14 && med.refillsRemaining > 0
                            detailBox(label: "REFILLS LEFT", value: "\(med.refillsRemaining)", highlight: highlightRefill)
                            
                            detailBox(label: "STATUS", value: "Active", highlightColor: Color(hex: "5DAB6F"))
                        }
                        .padding(.top, 12)
                        
                        if !med.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("INSTRUCTIONS")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Color.pink100)
                                    .tracking(0.5)
                                Text(med.instructions)
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color.textPrimary)
                                    .lineSpacing(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color.pink50)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.pink100.opacity(0.35), lineWidth: 1))
                        }
                        
                        if !med.sideEffectsNoted.isEmpty || !med.notes.isEmpty {
                            let contentToWatch = med.sideEffectsNoted.isEmpty ? med.notes : med.sideEffectsNoted
                            VStack(alignment: .leading, spacing: 4) {
                                Text("SIDE EFFECTS TO WATCH")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundStyle(Color(hex: "C47C2F"))
                                    .tracking(0.5)
                                Text(contentToWatch)
                                    .font(.system(size: 13))
                                    .foregroundStyle(Color.textPrimary)
                                    .lineSpacing(2)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                            .background(Color(hex: "FFF8E8"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "FFE0A0").opacity(0.33), lineWidth: 1))
                        }
                        
                        if med.isExpiringSoon {
                            Button {
                                // Request refill action
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .font(.system(size: 16))
                                    Text("Request Refill")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(Color.pink50.opacity(0.2)) // Match web "C.primary" roughly if we used it, web has full fill C.primary
                                .background(Color(hex: "E07283")) // using hex of C.primary
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.clear, lineWidth: 0)
        )
        // Simulate border left by adding a rectangle
        .background(
            HStack(spacing: 0) {
                medColor.frame(width: 4)
                Spacer()
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.07), radius: 12, x: 0, y: 2)
    }
    
    @ViewBuilder
    private func detailBox(label: String, value: String, highlight: Bool = false, highlightColor: Color? = nil) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.textSecondary)
            Text(value)
                .font(.system(size: 13, weight: highlightColor == nil ? .semibold : .bold))
                .foregroundStyle(highlightColor != nil ? highlightColor! : (highlight ? Color(hex: "C47C2F") : Color.textPrimary))
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(highlight ? Color(hex: "FFF3E0") : Color.bg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PastMedicationRow: View {
    let med: Prescription
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(med.medicationName)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                Text(med.reason.isEmpty ? "No reason specified" : med.reason)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
                
                let start = med.startDate.formatted(date: .abbreviated, time: .omitted)
                let end = med.endDate?.formatted(date: .abbreviated, time: .omitted) ?? "Unknown"
                let doc = med.prescribedBy.isEmpty ? "" : " · Dr. \(med.prescribedBy)"
                Text("\(start) – \(end)\(doc)")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
            Spacer()
            
            Text("Completed")
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color(hex: "5DAB6F"))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color(hex: "EEF8F1"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(14)
        .background(Color.card.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

// MARK: - Helper

func medicationColor(for med: Prescription) -> Color {
    // Generate a deterministic color based on medication name length
    let colors: [Color] = [
        Color(hex: "E07283"), // C.primary
        Color(hex: "5A88C4"), // Blue
        Color(hex: "5DAB6F"), // Green
        Color(hex: "C47C2F"), // Orange
        Color(hex: "8B6FA0")  // Purple
    ]
    let index = med.medicationName.count % colors.count
    return colors[index]
}
