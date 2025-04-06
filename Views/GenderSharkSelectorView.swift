import SwiftUI

struct GenderSharkSelectorView: View {
    @ObservedObject var genderManager = GenderSelectionManager.shared

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(SharkGender.allCases) { gender in
                    VStack {
                        Shark3DView(gender: gender)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(radius: 10)
                            .onTapGesture {
                                genderManager.selectedGender = gender
                                GenderTracker.shared.logGenderSelection(gender)
                            }

                        Text(gender.label)
                            .font(.headline)
                    }
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.1))
        .cornerRadius(20)
    }
}
