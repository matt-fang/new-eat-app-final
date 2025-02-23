//
//  ContentView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftUI

struct StandardButton: View {
    let text: String
    let action: () -> Void
    let color: Color
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.button)
                .foregroundColor(.white)
                .frame(maxWidth: 180)
                .padding(.vertical, 16)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
}

struct FoodView: View {
    @State private var trigger: Int = 0
    @State private var showingResetAlert: Bool = false
    @Environment(\.scenePhase) private var scenePhase
    @Bindable var viewModel: UserViewModel
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = true
    @State var onboardingTomorrow: Bool = false
    
    @AppStorage("currentDay") var currentDay: Int = 1
    @AppStorage("lastDate") var lastDate: Double = 0
    
    // New animation states
    @State private var completionState: CompletionState = .normal
    @State private var showingDaysCompleted = false
    @State private var showingQuote = false
    @State private var animatingNumber = false
    @State private var newNumber = false
    @State private var showingReflection = false
    @State private var isQuoteVisible = true
    
    enum CompletionState {
        case normal
        case celebration
        case completed
    }
    
    var body: some View {
        TabView {
            mainContent
                .tabItem {
                    Image(systemName: "fork.knife")
                    Text("Food")
                }
                .tag(0)
            
            journalTab
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("Journal")
                }
                .tag(1)
        }
        .tint(.black)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                checkForNewDay()
            }
        }
    }
    
    var mainContent: some View {
        ZStack {
            backgroundColor
            
            VStack(spacing: 0) {
                if completionState == .normal {
                    normalContent
                } else if completionState == .celebration {
                    celebrationContent
                } else {
                    completedContent
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: completionState)
    }
    
    var journalTab: some View {
        VStack {
            Text("Your Journal")
                .font(.title2)
            Text("Coming soon!")
                .font(.body)
        }
    }
    
    var backgroundColor: some View {
        Group {
            switch completionState {
            case .normal:
                Color.yellow
            case .celebration:
                Color.orange
            case .completed:
                Color.yellow
            }
        }
        .ignoresSafeArea()
    }
    
    var normalContent: some View {
        VStack(spacing: 4) {
            header
                .layoutPriority(2)
            
            pinnedEntryNotification
                .layoutPriority(2)
            
            Spacer()
            
            manyCharacters
                .padding(.bottom)
        }
    }
    
    var celebrationContent: some View {
        VStack {
            header
            Spacer()
            
            if !showingDaysCompleted {
                Text("Great\njob!")
                    .font(.megaTitle)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            } else {
                VStack(spacing: 20) {
                    if showingQuote {
                        Text("\"Every great thing\nwas formed one step\nat a time.\"")
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                    } else {
                        Text("\(viewModel.user.currentHabit.completedDays)")
                            .font(.hero)
                            .tracking(-10)
                            .foregroundColor(newNumber ? .yellow : .white)
                            .contentTransition(.numericText(value: Double(viewModel.user.currentHabit.completedDays)))
                            .transition(.move(edge: .trailing).combined(with: .opacity))
                            .onChange(of: viewModel.user.currentHabit.completedDays) { _ in
                                withAnimation(.easeInOut(duration: 0.5)) { // Smooth transition
                                    newNumber = true
                                }
                            }
                        
                        Text("days completed")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
            }
            
            Spacer()
            
            StandardButton(
                text: "Done",
                action: { withAnimation { completionState = .completed } },
                color: .lightOrange
            )
            .padding(.bottom, 40)
        }
        .onAppear {
            // Animation sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showingDaysCompleted = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        animatingNumber = true
                    }
                    
                    // Increment day count a few seconds after the number appears
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            viewModel.incrementDayCount() // Now happens after number animation
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showingQuote = true
                            }
                            
                            // Start quote/number cycling
                            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                                withAnimation {
                                    isQuoteVisible.toggle()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    var completedContent: some View {
        VStack(spacing: 4) {
            header
                .layoutPriority(2)
            
            reflectionPrompt
                .layoutPriority(2)
            
            Text("All done\ntoday!")
                .font(.megaTitle)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            manyCharacters
                .padding(.bottom)
        }
    }
    
    var reflectionPrompt: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundStyle(Color.lightOrange)
            
            VStack(spacing: 10) {
                Text("REFLECT")
                    .font(.caption)
                    .foregroundColor(.white)
                
                Text("How do you feel after\nfinishing your habit?")
                    .font(.body)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: { viewModel.recordReflectionRating(positive: true) }) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .background(Circle().fill(Color.lighterOrange).frame(width: 60, height: 60))
                    
                    Button(action: { viewModel.recordReflectionRating(positive: false) }) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .background(Circle().fill(Color.lighterOrange).frame(width: 60, height: 60))
                }
            }
            .padding()
        }
        .padding()
        .frame(height: 200)
    }
    
    // Your existing views...
    var manyCharacters: some View {
        ZStack(alignment: .top) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach($viewModel.user.currentCharacters, id: \.self) { $character in
                    CharacterView(lastDate: $lastDate, character: $character, viewModel: viewModel)
                        .confettiCannon(trigger: $trigger)
                        .onChange(of: character.isShown) { _, newValue in
                            if !newValue && viewModel.user.currentCharacters.allSatisfy({ !$0.isShown }) {
                                trigger += 1
                                withAnimation {
                                    completionState = .celebration
                                }
                            }
                            if viewModel.user.currentHabit.totalDays == viewModel.user.currentHabit.completedDays {
                                onboardingTomorrow = true
                            }
                        }
                }
            }
        }
    }
    
    // Rest of your existing code...
    private func checkForNewDay() {
        let savedDate = Date(timeIntervalSince1970: lastDate)
        if !Calendar.current.isDateInToday(savedDate) {
            resetForNewDay()
        }
    }

    private func resetForNewDay() {
        viewModel.resetGoalCount()
        viewModel.resetCharacters()
        completionState = .normal
        showingDaysCompleted = false
        showingQuote = false
        animatingNumber = false
        showingReflection = false
        if onboardingTomorrow {
            finishedOnboarding = false
        }
        lastDate = Date().timeIntervalSince1970
    }
    
    // ... rest of your existing view code
    
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
            .tint(.orange)
//            .onTapGesture {
//                progress += 0.1
//            }
    }
}
