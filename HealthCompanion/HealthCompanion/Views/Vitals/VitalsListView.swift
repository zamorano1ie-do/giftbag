import SwiftUI
import SwiftData
import Charts

struct VitalsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var selectedType: VitalType = .bloodPressure
    @State private var showChart = false

    // Group vitals by type, sorted newest first within each group
    private var vitalsByType: [(VitalType, [VitalReading])] {
        let grouped = Dictionary(grouping: member.vitals) { $0.type }
        return VitalType.allCases.compactMap { type in
            guard let readings = grouped[type], !readings.isEmpty else { return nil }
            return (type, readings.sorted { $0.recordedAt > $1.recordedAt })
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if member.vitals.isEmpty {
                    EmptyStateView(
                        icon: "waveform.path.ecg",
                        title: "No Vitals Yet",
                        message: "Start tracking your blood pressure, weight, heart rate, and more.",
                        buttonTitle: "Record a Vital"
                    ) { showAdd = true }
                } else {
                    list
                }
            }
            .navigationTitle("Vitals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }
                    .accessibilityLabel("Add vital reading")
                }
            }
            .sheet(isPresented: $showAdd) {
                AddVitalView(member: member)
            }
        }
    }

    private var list: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.md) {
                ForEach(vitalsByType, id: \.0) { type, readings in
                    VitalTypeCard(type: type, readings: readings, member: member)
                }
            }
            .padding(AppTheme.Spacing.md)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Vital Type Card

struct VitalTypeCard: View {
    let type: VitalType
    let readings: [VitalReading]
    let member: FamilyMember
    @State private var showAll = false
    @State private var showChart = false

    private var latest: VitalReading { readings[0] }
    private var previous: VitalReading? { readings.count > 1 ? readings[1] : nil }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: AppTheme.Spacing.md) {
                IconBadge(icon: type.icon, color: AppTheme.Section.vitals, size: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(type.rawValue)
                        .font(AppTheme.Font.subhead)
                        .fontWeight(.semibold)
                    Text("Last: \(latest.recordedAt.formatted(date: .abbreviated, time: .omitted))")
                        .font(AppTheme.Font.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(latest.displayValue)
                        .font(AppTheme.Font.heading)
                        .fontWeight(.bold)
                    StatusPill(
                        label: latest.statusColor.label,
                        color: statusColor(for: latest.statusColor)
                    )
                }
            }
            .padding(AppTheme.Spacing.md)

            // Trend chart (if 2+ readings)
            if readings.count >= 2 {
                Divider()
                VitalMiniChart(readings: Array(readings.prefix(10).reversed()), type: type)
                    .frame(height: 80)
                    .padding(.horizontal, AppTheme.Spacing.md)
                    .padding(.vertical, AppTheme.Spacing.sm)
            }

            // History rows
            Divider()
            ForEach(Array(readings.prefix(showAll ? 999 : 3).enumerated()), id: \.offset) { _, reading in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(reading.displayValue)
                            .font(AppTheme.Font.body)
                            .fontWeight(.semibold)
                        Text(reading.recordedAt.formatted(date: .long, time: .shortened))
                            .font(AppTheme.Font.caption)
                            .foregroundStyle(.secondary)
                        if !reading.notes.isEmpty {
                            Text(reading.notes)
                                .font(AppTheme.Font.caption)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                    }
                    Spacer()
                    StatusPill(label: reading.statusColor.label, color: statusColor(for: reading.statusColor))
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .frame(minHeight: AppTheme.tapTargetHeight)
                if reading.id != readings.prefix(showAll ? 999 : 3).last?.id {
                    Divider().padding(.leading, AppTheme.Spacing.md)
                }
            }

            if readings.count > 3 {
                Button {
                    withAnimation { showAll.toggle() }
                } label: {
                    Text(showAll ? "Show Less" : "Show All \(readings.count) Readings")
                        .font(AppTheme.Font.body)
                        .foregroundStyle(.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: AppTheme.tapTargetHeight)
                }
                .buttonStyle(.plain)
            }
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.Radius.md))
    }

    private func statusColor(for status: VitalStatus) -> Color {
        switch status {
        case .normal:   return .green
        case .elevated: return .yellow
        case .high:     return .orange
        case .critical: return .red
        }
    }
}

// MARK: - Mini Trend Chart

struct VitalMiniChart: View {
    let readings: [VitalReading]
    let type: VitalType

    var body: some View {
        Chart {
            ForEach(readings) { reading in
                LineMark(
                    x: .value("Date", reading.recordedAt),
                    y: .value("Value", reading.value)
                )
                .foregroundStyle(AppTheme.Section.vitals)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Date", reading.recordedAt),
                    y: .value("Value", reading.value)
                )
                .foregroundStyle(AppTheme.Section.vitals.opacity(0.15))
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", reading.recordedAt),
                    y: .value("Value", reading.value)
                )
                .foregroundStyle(AppTheme.Section.vitals)
                .symbolSize(30)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
    }
}
