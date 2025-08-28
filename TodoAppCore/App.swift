import Foundation

// * The `App` class should have a `func run()` method, this method should perpetually
//   await user input and execute commands.
//  * Implement a `Command` enum to specify user commands. Include cases
//    such as `add`, `list`, `toggle`, `delete`, and `exit`.
//  * The enum should be nested inside the definition of the `App` class
public final class App {
    
    private let todosManager: TodosManager
    
    // implement 'Command' enum
    public enum Command: String, CaseIterable {
        
        case add = "add"
        case list = "list"
        case toggle = "toggle"
        case delete = "delete"
        case exit = "exit"
        
        var description: String {
            switch self {
            case .add:
                return "📌 add - Add a new todo"
            case .list:
                return "📝 list - List all todos"
            case .toggle:
                return "🔄 toggle - Toggle completion status of a todo"
            case .delete:
                return "🗑️ delete - Delete a todo"
            case .exit:
                return "👋 exit - Close the app"
            }
        }
    }
    
    public init(useFileSystem: Bool = true) {
        let cache: Cache = useFileSystem ? FileSystemCache() : InMemoryCache()
        self.todosManager = TodosManager(cache: cache)
    }
        
    public func run() {
        print("🌟 Welcome to the Todo App!🌟")
        showHelp()
        
        while true {
            print("\nEnter command (type 'help' for options): ")
            print("> ", terminator: "")
            
            // Improved input handling
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
                  !input.isEmpty else {
                print("❗ Invalid input. Please enter a valid command.")
                continue
            }
            
            if input == "help" {
                showHelp()
                continue
            }
            
            guard let command = Command(rawValue: input) else {
                print("❗ Unknown command. Type 'help' for options.")
                continue
            }
            
            processCommand(command)
            
            if command == .exit {
                break
            }
        }
    }
    
    private func showHelp() {
        print("\nAvailable Commands:")
        print("-------------------")
        
        for command in Command.allCases {
            print(command.description)
        }
        
        print("❓ help - Show this help message")
        print("-------------------\n")
    }
    
    private func processCommand(_ command: Command) {
        switch command {
        case .add:
            handleAddCommand()
        case .list:
            todosManager.listTodos()
        case .toggle:
            handleToggleCommand()
        case .delete:
            handleDeleteCommand()
        case .exit:
            print("👋 Exiting the app. Goodbye! ✨")
        }
    }
    
    private func handleAddCommand() {
        print("Enter todo title: ")
        print("> ", terminator: "")
        
        guard let title = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            print("❗ Title cannot be empty. Please try again.")
            return
        }
        
        todosManager.addTodo(with: title)
    }
    
    // Added retry loop for invalid input
    private func handleToggleCommand() {
        guard todosManager.count > 0 else {
            print("📝 No todos available to toggle. Please add some first! 🌟")
            return
        }
        
        todosManager.listTodos()
        
        while true {
            print("Enter the number of the todo to toggle (or 'back' to return to main menu): ")
            print("> ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !input.isEmpty else {
                print("❗ Please enter a valid number or 'back'.")
                continue
            }
            
            // Allow user to go back to main menu
            if input.lowercased() == "back" {
                return
            }
            
            guard let index = Int(input),
                  index > 0,
                  index <= todosManager.count else {
                print("❗ Please enter a valid number between 1 and \(todosManager.count), or 'back' to return.")
                continue
            }
            
            // Convert 1-based user input to 0-based array index
            todosManager.toggleCompletion(forTodoAtIndex: index - 1)
            break // Exit the loop after successful operation
        }
    }
    
    // Added retry loop for invalid input
    private func handleDeleteCommand() {
        guard todosManager.count > 0 else {
            print("📝 No todos available to delete. Please add some first! 🌟")
            return
        }
        
        todosManager.listTodos()
        
        while true {
            print("Enter the number of the todo to delete (or 'back' to return to main menu): ")
            print("> ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !input.isEmpty else {
                print("❗ Please enter a valid number or 'back'.")
                continue
            }
            
            // Allow user to go back to main menu
            if input.lowercased() == "back" {
                return
            }
            
            guard let index = Int(input),
                  index > 0,
                  index <= todosManager.count else {
                print("❗ Please enter a valid number between 1 and \(todosManager.count), or 'back' to return.")
                continue
            }
            
            // Convert 1-based user input to 0-based array index
            todosManager.deleteTodo(atIndex: index - 1)
            break // Exit the loop after successful operation
        }
    }
    
}
