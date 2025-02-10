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
    @State private var showingResetAlert: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: UserViewModel
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = true
    @State var onboardingTomorrow: Bool = false
   
    @AppStorage("currentDay") var currentDay: Int = 1
    @AppStorage("lastDate") var lastDate: Double = 0
    
    var pinnedEntry: Entry = .init(type: "reminder", title: "Pin a reminder in your journal!", body: "placeholder body")
    
    var body: some View {
        TabView {
            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    header
                        .layoutPriority(2)
                                
                    pinnedEntryNotification
                        .layoutPriority(2)
                        .overlay {
                            Text("Great \n job!")
                                .font(.megaTitle)
                                .foregroundStyle(.blue)
                                .multilineTextAlignment(.center)
                                .lineSpacing(-10)
                                .opacity(goodJobIsShown ? 1 : 0)
                                .scaleEffect(goodJobIsShown ? 1.5 : 1)
                                .fixedSize(horizontal: false, vertical: true)
                                .animation(goodJobIsShown ? .spring : nil, value: goodJobIsShown)
                                .confettiCannon(trigger: $trigger, num: 50, openingAngle: Angle(degrees: 0), closingAngle: Angle(degrees: 360), radius: 200)
                                .offset(y: 200)
                        }
                    Spacer()
                    manyCharacters
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
        GeometryReader { geometry in
            let isSmallDevice = geometry.size.width < 400 // iPhone SE height
            
            ZStack(alignment: .top) {
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
                }
//                .scaleEffect(isSmallDevice ? 0.9 : 1)
            }
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
            ZStack {
                Text("\(habit.completedDays)/\(habit.totalDays) days completed")
                    .font(Font.title3)
                    .fixedSize(horizontal: false, vertical: true)
                     
                HStack {
                    Spacer()
                    Button {
                        showingResetAlert = true
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    .alert("Reset Goal?", isPresented: $showingResetAlert) {
                        Button("Cancel", role: .cancel) {}
                        Button("Reset", role: .destructive) {
                            finishedOnboarding = false
                        }
                    } message: {
                        Text("This will remove all progress on your current goal. Are you sure you want to continue?")
                    }
                }
            }
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
            .frame(height: 130)
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
