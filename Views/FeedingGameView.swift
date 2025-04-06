import SwiftUI

struct FeedingGameView: View {
    @Binding var happiness: Int
    @Binding var lastFedDate: Date?

    var body: some View {
        VStack(spacing: 15) {
            Text("Happiness: \(happiness)%")
                .font(.headline)

            ProgressView(value: Float(happiness), total: 100)
                .progressViewStyle(LinearProgressViewStyle(tint: .green))
                .frame(width: 200)

            Button(action: feedShark) {
                Label("Feed Shark", systemImage: "leaf.fill")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    func feedShark() {
        let now = Date()
        if lastFedDate == nil || now.timeIntervalSince(lastFedDate!) > 3600 {
            happiness = min(happiness + 10, 100)
            lastFedDate = now
        }
    }
}
