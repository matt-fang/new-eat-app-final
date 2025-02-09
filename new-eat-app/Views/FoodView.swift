//
//  ContentView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftData
import SwiftUI

struct FoodView: View {
    @State private var trigger: Int = 0
    @State private var goodJobIsShown: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: UserViewModel
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = true
    @State var onboardingTomorrow: Bool = false
    
    // MARK: UNDERSTAND LOL
    @AppStorage("currentDay") var currentDay: Int = 1
    @AppStorage("lastDate") var lastDate: Double = 0
    
    var pinnedEntry: Entry = Entry(type: "reminder", title: "Pin a reminder in your journal!", body: "placeholder body")
    
    var body: some View {
//        @State var viewModel.user.currentHabit = viewModel.user.currentHabit
        TabView {
            VStack {
                header
                pinnedEntryNotification
                Spacer()
                manyCharacters
                Button {
                    lastDate = Date.now.addingTimeInterval(87000).timeIntervalSince1970
                    print("\(lastDate)")
                } label: {
                    Text("jump to tomorrow!")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.yellow
                        .ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Food")
                }
                .tag(0)
            VStack {
                Text("Your Journal")
                    .font(.title)
                    .padding()
                Text("Coming soon!")
                    .font(.body)
                    .padding()
            }
            .tabItem {
                Image(systemName: "book.closed.fill")
                Text("Journal")
            }
            .tag(1)
        }.tint(.black)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    checkForNewDay()
                }
            }
    }
    
    var manyCharacters: some View {
        ZStack (alignment: .top) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach($viewModel.user.currentCharacters, id: \.self) { $character in
                    CharacterView(lastDate: $lastDate, character: $character, viewModel: viewModel)
                        .onChange(of: character.isShown) { _, newValue in
                            if !newValue && viewModel.user.currentCharacters.allSatisfy({ !$0.isShown }) {
                                trigger += 1
                                goodJobIsShown.toggle()
                            }
                            if viewModel.user.currentHabit.totalDays == viewModel.user.currentHabit.completedDays {
                                onboardingTomorrow = true
                            }
                        }
                        
                }
            }.padding(.bottom, 10)
            Text("Great \n job!")
                .font(.megaTitle)
                .foregroundStyle(.blue)
                .multilineTextAlignment(.center)
                .lineSpacing(-10) // MARK: doesn't work lol
                .opacity(goodJobIsShown ? 1 : 0)
                .scaleEffect(goodJobIsShown ? 1.5 : 1) // Scale up the text
                .padding()
                .animation(goodJobIsShown ? .spring : nil, value: goodJobIsShown) // Animate opacity and scale
                .confettiCannon(trigger: $trigger, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)

        }
    }
    
    private func checkForNewDay() {
        print("checked!")
            let savedDate = Date(timeIntervalSince1970: lastDate)
            if !Calendar.current.isDateInToday(savedDate) {
                resetForNewDay()
            }
        }

    private func resetForNewDay() {
        print("reset!")
        viewModel.resetGoalCount()
        viewModel.resetCharacters()
        goodJobIsShown = false
        if onboardingTomorrow {
            finishedOnboarding = false
        }
//        currentDay += 1 // MARK: what is this var even for lmao
        lastDate = Date().timeIntervalSince1970
    }
    
    var header: some View {
        let habit = viewModel.user.currentHabit
        return VStack(spacing: 14) {
                Text("\(habit.completedDays)/\(habit.totalDays) completed")
                    .font(Font.title3)
                VStack(spacing: 8) {
                    Text("\(habit.name), \(habit.totalGoalCount)x")
                        .font(.title)
                        .bold()
                    progressBar
                }
            }.padding()
    }
    
    // MARK: consolidate this into card view eventually
    var pinnedEntryNotification: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.lightYellow)
            HStack(spacing: 5) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("MY REASON")
                        .font(.caption)
                    Text(viewModel.user.currentHabit.why)
                        .font(Font.body)
                }
                Spacer()
                Image(systemName: "quote.opening")
                    .font(.largeTitle)
                    .foregroundStyle(.blue)
            }.padding(.horizontal, 20)
                .padding(.vertical, 10)

        }.padding()
            .frame(maxHeight: 130)
    }
    
    var progressBar: some View {
        // MARK: again not ideal lmao
//        @State var habit = viewModel.user.currentHabit
        
        // MARK: WHAT IS EVEN HAPPENING HERE LMAO — FIX THIS CRAZY BINDING STUFF
        return ProgressView(value: Double(viewModel.user.currentHabit.completedGoalCount), total: Double(viewModel.user.currentHabit.totalGoalCount))
        
//        return ProgressView(value: 0.5, total: 1.0)
            .frame(maxWidth: 60)
            .scaleEffect(2)
            .tint(goodJobIsShown ? .blue : .orange)
            .animation(goodJobIsShown ? .spring : nil, value: goodJobIsShown)
//            .onTapGesture {
//                progress += 0.1
//            }
    }
}

