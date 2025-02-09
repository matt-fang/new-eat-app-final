//
//  ContentView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftData
import SwiftUI

struct FoodView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: UserViewModel
    
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
        LazyVGrid(columns: [GridItem(), GridItem()]) {
            ForEach($viewModel.user.currentCharacters, id: \.self) { $character in
                CharacterView(lastDate: $lastDate, character: $character, viewModel: viewModel)
            }
        }.padding(.bottom, 10)
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
//        currentDay += 1 // MARK: what is this var even for lmao
        lastDate = Date().timeIntervalSince1970
    }
    
    var header: some View {
        // MARK: FIX THIS LMAO
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
            .tint(.orange)
//            .onTapGesture {
//                progress += 0.1
//            }
    }
}

