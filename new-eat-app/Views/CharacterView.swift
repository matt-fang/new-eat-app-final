//
//  CharacterView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/6/25.
//

import SwiftUI

struct CharacterView: View {
    @Binding var lastDate: Double
    @Binding var character: Character

    @Bindable var viewModel: UserViewModel
    
    var body: some View {
        Image(character.named)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(-5)
            .opacity(character.isShown ? 1 : 0)
            .scaleEffect(character.isShown ? 1 : 0.5) // Shrinks while fading
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: character.isShown)
            .onTapGesture {
                if character.isShown {
                    viewModel.incrementGoalCount()
                    viewModel.incrementDayCount() // checks if day should be incremented + increments
                    viewModel.hideCharacter(character)
                    print("FROM THE VIEWMODEL: \(viewModel.user.currentCharacters.map { $0.isShown })")
                    print ("FROM THE VIEW: \(character) got reset to \(character.isShown)!")
                    lastDate = Date().timeIntervalSince1970
                    }
                }
            }
    }
