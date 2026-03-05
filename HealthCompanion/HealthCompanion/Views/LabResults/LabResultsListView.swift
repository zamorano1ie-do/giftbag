import SwiftUI
import SwiftData

struct LabResultsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var selectedCategory: LabCategory? = nil
    @State private var searchText = ""

    private var filtered: [LabResult] {
        member.labResults
            .filter { selectedCategory == nil || $0.category == selectedCategory }
            .filter { searchText.isEmpty || $0.testName.localizedCaseInsensitiveContains(searchText) }
            .sorted { $0.testedAt > $1.testedAt }
    }

    private var groupedByDate: [(String, [LabResult])] {
        let grouped = Dictionary(grouping: filtered) { result -> String in
            result.testedAt.formatted(.dateTime.month(.wide).year())
        }
        return grouped.sorted { a, b in
            let df = DateFormatter()
            df.dateFormat = "MMMM yyyy"
            let da = df.date(from: a.key) ?? Date.distantPast
            let db = df.date(from: b.key) ?? Date.distantPast
            return da > db
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if member.labResults.isEmpty {
                    EmptyStateView(
                        icon: "drop.fill",
                        title: "No Lab Results Yet",
                        message: "Add your blood test results, urinalysis, and other lab reports here.",
                        buttonTitle: "Add Lab Result"
                    ) { showAdd = true }
                } else {
                    VStack(spacing: 0) {
                        // Category filter
                        categoryFilter
                        list
                    }
                }
            }
            .navigationTitle("Lab Results")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search tests…")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAdd = true } label: {
                        Image(systemName: "plus").font(.title3)
                    }
                    .accessibilityLabel("Add lab result")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddLabResultView(member: member)
            }
        }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppTheme.Spacing.sm) {
                FilterChip(title: "All", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                ForEach(LabCategory.allCases, id: \.self) { cat in
                    FilterChip(title: cat.rawValue, isSelected: selectedCategory == cat) {
                        selectedCategory = selectedCategory == cat ? nil : cat
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
        .background(Color(.secondarySystemBackground))
    }

    private var list: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(groupedByDate, id: \.0) { month, results in
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        Text(month)
                            .font(AppTheme.Font.label)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, AppTheme.Spacing.md)

                        VStack(spacing: 0) {
                            ForEach(results) { result in
                                LabResultRow(result: result)
                                if result.id != results.last?.id {
                                    Divider().padding(.leading, 80)
                                }
                            }
                        }
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
                    }
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct LabResultRow: View {
    let result: LabResult
    @State private var expanded = false

    var statusColor: Color {
        switch result.computedStatus {
        case .normal:   return .green
        case .abnormal: return .orange
        case .critical: return .red
        case .pending:  return .secondary
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            Button { withAnimation { expanded.toggle() } } label: {
                HStack(spacing: AppTheme.Spacing.md) {
                    IconBadge(icon: result.category.icon, color: AppTheme.Section.labs, size: 44)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(result.testName)
                            .font(AppTheme.Font.subhead)
                            .fontWeight(.semibold)
                            .foregroundStyle(.primary)
                        HStack(spacing: 6) {
                            Text(result.category.rawValue)
                                .font(AppTheme.Font.caption)
                                .foregroundStyle(.secondary)
                            if !result.lab.isEmpty {
                                Text("·")
                                    .foregroundStyle(.secondary)
                                Text(result.lab)
                                    .font(AppTheme.Font.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 4) {
                        Text(result.displayValue)
                            .font(AppTheme.Font.subhead)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        StatusPill(label: result.computedStatus.rawValue, color: statusColor)
                    }

                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(AppTheme.Spacing.md)
                .frame(minHeight: AppTheme.tapTargetHeight)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Divider()
                    if !result.referenceRangeText.isEmpty || result.referenceRangeLow != nil {
                        let rangeText = result.referenceRangeText.isEmpty
                            ? "\(result.referenceRangeLow.map { String(format: "%.2f", $0) } ?? "?") – \(result.referenceRangeHigh.map { String(format: "%.2f", $0) } ?? "?") \(result.unit)"
                            : result.referenceRangeText
                        LabelValueRow(label: "Reference Range", value: rangeText)
                    }
                    if !result.orderedBy.isEmpty {
                        LabelValueRow(label: "Ordered by", value: result.orderedBy)
                    }
                    LabelValueRow(label: "Test date", value: result.testedAt.formatted(date: .long, time: .omitted))
                    if !result.notes.isEmpty {
                        LabelValueRow(label: "Notes", value: result.notes)
                    }
                }
                .padding([.horizontal, .bottom], AppTheme.Spacing.md)
            }
        }
    }
}

struct LabelValueRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(AppTheme.Font.label)
                .foregroundStyle(.secondary)
                .frame(width: 140, alignment: .leading)
            Text(value)
                .font(AppTheme.Font.body)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.Font.label)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.tertiarySystemBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
