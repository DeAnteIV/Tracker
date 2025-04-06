import SwiftUI

struct IdentitySelectionView: View {
    @ObservedObject var genderManager = GenderSelectionManager.shared

    var body: some View {
        VStack {
            Text("Select Your Identity")
                .font(.title2)
                .padding(.top)

            GenderSharkSelectorView()

            NavigationLink(destination: MainSharkView(selectedGender: $genderManager.selectedGender)) {
                Text("Confirm Identity")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding()
            }
        }
        .navigationTitle("Update Identity")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            NavigationLink(destination: JournalView()) {
                Text("Journal")
            }
        }
    }
}
