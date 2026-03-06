import SwiftUI
import SwiftData

struct LabResultsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var activeTab: RecordTab = .blood
    
    enum RecordTab: String, CaseIterable {
        case blood = "Blood Tests"
        case eye = "Eyesight"
        case hearing = "Hearing"
        
        var icon: String {
            switch self {
            case .blood: return "flask.fill"
            case .eye: return "eye.fill"
            case .hearing: return "ear"
            }
        }
    }
    
    // Sort lab results into the "blood" category for now, as that's the primary mapped type
    private var filteredLabResults: [LabResult] {
        member.labResults
            .sorted { $0.testedAt > $1.testedAt }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.bg.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Tab Bar
                    tabBar
                        .padding(.horizontal, 16)
                        .offset(y: -20)
                        .zIndex(1)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 12) {
                            switch activeTab {
                            case .blood:
                                if filteredLabResults.isEmpty {
                                    SimpleEmptyStateView(
                                        title: "No Blood Tests",
                                        desc: "Add your lab results here."
                                    )
                                } else {
                                    bloodTestsList
                                }
                            case .eye:
                                SimpleEmptyStateView(
                                    title: "No Eyesight Records",
                                    desc: "Add your eye exam results here."
                                )
                            case .hearing:
                                SimpleEmptyStateView(
                                    title: "No Hearing Records",
                                    desc: "Add your hearing rest results here."
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAdd) {
                // Determine which add view to show based on tab
                if activeTab == .blood {
                    AddLabResultView(member: member)
                } else {
                    Text("Add \(activeTab.rawValue) coming soon")
                }
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Medical Tests")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)
                Text("Blood · Eye · Hearing results")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.8))
            }
            
            Spacer()
            
            Button(action: { showAdd = true }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
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
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 50)
        .background(
            LinearGradient(colors: [Color(hex: "8B6FA0"), Color(hex: "7A5C90")], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(edges: .top)
        )
    }
    
    @ViewBuilder
    private var tabBar: some View {
        HStack(spacing: 0) {
            ForEach(RecordTab.allCases, id: \.self) { tab in
                let isSelected = activeTab == tab
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        activeTab = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.icon)
                            .font(.system(size: 18))
                        Text(tab.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(isSelected ? Color(hex: "8B6FA0") : Color.clear)
                    .foregroundStyle(isSelected ? .white : Color.textSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(6)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.warmBrown.opacity(0.1), radius: 16, x: 0, y: 4)
    }
    
    @ViewBuilder
    private var bloodTestsList: some View {
        // Group by Date logically (simplified here to just list them for MVP adaptation)
        let grouped = Dictionary(grouping: filteredLabResults) { result -> String in
            result.testedAt.formatted(date: .abbreviated, time: .omitted)
        }
        
        let sortedDates = grouped.keys.sorted {
            let df = DateFormatter()
            df.dateStyle = .medium
            let d1 = df.date(from: $0) ?? Date.distantPast
            let d2 = df.date(from: $1) ?? Date.distantPast
            return d1 > d2
        }
        
        ForEach(sortedDates, id: \.self) { dateString in
            if let results = grouped[dateString] {
                BloodTestCard(dateString: dateString, results: results)
            }
        }
    }
}

struct BloodTestCard: View {
    let dateString: String
    let results: [LabResult]
    @State private var isExpanded = false
    
    var abnormalCount: Int {
        results.filter { $0.computedStatus != .normal }.count
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dateString)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(Color.textPrimary)
                        
                        Text("\(results.first?.lab ?? "Lab") · \(results.count) markers")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textSecondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if abnormalCount > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 10))
                                Text("\(abnormalCount)")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(hex: "FCEAEA"))
                            .foregroundStyle(Color(hex: "C75050"))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.textSecondary)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
                        BloodTestMarkerRow(result: result, isAlternate: index % 2 != 0)
                        
                        if index < results.count - 1 {
                            Divider().background(Color.border)
                        }
                    }
                }
                .padding(.top, 0)
            }
        }
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.07), radius: 12, x: 0, y: 2)
    }
}

struct BloodTestMarkerRow: View {
    let result: LabResult
    let isAlternate: Bool
    
    var statusColors: (text: Color, bg: Color, icon: String) {
        switch result.computedStatus {
        case .normal: return (Color(hex: "5DAB6F"), Color(hex: "EEF8F1"), "checkmark.circle.fill")
        case .abnormal: return (Color(hex: "C47C2F"), Color(hex: "FFF8E8"), "exclamationmark.triangle.fill") // Borderline
        case .critical: return (Color(hex: "C75050"), Color(hex: "FCEAEA"), "exclamationmark.triangle.fill") // High
        case .pending: return (Color.textSecondary, Color.gray.opacity(0.1), "clock.fill")
        }
    }
    
    var displayStatus: String {
        switch result.computedStatus {
        case .normal: return "Normal"
        case .abnormal: return "Borderline"
        case .critical: return "Above range"
        case .pending: return "Pending"
        }
    }
    
    var rangeDisplay: String {
        if result.referenceRangeText.isEmpty {
            if let low = result.referenceRangeLow, let high = result.referenceRangeHigh {
                return "\(low)-\(high)"
            }
            return ""
        }
        return result.referenceRangeText
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(result.testName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
                if !rangeDisplay.isEmpty {
                    Text("Range: \(rangeDisplay)")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(result.displayValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text(result.unit)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                }
                
                let colors = statusColors
                HStack(spacing: 4) {
                    Image(systemName: colors.icon)
                        .font(.system(size: 10))
                    Text(displayStatus)
                        .font(.system(size: 11, weight: .bold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(colors.bg)
                .foregroundStyle(colors.text)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isAlternate ? Color.bg.opacity(0.5) : Color.clear)
    }
}
