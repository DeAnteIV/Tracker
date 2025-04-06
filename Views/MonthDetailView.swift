import SwiftUI

struct MonthDetailView: View {
    var monthDates: [Date]
    var genderLogs: [GenderIdentityLog]

    var body: some View {

    var mostFrequentByDay: [Date: SharkGender] {
        Dictionary(grouping: genderLogs, by: { Calendar.current.startOfDay(for: $0.timestamp) })
            .mapValues { logs in
                let counts = Dictionary(grouping: logs, by: \.gender).mapValues { $0.count }
                return counts.max(by: { $0.value < $1.value })?.key ?? .masc
            }
    }

    var MonthStats: [SharkGender: Int] {
        let all = mostFrequentByDay.values
        return Dictionary(grouping: all, by: { $0 }).mapValues { $0.count }
    }

    var normalizedStats: [(SharkGender, Double)] {
        let total = Double(MonthDates.count)
        return SharkGender.allCases.map { gender in
            let count = Double(MonthStats[gender] ?? 0)
            return (gender, count / total)
        }
    }

        VStack(alignment: .leading, spacing: 12) {
            Text("Monthly Gender Breakdown")
                .font(.headline)

            GeometryReader { geo in
                HStack(spacing: 0) {
                    ForEach(normalizedStats.indices, id: \.self) { i in
                        let stat = normalizedStats[i]
                        Rectangle()
                            .fill(Color(stat.0.color))
                            .frame(width: geo.size.width * stat.1)
                    }
                }
                .frame(height: 16)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .frame(height: 16)

            ForEach(normalizedStats.filter { $0.1 > 0 }, id: \.0) { (gender, percent) in
                HStack {
                    Circle()
                        .fill(Color(gender.color))
                        .frame(width: 10, height: 10)
                    Text("\(gender.label): \((percent * 100), specifier: "%.1f")% of week")
                        .font(.caption)
                }
            }

            Divider()

            // Bar graph showing summary of week
            GenderBarGraphView(dates: MonthDates)
                .frame(height: 200)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
        .padding(.top)
    }
}
