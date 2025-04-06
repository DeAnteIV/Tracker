import SwiftUI


// CalendarView now acts as a container for CalendarGridView
struct CalendarView: View {
    @State private var selectedDate: Date = Date()
    @State private var displayMode: CalendarMode = .month

    var body: some View {
        CalendarGridView(selectedDate: $selectedDate, displayMode: $displayMode)
    }
}

public struct CalendarGridView: View {
    // Two bindings: one for the selected date, one for the display mode
    @Binding var selectedDate: Date
    @Binding var displayMode: CalendarMode

    @ObservedObject private var tracker = GenderTracker.shared
    @GestureState private var dragOffset: CGFloat = 0
    private let calendar = Calendar.current

    // Compute which dates to show based on displayMode
    private var visibleDates: [Date] {
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

    // For any date, find the dominant gender
    private func dominantGender(on date: Date) -> SharkGender? {
        let dayLogs = tracker.logs(for: date)
        let counts = Dictionary(grouping: dayLogs, by: { $0.gender }).mapValues { $0.count }
        return counts.max { $0.value < $1.value }?.key
    }

    // Map gender → color
    private func color(for gender: SharkGender?) -> Color {
        switch gender {
        case .masc:        return Color.blue.opacity(0.6)
        case .fem:         return Color.pink.opacity(0.6)
        case .nonbinary:   return Color.green.opacity(0.6)
        default:           return Color.gray.opacity(0.1)
        }
    }

    public var body: some View {
        VStack(spacing: 8) {
            // Header
            Text(headerTitle(for: selectedDate))
                .font(.title2)
                .bold()

            // Weekday initials (if not single‑day view)
            if displayMode != .day {
                HStack {
                    ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                        Text(day.prefix(1))
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                    }
                }
            }

            // Grid of dates
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 10) {
                ForEach(visibleDates, id: \.self) { date in
                    VStack(spacing: 4) {
                        Text("\(calendar.component(.day, from: date))")
                            .font(.caption)
                            .frame(width: 30, height: 30)
                            .background(color(for: dominantGender(on: date)))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.primary,
                                            lineWidth: calendar.isDate(date, inSameDayAs: selectedDate) ? 2 : 0)
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedDate = date
                                }
                            }

                        // Inline detail view for the tapped date
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
                    .updating($dragOffset) { value, state, _ in state = value.translation.width }
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

    // MARK: - Helpers

    private func headerTitle(for date: Date) -> String {
        let df = DateFormatter()
        switch displayMode {
        case .day:
            df.dateFormat = "MMMM d, yyyy"
            return df.string(from: date)
        case .week:
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: date),
                  let end = calendar.date(byAdding: .day, value: 6, to: weekInterval.start) else {
                return ""
            }
            df.dateFormat = "MMM d"
            return "\(df.string(from: weekInterval.start)) – \(df.string(from: end))"
        case .month:
            df.dateFormat = "MMMM yyyy"
            return df.string(from: date)
        }
    }

    private func previousDate() -> Date {
        switch displayMode {
        case .day:   return calendar.date(byAdding: .day, value: -1, to: selectedDate)!
        case .week:  return calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate)!
        case .month: return calendar.date(byAdding: .month, value: -1, to: selectedDate)!
        }
    }

    private func nextDate() -> Date {
        switch displayMode {
        case .day:   return calendar.date(byAdding: .day, value: 1, to: selectedDate)!
        case .week:  return calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate)!
        case .month: return calendar.date(byAdding: .month, value: 1, to: selectedDate)!
        }
    }
}

// MARK: - Calendar Extensions

public extension Calendar {
    func generateDates(in interval: DateInterval) -> [Date] {
        var dates: [Date] = []
        var current = interval.start
        while current < interval.end {
            dates.append(current)
            current = date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }

    func datesForWeek(containing date: Date) -> [Date] {
        guard let weekInterval = dateInterval(of: .weekOfYear, for: date) else { return [] }
        return stride(from: 0, to: 7, by: 1).compactMap {
            date(byAdding: .day, value: $0, to: weekInterval.start)
        }
    }

    func datesForMonth(containing date: Date) -> [Date] {
        guard let monthInterval = dateInterval(of: .month, for: date) else { return [] }
        var dates: [Date] = []
        var current = monthInterval.start
        while current <= monthInterval.end {
            dates.append(current)
            current = date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }
}
