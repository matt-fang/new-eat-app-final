//
//  User.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import Foundation
import SwiftData

@Model
class User {
    var currentHabit: Habit
    var currentCharacters: [Character]
    var journalEntries: [Entry]
    
    init(currentHabit: Habit, currentCharacters: [Character]) {
        self.currentHabit = currentHabit
        self.currentCharacters = currentCharacters
        self.journalEntries = []
    }
    
}
