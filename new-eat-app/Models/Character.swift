//
//  Character.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//
import SwiftData
import Foundation

@Model
class Character: Identifiable {
    var id: UUID = UUID()
    var named: String
    var isShown: Bool
    
    init(named: String, isShown: Bool) {
        self.named = named
        self.isShown = isShown
    }
}

