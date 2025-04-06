import Foundation

class GenderTracker: ObservableObject {
    static let shared = GenderTracker()

    @Published var logs: [GenderIdentityLog] = []

    private init() {
        loadLogs()
    }

    func logGenderSelection(_ gender: SharkGender) {
        let newLog = GenderIdentityLog(gender: gender, timestamp: Date())
        logs.append(newLog)
        saveLogs()
    }

    func logs(for date: Date) -> [GenderIdentityLog] {
        let calendar = Calendar.current
        return logs.filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
    }

    func mostFrequentGender(for date: Date) -> SharkGender? {
        let dayLogs = logs(for: date)
        let counts = Dictionary(grouping: dayLogs, by: { $0.gender })
        return counts.max { $0.value.count < $1.value.count }?.key
    }

    private func saveLogs() {
        if let data = try? JSONEncoder().encode(logs) {
            UserDefaults.standard.set(data, forKey: "genderLogs")
        }
    }

    private func loadLogs() {
        if let data = UserDefaults.standard.data(forKey: "genderLogs"),
           let savedLogs = try? JSONDecoder().decode([GenderIdentityLog].self, from: data) {
            logs = savedLogs
        }
    }
}
