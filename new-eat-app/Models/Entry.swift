//
//  Model.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftData
import Foundation

@Model
class Entry: Identifiable {
    var id: UUID = UUID()
    var type: String
    var title: String
    var body: String
    
    init(type: String, title: String, body: String) {
        self.type = type
        self.title = title
        self.body = body
    }
}
