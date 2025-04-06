import Foundation

struct GenderIdentityLog: Identifiable, Hashable, Codable
{ var id = UUID()
    var timestamp: Date
    var gender: SharkGender }



