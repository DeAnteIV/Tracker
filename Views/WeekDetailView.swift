import SwiftUI

struct WeekDetailView: View {
    let weekDates: [Date]
    let genderLogs: [GenderIdentityLog]

    var body: some View {
        VStack {
            Text("Week Detail")
                .font(.headline)
            // Example usage
            ForEach(genderLogs) { log in
                Text(log.gender.label)
            }
        }
    }
}

