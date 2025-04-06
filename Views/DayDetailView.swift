import SwiftUI

struct WeekDetailView: View {
    var weekDates: [Date]
    var genderLogs: [GenderIdentityLog]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Week Overview")
                .font(.headline)
            ForEach(weekDates, id: \.self) { date in
                let logs = genderLogs.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
                if !logs.isEmpty {
                    Text("\(formattedDate(date))")
                        .bold()
                    ForEach(logs) { log in
                        Text(log.gender.label)
                            .foregroundColor(Color(log.gender.color))
                    }
                }
            }
        }
        .padding(4)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
