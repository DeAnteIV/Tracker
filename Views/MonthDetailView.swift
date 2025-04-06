import SwiftUI

struct MonthDetailView: View {
    let monthDates: [Date]
    let genderLogs: [GenderIdentityLog]

    var body: some View {
        VStack {
            Text("Month Detail")
                .font(.headline)
            ForEach(genderLogs) { log in
                Text(log.gender.label)
            }
        }
    }
}
