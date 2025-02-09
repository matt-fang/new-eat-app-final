//
//  Extensions.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/6/25.
//

import SwiftUI

extension Color {
    static let blue = Color(red: 0.06, green: 0.44, blue: 0.99)
    static let lightYellow = Color(red: 1, green: 0.86, blue: 0.27)
    static let whiteYellow = Color(red: 1, green: 0.93, blue: 0.64)
    static let yellow = Color(red: 1, green: 0.81, blue: 0.01)
    static let orange = Color(red: 1, green: 0.45, blue: 0)
}

extension Font {
    // MARK: change back title font after proper concatenation
    static let title = Font.custom("Figtree", size: 30).weight(.semibold)
    static let title2 = Font.custom("Figtree", size: 24).weight(.semibold)
    static let title3 = Font.custom("Figtree", size: 16).weight(.semibold)
    static let subtitle = Font.custom("Figtree", size: 24).weight(.medium)
    static let caption = Font.custom("SF Pro", size: 10).weight(.semibold)
    static let body = Font.custom("SF Pro", size: 18).weight(.medium)
    static let button = Font.custom("SF Pro", size: 18).weight(.semibold)
}

