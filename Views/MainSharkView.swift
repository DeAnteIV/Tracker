import SwiftUI

struct MainSharkView: View {
    @Binding var selectedGender: SharkGender
    @State private var sharkHappiness: Int = 50 // Ranges from 0 to 100
    @State private var lastFedDate: Date? = nil
    @State private var showAffirmation: Bool = true

    var body: some View {
        ZStack {
            Color.blue.opacity(0.3).ignoresSafeArea() // Deep ocean background

            VStack(spacing: 20) {
                Shark3DView(gender: selectedGender)
                    .frame(width: 250, height: 250)
                    .shadow(radius: 15)

                if showAffirmation {
                    Text(affirmationForGender(selectedGender))
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .transition(.slide)
                        .animation(.easeInOut, value: showAffirmation)
                }

                FeedingGameView(happiness: $sharkHappiness, lastFedDate: $lastFedDate)

                Spacer()
            }
            .padding()
        }
    }

    func affirmationForGender(_ gender: SharkGender) -> String {
        switch gender {
        case .masc:
            return "Your strength and calm presence make waves in this world."
        case .fem:
            return "Your grace and authenticity shine brighter than coral."
        case .nonbinary:
            return "You flow freely like the ocean—undefinable and powerful."
        }
    }
}
