//
//  OnboardingView.swift
//  new-eat-app
//
//  Created by Matthew Fang on 2/4/25.
//

import SwiftUI

struct OnboardingView: View {
    @Bindable var viewModel: UserViewModel
    @State private var onboardingStep = 1
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = false
    
    // MARK: do these state variables need to exist at all? they cause some optional problems later down
    @State private var habitIndex: Int?
    @State private var totalGoalCount: Int?
    @State private var whyIndex: Int?
    
    var body: some View {
        VStack {
            if onboardingStep == 1 {
                welcome
            } else if onboardingStep == 2 {
                about
            } else if onboardingStep == 3 {
                pickHabit
            } else if onboardingStep == 4 {
                aboutHabit
            } else if onboardingStep == 5 {
                pickFrequency
            } else if onboardingStep == 6 {
                pickWhy
            } else if onboardingStep == 7 {
                end
            }
//            else if onboardingStep == 7 {
//                tutorial
//            }
        }
    }
    
    func nextButton(text: String = "Next") -> some View {
        return Button {
            onboardingStep += 1
        } label: {
            Text(text)
                .font(.button)
                .foregroundColor(.white)
                .frame(maxWidth: 180)
                .padding(.vertical, 16)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 32))
        }
    }
    
    var welcome: some View {
        VStack {
            Spacer()
            Text("Hey there! \n \n Welcome to Happy Eat.")
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)
            Spacer()
            nextButton(text: "Hi!")
                .padding(.bottom, 40)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
            .onAppear {
                for family in UIFont.familyNames.sorted() {
                    print("Family: \(family)")
                    for font in UIFont.fontNames(forFamilyName: family).sorted() {
                        print("   Font: \(font)")
                    }
                }
            }
    }
    
    var about: some View {
        VStack {
            Spacer()
            Text("This is a different kind of nutrition app, \n \n one that values sustainability over quick fixes, \n \n and how you feel over what you eat.")
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)

            Spacer()
            nextButton(text: "Cool!")
                .padding(.bottom, 40)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
    
    var aboutHabit: some View {
        VStack {
            Spacer()
            Text("Science shows that simple habits can be formed in as little as 18 days. You got this!")
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)
            Button {
                print ("source!")
            } label: {
                Link(destination: URL(string:"https://www.scientificamerican.com/article/how-long-does-it-really-take-to-form-a-habit/")!) {
                    Label("SOURCE", systemImage: "arrow.up.right")
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(.black)
                        .font(.caption)
                }

            }.buttonStyle(.borderedProminent)
                .tint(.whiteYellow)
            
           

            Spacer()
            nextButton(text: "Cool!")
                .padding(.bottom, 40)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
    
    var end: some View {
        VStack {
            Spacer()
            Text("You’re about to build a habit that will help you feel good and live well! \n \n On the next screen, just tap on a food whenever you eat it in real life. It’s that simple.")
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)

            Spacer()
            Button {
                finishedOnboarding = true
                print(finishedOnboarding)
                print ("\(viewModel.user.currentHabit.name), \(viewModel.user.currentHabit.totalGoalCount), \(viewModel.user.currentHabit.why)")
            } label: {
                Text("Let's go!")
                    .font(.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: 180)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
                .padding(.bottom, 40)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
    
    var tutorial: some View {
        VStack {
            Text("Try it:")
                .font(.body)
                .multilineTextAlignment(.center)
            Text("Tap on a food if you eat it in real life!")
                .font(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)

            Spacer()
            Button {
                finishedOnboarding = true
                print(finishedOnboarding)
                print ("\(viewModel.user.currentHabit.name), \(viewModel.user.currentHabit.totalGoalCount), \(viewModel.user.currentHabit.why)")
            } label: {
                Text("Ok!")
                    .font(.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: 180)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
                .padding(.bottom, 40)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.whiteYellow
                    .ignoresSafeArea()
            }
    }
    
    var pickHabit: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(alignment: .center, spacing: 16) {
                Text("We're all about building habits here, since habits are what stick!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .padding(.horizontal, 40)
                
                Text("Choose one habit you want to form:")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            VStack(alignment: .center, spacing: 12) {
                ScrollView {
                    cardList
                }
            }.padding()
            Spacer()
            
            nextButton()
                .padding(.bottom, 40)
                .disabled(habitIndex == nil)
            
            
        }.onDisappear {
            // MARK: prevent the screen from disappearing if habit doesn't exist!! don't just default to 3 lmao
            // MARK: IS FORCE UNWRAPPPING OK HERE?
            viewModel.setHabit(habit: habitIndex!)
            totalGoalCount = viewModel.user.currentHabit.totalGoalCount
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
    var cardList: some View {
        ForEach(0..<Presets.habits.count, id: \.self) { index in
            Button {
                habitIndex = index
            } label: {
                CardView(content: Presets.habits[index].name, isSelected: habitIndex == index)
            }
        }
    }
    
    var pickFrequency: some View {
        VStack {
            Text("How many times per day do you want to do this habit?")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 40)
            
            Text("Choose a goal that challenges you in a gentle, manageable way.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
            
            // MARK: what is happening here lol — understand
            VStack {
                Text("\(totalGoalCount ?? 3)")
                    .font(.megaTitle)
                    .padding()
                Stepper("\(totalGoalCount ?? 3)", value: Binding(
                    get: { totalGoalCount ?? 1 },
                    set: { totalGoalCount = $0 }
                ), in: 1...4)
                .labelsHidden()
                .scaleEffect(1.5)
                .frame(width: 200)
                .padding(.vertical)
                .padding(.horizontal, 60)
            }
           
            
            Spacer()
            
            nextButton()
                .padding(.bottom, 40)
        }.padding(.top, 30)
        .onDisappear {
            viewModel.setTotalGoalCount(totalGoalCount: totalGoalCount!)
            viewModel.characterFactory(count: totalGoalCount!)
            print(viewModel.user.currentCharacters)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
    
    var whyCardList: some View {
        ForEach(0..<Presets.whys.count, id: \.self) { index in
            Button {
                whyIndex = index
            } label: {
                CardView(content: Presets.whys[index], isSelected: whyIndex == index)
            }
        }
    }
    
    var pickWhy: some View {
        VStack(alignment: .center, spacing: 24) {
            VStack(alignment: .center, spacing: 16) {
                Text("Why do you want to form this habit?")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .padding(.horizontal, 40)
                
                Text("We'll remind you about this to keep you motivated!")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            VStack(alignment: .center, spacing: 12) {
                ScrollView {
                    whyCardList
                }
            }.padding()
            Spacer()
            
            nextButton()
                .padding(.bottom, 40)
                .disabled(whyIndex == nil)
            
        }.onDisappear {
            // MARK: is this optional handling ideal?
            viewModel.setHabitWhy(why: whyIndex ?? 0)
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                Color.yellow
                    .ignoresSafeArea()
            }
    }
}
