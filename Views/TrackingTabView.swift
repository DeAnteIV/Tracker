import SwiftUI

struct TrackingTabView: View {
    @ObservedObject private var tracker = GenderTracker.shared

    @State private var selectedDate: Date = Date()
    @State private var displayMode: CalendarMode = .month

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // MARK: — Mode Picker
                Picker("View Mode", selection: $displayMode) {
                    ForEach(CalendarMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: — Optional Compact DatePicker (jump to any date)
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .padding(.horizontal)

                // MARK: — Calendar Grid
                CalendarGridView(
                    selectedDate: $selectedDate,
                    displayMode: $displayMode
                )
                .frame(height: displayMode == .day ? 120 : 360)
                .padding(.horizontal)

                // MARK: — Summary of Most Frequent Gender
                if let gender = tracker.mostFrequentGender(for: selectedDate) {
                    VStack(spacing: 4) {
                        Text("Most selected gender on \(formattedDate(selectedDate)):")
                            .font(.headline)
                        Text(gender.label)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(Color(gender.color))
                    }
                    .padding(.horizontal)
                } else {
                    Text("No gender selected on this date.")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }

                // MARK: — Bar Graph for that Date
                GenderBarGraphView(date: selectedDate)
                    .frame(height: 200)
                    .padding(.horizontal)

                Spacer()
            }
            .navigationTitle("Tracking")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}
