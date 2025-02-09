import SwiftData

@MainActor
class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    static let shared = SwiftDataService()
    
    private init() {
        self.modelContainer = try! ModelContainer(for: User.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        self.modelContext = modelContainer.mainContext
    }
    
    // Fetch user (always ensure we return a valid user)
    func fetchUser() -> User {
        do {
            if let user = try modelContext.fetch(FetchDescriptor<User>()).first {
                return user
            } else {
                let user = User(
                    currentHabit: Presets.habits[0],
                    currentCharacters: [
                        Character(named: "orangeguy", isShown: true),
                        Character(named: "orangeguy", isShown: true),
                        Character(named: "orangeguy", isShown: true)
                    ]
                )
                modelContext.insert(user)
                try modelContext.save()
                return user
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // Save changes
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving user: \(error.localizedDescription)")
        }
    }
    
    // Update user properties
    func setHabit(value: Int, property: String) {
        let user = fetchUser()
        switch property {
        case "currentHabit":
            let newHabit = Presets.habits[value]
            modelContext.insert(newHabit)
            user.currentHabit = newHabit
        case "totalGoalCount":
            user.currentHabit.totalGoalCount = value
        case "why":
            user.currentHabit.why = Presets.whys[value]
        default:
            print("⚠️ Error: Attempted to set unknown property '\(property)' in setHabit")
            return
        }
        save()
    }

    func incrementGoalCount(by value: Int) {
        let user = fetchUser()
        user.currentHabit.completedGoalCount += value
        save()
    }

    func incrementDayCount(by value: Int = 1) {
        let user = fetchUser()
        if user.currentHabit.totalGoalCount == user.currentHabit.completedGoalCount {
            user.currentHabit.completedDays += value
            save()
        }
    }
    
    func populateCharacters(_ characters: [Character]) {
        let user = fetchUser()
        // Insert new characters into the context
        characters.forEach { modelContext.insert($0) }
        user.currentCharacters = characters
        save()
    }
    
    func resetCharacters() {
        let user = fetchUser()
        user.currentCharacters = user.currentCharacters.map { character in
            let updatedCharacter = Character(named: character.named, isShown: true)
            modelContext.insert(updatedCharacter)
            return updatedCharacter
        }
        save()
    }
    
    func hideCharacter(index: Int) {
        let user = fetchUser()
        if index < user.currentCharacters.count {
            user.currentCharacters[index].isShown = false
            save()
        }
    }
}
