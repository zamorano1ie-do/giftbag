import SwiftUI
import SwiftData
import Charts

struct VitalsListView: View {
    let member: FamilyMember
    @State private var showAdd = false
    @State private var activeChart: ChartType = .weight
    @Environment(\.dismiss) private var dismiss

    enum ChartType {
        case weight
        case bp
    }

    var vitals: [VitalReading] {
        member.vitals.sorted { $0.recordedAt > $1.recordedAt }
    }
    
    var latestWeight: VitalReading? { vitals.first { $0.type == .weight } }
    var latestHeight: VitalReading? { vitals.first { $0.type == .height } }
    var latestBP: VitalReading? { vitals.first { $0.type == .bloodPressure } }
    var latestHR: VitalReading? { vitals.first { $0.type == .heartRate } }

    var bmi: Double? {
        // Needs height in meters and weight in kg to calculate.
        // Assuming height here is in cm based on standard.
        guard let w = latestWeight?.value, let h = latestHeight?.value, h > 0 else { return nil }
        // if h is cm
        let heightMeters = h / 100.0
        return w / (heightMeters * heightMeters)
    }

    var weightHistory: [VitalReading] {
        vitals.filter { $0.type == .weight }.sorted { $0.recordedAt < $1.recordedAt }
    }
    
    var bpHistory: [VitalReading] {
        vitals.filter { $0.type == .bloodPressure }.sorted { $0.recordedAt < $1.recordedAt }
    }

    var body: some View {
        ZStack(alignment: .top) {
            Color.bg.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .topTrailing) {
                    LinearGradient(colors: [Color.sage, Color.sageDark], startPoint: .topLeading, endPoint: .bottomTrailing)
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
                                Text("My Vitals")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                Text("Last updated today") // Needs real last updated
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
                                    Text("Log")
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
                        if vitals.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "waveform.path.ecg")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color.textSecondary.opacity(0.5))
                                Text("No Vitals Yet")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(Color.textPrimary)
                                Text("Start tracking your blood pressure, weight, heart rate, and more.")
                                    .font(.system(size: 14))
                                    .foregroundStyle(Color.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 40)
                            .padding(.horizontal, 32)
                        } else {
                            // Key Metrics
                            HStack(spacing: 8) {
                                MetricCard(
                                    label: "Weight",
                                    value: latestWeight.map { String(format: "%.1f", $0.value) } ?? "--",
                                    unit: latestWeight?.unit ?? "kg",
                                    trend: .down, // Mock trend
                                    color: Color(hex: "E07283"),
                                    bgColor: Color.pink50
                                )
                                MetricCard(
                                    label: "Height",
                                    value: latestHeight.map { String(Int($0.value)) } ?? "--",
                                    unit: latestHeight?.unit ?? "cm",
                                    trend: .stable,
                                    color: Color.sageDark,
                                    bgColor: Color.sage50
                                )
                                MetricCard(
                                    label: "BMI",
                                    value: bmi.map { String(format: "%.1f", $0) } ?? "--",
                                    unit: "",
                                    trend: .down,
                                    color: Color(hex: "8B6FA0"),
                                    bgColor: Color(hex: "F3EEF8")
                                )
                            }
                            .padding(.horizontal, 16)
                            .offset(y: -16)
                            .zIndex(10)
                            
                            // BP & Heart Rate
                            HStack(spacing: 10) {
                                BPCard(latestBP: latestBP)
                                HRCard(latestHR: latestHR)
                            }
                            .padding(.horizontal, 16)
                            
                            // Charts
                            if !vitals.isEmpty {
                                VitalsChartCard(
                                    activeChart: $activeChart,
                                    weightData: weightHistory,
                                    bpData: bpHistory
                                )
                                .padding(.horizontal, 16)
                            }
                            
                            // Recent Readings
                            if !vitals.isEmpty {
                                RecentReadingsSection(readings: Array(vitals.prefix(5)))
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAdd) {
            AddVitalView(member: member)
        }
    }
}

// MARK: - Subcomponents

enum TrendDirection {
    case up, down, stable
}

struct MetricCard: View {
    let label: String
    let value: String
    let unit: String
    let trend: TrendDirection
    let color: Color
    let bgColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color.textSecondary)
                .tracking(0.3)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(Color.textPrimary)
                if !unit.isEmpty {
                    Text(unit)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            
            HStack(spacing: 3) {
                switch trend {
                case .down:
                    Image(systemName: "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(hex: "5DAB6F"))
                    Text("Improving")
                        .font(.system(size: 11))
                        .foregroundStyle(Color(hex: "5DAB6F"))
                case .up:
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color(hex: "E05050"))
                    Text("Rising")
                        .font(.system(size: 11))
                        .foregroundStyle(Color(hex: "E05050"))
                case .stable:
                    Image(systemName: "minus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.textSecondary)
                    Text("Stable")
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .padding(.vertical, 14)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.15), lineWidth: 1))
    }
}

struct BPCard: View {
    let latestBP: VitalReading?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "E07283"))
                Text("Blood Pressure")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
            
            if let bp = latestBP {
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("\(Int(bp.value))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text("/\(Int(bp.secondaryValue ?? 0))")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                }
                
                let analysis = bp.statusColor == .normal ? "Normal range" : (bp.statusColor == .elevated ? "Slightly high" : "High")
                let color = bp.statusColor == .normal ? Color(hex: "5DAB6F") : (bp.statusColor == .elevated ? Color(hex: "C47C2F") : Color(hex: "E05050"))
                
                Text("mmHg · \(analysis)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)
            } else {
                Text("--/--")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.textSecondary.opacity(0.5))
                Text("No data")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.warmBrown.opacity(0.07), radius: 10, x: 0, y: 2)
    }
}

struct HRCard: View {
    let latestHR: VitalReading?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "waveform.path.ecg")
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "5DAB6F"))
                Text("Heart Rate")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.textSecondary)
            }
            
            if let hr = latestHR {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(Int(hr.value))")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text("bpm")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.textSecondary)
                }
                
                let analysis = hr.statusColor == .normal ? "Normal range" : (hr.statusColor == .elevated ? "Slightly high" : "High")
                let color = hr.statusColor == .normal ? Color(hex: "5DAB6F") : (hr.statusColor == .elevated ? Color(hex: "C47C2F") : Color(hex: "E05050"))
                Text(analysis)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(color)
            } else {
                Text("--")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.textSecondary.opacity(0.5))
                Text("No data")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.warmBrown.opacity(0.07), radius: 10, x: 0, y: 2)
    }
}

struct VitalsChartCard: View {
    @Binding var activeChart: VitalsListView.ChartType
    let weightData: [VitalReading]
    let bpData: [VitalReading]
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            
            if activeChart == .weight {
                weightChartView
            } else {
                bpChartView
            }
        }
        .padding(16)
        .background(Color.card)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.warmBrown.opacity(0.07), radius: 12, x: 0, y: 2)
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            Text("Trends")
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(Color.textPrimary)
            
            Spacer()
            
            HStack(spacing: 2) {
                Button("Weight") { activeChart = .weight }
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(activeChart == .weight ? Color(hex: "E07283") : Color.clear)
                    .foregroundStyle(activeChart == .weight ? .white : Color.textSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Button("BP") { activeChart = .bp }
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(activeChart == .bp ? Color(hex: "E07283") : Color.clear)
                    .foregroundStyle(activeChart == .bp ? .white : Color.textSecondary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(3)
            .background(Color.bg)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    @ViewBuilder
    private var weightChartView: some View {
        if weightData.count >= 2 {
            Chart {
                ForEach(weightData) { item in
                    LineMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Weight", item.value)
                    )
                    .foregroundStyle(Color(hex: "E07283"))
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    
                    PointMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Weight", item.value)
                    )
                    .foregroundStyle(Color(hex: "E07283"))
                    .symbolSize(40)
                }
            }
            .frame(height: 160)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [3, 3])).foregroundStyle(Color.border)
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [3, 3])).foregroundStyle(Color.border)
                    AxisValueLabel()
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        } else {
            Text("Not enough data points for weight chart.")
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .frame(height: 160)
        }
    }

    @ViewBuilder
    private var bpChartView: some View {
        if bpData.count >= 2 {
            Chart {
                ForEach(bpData) { item in
                    LineMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Systolic", item.value),
                        series: .value("Type", "Sys")
                    )
                    .foregroundStyle(Color(hex: "E07283"))
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    
                    PointMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Systolic", item.value)
                    )
                    .foregroundStyle(Color(hex: "E07283"))
                    .symbolSize(30)
                    
                    LineMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Diastolic", item.secondaryValue ?? 0),
                        series: .value("Type", "Dia")
                    )
                    .foregroundStyle(Color(hex: "F3B0BC"))
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    
                    PointMark(
                        x: .value("Date", item.recordedAt),
                        y: .value("Diastolic", item.secondaryValue ?? 0)
                    )
                    .foregroundStyle(Color(hex: "F3B0BC"))
                    .symbolSize(30)
                }
            }
            .frame(height: 160)
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [3, 3])).foregroundStyle(Color.border)
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [3, 3])).foregroundStyle(Color.border)
                    AxisValueLabel()
                        .font(.system(size: 11))
                        .foregroundStyle(Color.textSecondary)
                }
            }
        } else {
            Text("Not enough data points for blood pressure chart.")
                .font(.system(size: 13))
                .foregroundStyle(Color.textSecondary)
                .frame(height: 160)
        }
    }
}

struct RecentReadingsSection: View {
    let readings: [VitalReading]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Readings")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.textPrimary)
            
            VStack(spacing: 0) {
                // Table header
                HStack {
                    tableHeader(text: "DATE", flex: 2)
                    tableHeader(text: "TYPE", flex: 1.5)
                    tableHeader(text: "VALUE", flex: 1.5)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.bg)
                .overlay(Rectangle().frame(height: 1).foregroundStyle(Color.border), alignment: .bottom)
                
                // Table rows
                ForEach(Array(readings.enumerated()), id: \.offset) { index, reading in
                    HStack {
                        // Date
                        Text(reading.recordedAt.formatted(date: .abbreviated, time: .omitted))
                            .font(.system(size: 13))
                            .foregroundStyle(Color.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .layoutPriority(2)
                        
                        // Type
                        Text(reading.type.rawValue)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .layoutPriority(1.5)
                        
                        // Value
                        Text(reading.displayValue)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color(hex: "E07283")) // generic but matches vibe
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .layoutPriority(1.5)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .overlay(
                        Group {
                            if index < readings.count - 1 {
                                Rectangle().frame(height: 1).foregroundStyle(Color.border)
                            }
                        },
                        alignment: .bottom
                    )
                }
            }
            .background(Color.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.warmBrown.opacity(0.06), radius: 10, x: 0, y: 2)
        }
    }
    
    @ViewBuilder
    private func tableHeader(text: String, flex: Double) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(Color.textSecondary)
            .tracking(0.5)
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(flex)
    }
}
