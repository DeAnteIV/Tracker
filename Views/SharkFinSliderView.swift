//
//  SharkFinSliderView.swift
//  SharkTracker
//
//  Created by IV on 4/6/25.
//

import SwiftUI

struct SharkFinSliderView: View { @Binding var finRating: Int
    var body: some View {
        VStack(alignment: .leading) {
            Text("Shark Fin Rating")
                .font(.headline)
            
            Slider(value: Binding(
                get: { Double(finRating) },
                set: { finRating = Int($0) }
            ), in: 1...10, step: 1)
            .accentColor(.blue)
            
            HStack {
                Text("Mim'")
                Spacer()
                Text("Kai")
                Spacer()
                Text("Mythical")
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}
