import Foundation

struct GenderIdentityLog: Identifiable, Codable {
    let id: UUID
    let gender: SharkGender
    let timestamp: Date

    // Custom initializer: if no id is passed, generate a new one
    init(id: UUID = UUID(), gender: SharkGender, timestamp: Date) {
        self.id = id
        self.gender = gender
        self.timestamp = timestamp
    }
}
