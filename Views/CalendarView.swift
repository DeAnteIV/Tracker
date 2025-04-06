import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var displayMode: CalendarMode = .month

    var body: some View {
        CalendarGridView(selectedDate: $selectedDate, displayMode: $displayMode)
    }
}

struct CalendarGridView: View {
    @Binding var selectedDate: Date         // Binding property named selectedDate
    @Binding var displayMode: CalendarMode  // Binding property named displayMode

    @ObservedObject private var tracker = GenderTracker.shared
    private let calendar = Calendar.current

    private var visibleDates: [Date] {
        // returns [Date] (no overshadowing variables named ‘date’)
        switch displayMode {
        case .day:
            return [selectedDate]
        case .week:
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return [] }
            return calendar.generateDates(in: weekInterval)
        case .month:
            guard let monthInterval = calendar.dateInterval(of: .month, for: selectedDate) else { return [] }
            return calendar.generateDates(in: monthInterval)
        }
    }

    private func dominantGender(on date: Date) -> SharkGender? {
        // ‘date’ is a parameter, standard usage (does NOT overshadow Calendar method)
        let dayLogs = tracker.logs(for: date)
        let counts = Dictionary(grouping: dayLogs, by: { $0.gender }).mapValues { $0.count }
        return counts.max { $0.value < $1.value }?.key
    }

    private func color(for gender: SharkGender?) -> Color {
        switch gender {
        case .masc:      return Color.blue.opacity(0.6)
        case .fem:       return Color.pink.opacity(0.6)
        case .nonbinary: return Color.green.opacity(0.6)
        default:         return Color.gray.opacity(0.1)
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            Text(headerTitle(for: selectedDate))
                .font(.title2)
                .bold()

            if displayMode != .day {
                HStack {
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { daySymbol in
                        Text(String(daySymbol.prefix(1)))
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                    }
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(visibleDates, id: \.self) { date in
                    // `date` is a loop variable (ForEach). This does NOT overshadow the Calendar’s method.
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.caption)
                            .frame(width: 30, height: 30)
                            .background(color(for: dominantGender(on: date)))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(
                                        Color.primary,
                                        lineWidth: calendar.isDate(date, inSameDayAs: selectedDate) ? 2 : 0
                                    )
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedDate = date
                                }
                            }

                        if calendar.isDate(date, inSameDayAs: selectedDate) {
                            switch displayMode {
                            case .day:
                                let dayLogs = tracker.logs(for: date)
                                if !dayLogs.isEmpty {
                                    DayDetailView(date: date, genderLogs: dayLogs)
                                }
                            case .week:
                                let weekDates = calendar.datesForWeek(containing: date)
                                let weekLogs = weekDates.flatMap { tracker.logs(for: $0) }
                                WeekDetailView(weekDates: weekDates, genderLogs: weekLogs)
                            case .month:
                                let monthDates = calendar.datesForMonth(containing: date)
                                let monthLogs = monthDates.flatMap { tracker.logs(for: $0) }
                                MonthDetailView(monthDates: monthDates, genderLogs: monthLogs)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width < -threshold {
                            selectedDate = nextDate()
                        } else if value.translation.width > threshold {
                            selectedDate = previousDate()
                        }
                    }
            )
            .animation(.easeInOut(duration: 0.25), value: selectedDate)
        }
        .padding(.vertical)
    }

    private func headerTitle(for date: Date) -> String {
        // Again, ‘date’ is a parameter, standard usage.
        let formatter = DateFormatter()
        switch displayMode {
        case .day:
            formatter.dateFormat = "MMMM d, yyyy"
            return formatter.string(from: date)
        case .week:
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date),
                  let endDate = calendar.date(byAdding: .day, value: 6, to: weekInterval.start) else {
                return ""
            }
            formatter.dateFormat = "MMM d"
            return "\(formatter.string(from: weekInterval.start)) – \(formatter.string(from: endDate))"
        case .month:
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
    }

    private func previousDate() -> Date {
        switch displayMode {
        case .day:
            return calendar.date(byAdding: .day, value: -1, to: selectedDate)!
        case .week:
            return calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        }
    }

    private func nextDate() -> Date {
        switch displayMode {
        case .day:
            return calendar.date(byAdding: .day, value: 1, to: selectedDate)!
        case .week:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: selectedDate)!
        }
    }
}

extension Calendar {
    func generateDates(in interval: DateInterval) -> [Date] {
        var dates: [Date] = []
        var current = interval.start
        while current < interval.end {
            dates.append(current)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: current) else { break }
            current = nextDate
        }
        return dates
    }

    func datesForWeek(containing inputDate: Date) -> [Date] {
        guard let weekInterval = self.dateInterval(of: .weekOfYear, for: inputDate) else { return [] }
        return (0..<7).compactMap { offset in
            self.date(byAdding: .day, value: offset, to: weekInterval.start)
        }
    }

    func datesForMonth(containing inputDate: Date) -> [Date] {
        guard let monthInterval = self.dateInterval(of: .month, for: inputDate) else { return [] }
        var dates: [Date] = []
        var current = monthInterval.start
        while current <= monthInterval.end {
            dates.append(current)
            guard let nextDate = self.date(byAdding: .day, value: 1, to: current) else { break }
            current = nextDate
        }
        return dates
    }
}
