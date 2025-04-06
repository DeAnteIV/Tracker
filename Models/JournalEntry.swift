//
//  JournalEntry.swift
//  SharkTracker
//
//  Created by IV on 4/6/25.
//

import Foundation

enum Visibility: String, Codable, CaseIterable {
    case `public`
    case `private`
}

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var header: String
    var body: String
    var moodRating: Int // 1–5 stars
    var finRating: Int // 1–10
    var selectedSharkColor: String // "blue", "pink", "green"
    var visibility: Visibility
}

