//
//  Goal.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import Foundation
import SwiftData

@Model
class Habit: Identifiable {
    var id: UUID
    var name: String
    var totalGoalCount: Int
    var completedGoalCount: Int = 0
    var totalDays: Int
    var completedDays: Int
    var why: String
    @Relationship(deleteRule: .nullify) var pinnedEntry: Entry?
    
    init(
        id: UUID = UUID(),
        name: String,
        totalGoalCount: Int = 0,
        completedGoalCount: Int = 0,
        totalDays: Int = 18,
        completedDays: Int = 0,
        why: String = "",
        pinnedEntry: Entry? = nil
    ) {
        self.id = id
        self.name = name
        self.totalGoalCount = totalGoalCount
        self.completedGoalCount = completedGoalCount
        self.totalDays = totalDays
        self.completedDays = completedDays
        self.why = why
        self.pinnedEntry = pinnedEntry
    }
}
