//
//  UserViewModel.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import Foundation
import Observation
import SwiftUI

@MainActor
@Observable class UserViewModel {
    // MARK: ideally currentHabit is an optional — but that makes things complicated in FoodView so figure that out
    private let service = SwiftDataService.shared
    
    var user: User
    
    init() {
            self.user = service.fetchUser()
        }
    
    func setHabit(habit: Int) {
        service.setHabit(value: habit, property: "currentHabit")
        user = service.fetchUser()
    }
    
    func setTotalGoalCount(totalGoalCount: Int) {
        service.setHabit(value: totalGoalCount, property: "totalGoalCount")
        user = service.fetchUser()
    }
    
    func setHabitWhy(why: Int) {
        service.setHabit(value: why, property: "why")
        user = service.fetchUser()
    }
    
    func incrementGoalCount() {
        service.incrementGoalCount(by: 1)
        user = service.fetchUser()
    }
    
    func resetGoalCount() {
        service.incrementGoalCount(by: -user.currentHabit.completedGoalCount)
        user = service.fetchUser()
    }
    
    func incrementDayCount() {
        if user.currentHabit.totalGoalCount == user.currentHabit.completedGoalCount {
            service.incrementDayCount()
            user = service.fetchUser()
            print("**FROM THE ACTUAL VIEWMODEL: \(user.currentHabit.completedDays)")
        }
        print("**INCREMEENTDAYCOUNTCALLED??")
    }
    
    func hideCharacter(_ character: Character) {
        if let index = user.currentCharacters.firstIndex(where: { $0.id == character.id }) {
            service.hideCharacter(index: index)
            user = service.fetchUser()
            print("FROM THE ACTUAL VIEWMODEL: \(user.currentCharacters.map { $0.isShown })")
        }
    }
    
    func recordReflectionRating(positive: Bool) {
        print("\(positive)")
    }
    

    
//    func checkToIncrementGoalCount() {
//        if user.currentHabit.completedGoalCount == user.currentHabit.totalGoalCount {
//            lastDate = Date().timeIntervalSince1970
//            incrementDayCount()
//        }
        
    func characterFactory(count: Int) {
        var characterList: [Character] = []
        for _ in 0..<count {
            characterList.append(Character(named: "orangeguy", isShown: true))
        }
        service.populateCharacters(characterList)
        user = service.fetchUser()
    }
    
    func resetCharacters() {
        service.resetCharacters()
        user = service.fetchUser()
    }
}

