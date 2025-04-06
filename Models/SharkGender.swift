import SwiftUI

enum SharkGender: String, CaseIterable, Identifiable, Codable {
    case masc
    case fem
    case nonbinary

    var id: String { rawValue }

    var label: String {
        switch self {
        case .masc:      return "Masc"
        case .fem:       return "Femme"
        case .nonbinary: return "Nonbinary"
        }
    }

    var color: Color {
        switch self {
        case .masc:      return .blue
        case .fem:       return .pink
        case .nonbinary: return .green
        }
    }
}


