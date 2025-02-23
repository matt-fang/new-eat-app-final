import SwiftUI

// Reusable onboarding page component
struct OnboardingPage: View {
    let title: String
    let subtitle: String?
    let buttonText: String
    let action: () -> Void
    let extraContent: (() -> AnyView)?
    
    init(
        title: String,
        subtitle: String? = nil,
        buttonText: String = "Next",
        action: @escaping () -> Void,
        extraContent: (() -> AnyView)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
        self.action = action
        self.extraContent = extraContent
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(title)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding(.vertical)
                .padding(.horizontal, 60)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            if let extraContent = extraContent {
                extraContent()
            }
            
            Spacer()
            
            Button(action: action) {
                Text(buttonText)
                    .font(.button)
                    .foregroundColor(.white)
                    .frame(maxWidth: 180)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
            }
            .padding(.bottom, 40)
        }
    }
}

struct OnboardingView: View {
    @Bindable var viewModel: UserViewModel
    @State private var onboardingStep = 1
    @AppStorage("finishedOnboarding") private var finishedOnboarding: Bool = false
    
    @State private var habitIndex: Int?
    @State private var totalGoalCount: Int?
    @State private var whyIndex: Int?
    
    var body: some View {
        VStack {
            if onboardingStep == 1 {
                welcomePage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 2 {
                aboutPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 3 {
                habitSelectionPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 4 {
                habitInfoPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 5 {
                frequencyPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 6 {
                whyPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            } else if onboardingStep == 7 {
                endPage
                    .transition(.opacity.combined(with: .scale(scale: 0.99)))
            }
        }
        .animation(.easeOut(duration: 0.3), value: onboardingStep)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.ignoresSafeArea())
    }
    
    private var welcomePage: some View {
        OnboardingPage(
            title: "Hey there! \n \n Welcome to Happy Eat.",
            buttonText: "Hi!",
            action: { onboardingStep += 1 }
        )
    }
    
    private var aboutPage: some View {
        OnboardingPage(
            title: "This is a different kind of nutrition app, \n \n one that values sustainability over quick fixes, \n \n and how you feel over what you eat.",
            buttonText: "Cool!",
            action: { onboardingStep += 1 }
        )
    }
    
    private var habitSelectionPage: some View {
        OnboardingPage(
            title: "We're all about building habits here, since habits are what stick!",
            subtitle: "Choose one habit you want to form:",
            action: {
                if let habitIndex = habitIndex {
                    viewModel.setHabit(habit: habitIndex)
                    totalGoalCount = viewModel.user.currentHabit.totalGoalCount
                    onboardingStep += 1
                }
            },
            extraContent: {
                AnyView(
                    ScrollView {
                        ForEach(0..<Presets.habits.count, id: \.self) { index in
                            Button {
                                habitIndex = index
                            } label: {
                                CardView(content: Presets.habits[index].name, isSelected: habitIndex == index)
                            }
                        }
                    }
                    .padding()
                )
            }
        )
    }
    
    private var habitInfoPage: some View {
        OnboardingPage(
            title: "Science shows that simple habits can be formed in as little as 18 days. You got this!",
            buttonText: "Cool!",
            action: { onboardingStep += 1 },
            extraContent: {
                AnyView(
                    Link(destination: URL(string: "https://www.scientificamerican.com/article/how-long-does-it-really-take-to-form-a-habit/")!) {
                        Label("SOURCE", systemImage: "arrow.up.right")
                            .labelStyle(.titleAndIcon)
                            .foregroundStyle(.black)
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.whiteYellow)
                )
            }
        )
    }
    
    private var frequencyPage: some View {
        OnboardingPage(
            title: "How many times per day do you want to do this habit?",
            subtitle: "Choose a goal that challenges you in a gentle, manageable way.",
            action: {
                if let count = totalGoalCount {
                    viewModel.setTotalGoalCount(totalGoalCount: count)
                    viewModel.characterFactory(count: count)
                    onboardingStep += 1
                }
            },
            extraContent: {
                AnyView(
                    VStack {
                        Text("\(totalGoalCount ?? 3)")
                            .font(.megaTitle)
                            .padding()
                        Stepper("", value: Binding(
                            get: { totalGoalCount ?? 1 },
                            set: { totalGoalCount = $0 }
                        ), in: 1 ... 4)
                            .labelsHidden()
                            .scaleEffect(1.5)
                            .frame(width: 200)
                            .padding(.vertical)
                    }
                )
            }
        )
    }
    
    private var whyPage: some View {
        OnboardingPage(
            title: "Why do you want to form this habit?",
            subtitle: "We'll remind you about this to keep you motivated!",
            action: {
                viewModel.setHabitWhy(why: whyIndex ?? 0)
                onboardingStep += 1
            },
            extraContent: {
                AnyView(
                    ScrollView {
                        ForEach(0..<Presets.whys.count, id: \.self) { index in
                            Button {
                                whyIndex = index
                            } label: {
                                CardView(content: Presets.whys[index], isSelected: whyIndex == index)
                            }
                        }
                    }
                    .padding()
                )
            }
        )
    }
    
    private var endPage: some View {
        OnboardingPage(
            title: "You're about to build a habit that will help you feel good and live well! \n \n On the next screen, just tap on a food whenever you eat it in real life. It's that simple.",
            buttonText: "Let's go!",
            action: {
                finishedOnboarding = true
                print(finishedOnboarding)
                print("\(viewModel.user.currentHabit.name), \(viewModel.user.currentHabit.totalGoalCount), \(viewModel.user.currentHabit.why)")
            }
        )
    }
}
