import SwiftUI

struct AppMainView: View {
    @ObservedObject var genderManager = GenderSelectionManager.shared

    var body: some View {
        TabView {
            NavigationView {
                IdentitySelectionView()
            }
            .tabItem {
                Label("Identity", systemImage: "person.crop.circle.badge.checkmark")
            }

            NavigationView {
                MainSharkView(selectedGender: $genderManager.selectedGender)
            }
            .tabItem {
                Label("Shark", systemImage: "tortoise.fill")
            }

            NavigationView {
                JournalView()
            }
            .tabItem {
                Label("Journal", systemImage: "book.closed")
            }

            NavigationView {
                TrackingTabView()
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
        }
    }
}
