import SwiftUI

struct DayDetailView: View {
    let date: Date
    let genderLogs: [GenderIdentityLog]

    var body: some View {
        VStack {
            Text("Day Detail for \(dateString)")
                .font(.headline)
            ForEach(genderLogs) { log in
                Text(log.gender.label)
            }
        }
    }

    private var dateString: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df.string(from: date)
    }
}
