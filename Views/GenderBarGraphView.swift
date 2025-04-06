import SwiftUI
import Charts

struct GenderBarGraphView: View {
    var date: Date
    let tracker = GenderTracker.shared

    var body: some View {
        let logs = tracker.logs(for: date)
        let grouped = Dictionary(grouping: logs, by: { $0.gender })

        let chartData = grouped.map { (gender, entries) in
            (gender: gender, count: entries.count)
        }

        Chart {
            ForEach(chartData, id: \.gender) { entry in
                BarMark(
                    x: .value("Gender", entry.gender.label),
                    y: .value("Count", entry.count)
                )
                .foregroundStyle(Color(entry.gender.color))
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
    }
}
