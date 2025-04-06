import Foundation

struct GenderIdentityLog: Identifiable, Codable {
    let id = UUID()
    let gender: SharkGender
    let timestamp: Date
}
