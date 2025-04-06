import SwiftUI

struct JournalView: View {
    @State private var header = ""
    @State private var bodyText = ""
    @State private var moodRating = 3
    @State private var finRating = 5
    @State private var visibility: Visibility = .private
    @State private var savedEntries: [JournalEntry] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Mood Rating
                    HStack {
                        Text("Mood Rating")
                            .font(.headline)
                        Spacer()
                        HStack {
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: i <= moodRating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        moodRating = i
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Shark Fin Slider
                    SharkFinSliderView(finRating: $finRating)
                    
                    // Journal Header
                    TextField("Header", text: $header)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Journal Body
                    TextEditor(text: $bodyText)
                        .frame(height: 150)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        .padding(.horizontal)
                    
                    // Visibility Toggle
                    Picker("Visibility", selection: $visibility) {
                        ForEach(Visibility.allCases, id: \.self) { v in
                            Text(v.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Save Button
                    Button(action: saveEntry) {
                        Text("Save Entry")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Update Identity")
        }
    }
    
    func saveEntry() {
        let newEntry = JournalEntry(
            id: UUID(),
            date: Date(),
            header: header,
            body: bodyText,
            moodRating: moodRating,
            finRating: finRating,
            selectedSharkColor: "blue", // TODO: dynamically pass from selected identity
            visibility: visibility
        )
        savedEntries.append(newEntry)
        header = ""
        bodyText = ""
        moodRating = 3
        finRating = 5
        visibility = .private
        
        // Save to UserDefaults for now
        if let encoded = try? JSONEncoder().encode(savedEntries) {
            UserDefaults.standard.set(encoded, forKey: "journalEntries")
        }
    }
}

