import Foundation
import SwiftUI

class GenderSelectionManager: ObservableObject {
    static let shared = GenderSelectionManager()

    @Published var selectedGender: SharkGender {
        didSet {
            logGenderChange(gender: selectedGender)
        }
    }

    @Published var genderLog: [GenderIdentityLog] = []

    private init() {
        self.selectedGender = .masc  // Default to masc
    }

    private func logGenderChange(gender: SharkGender) {
        let log = GenderIdentityLog(gender: gender, date: Date()) // <-- 'date' instead of 'timestamp'
        genderLog.append(log)
        print("Gender updated: \(gender.label) at \(log.date)")
    }

}
