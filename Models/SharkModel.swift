import Foundation
import SwiftUI

enum SharkGender: String, CaseIterable, Identifiable, Codable, Hashable {
    case masc, fem, nonbinary

    var id: String { self.rawValue }
    var label: String {
        switch self {
        case .masc: return "Masc"
        case .fem: return "Fem"
        case .nonbinary: return "Nonbinary"
        }
    }
}


