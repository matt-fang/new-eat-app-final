//
//  new_eat_appApp.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftData
import SwiftUI

@main
struct new_eat_appApp: App {
    @State var viewModel = UserViewModel()
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if finishedOnboarding == false {
                    OnboardingView(viewModel: viewModel)
                } else {
                    FoodView(viewModel: viewModel)
                }
            }

        }
    }
}
