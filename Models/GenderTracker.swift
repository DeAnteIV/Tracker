import Foundation

class GenderTracker: ObservableObject {
    static let shared = GenderTracker()
    
    @Published private(set) var logs: [GenderIdentityLog] = []
    
    // Key used for storing logs persistently.
    private let logsKey = "genderLogsKey"

    // MARK: - Initialization
    
    private init() {
        loadLogs()
    }

    // MARK: - Public Methods

    /// Returns all logs that match a given date (same day).
    func logs(for date: Date) -> [GenderIdentityLog] {
        logs.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
        }
    }

    /// Returns the most frequent gender for a given date, if any logs exist that day.
    func mostFrequentGender(for date: Date) -> SharkGender? {
        let dayLogs = logs(for: date)
        let counts = Dictionary(grouping: dayLogs, by: { $0.gender }).mapValues { $0.count }
        return counts.max { $0.value < $1.value }?.key
    }

    /// Adds a new log entry and saves the updated logs to persistent storage.
    func addLog(_ log: GenderIdentityLog) {
        logs.append(log)
        saveLogs()
    }

    // MARK: - Persistence

    /// Encodes all logs and saves them (e.g. to UserDefaults).
    private func saveLogs() {
        do {
            let data = try JSONEncoder().encode(logs)
            UserDefaults.standard.set(data, forKey: logsKey)
        } catch {
            print("Error encoding logs: \(error)")
        }
    }

    /// Loads logs from persistent storage (e.g. from UserDefaults).
    private func loadLogs() {
        guard let data = UserDefaults.standard.data(forKey: logsKey) else { return }
        do {
            logs = try JSONDecoder().decode([GenderIdentityLog].self, from: data)
        } catch {
            print("Error decoding logs: \(error)")
        }
    }
}
