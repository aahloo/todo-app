import Foundation

// The `TodosManager` class should have:
// * A function `func listTodos()` to display all todos.
// * A function named `func addTodo(with title: String)` to insert a new todo.
// * A function named `func toggleCompletion(forTodoAtIndex index: Int)`
//   to alter the completion status of a specific todo using its index.
// * A function named `func deleteTodo(atIndex index: Int)` to remove a todo using its index.
public final class TodosManager {
    
    private var todos: [Todo] = []
    private let cache: Cache
    
    public init(cache: Cache) {
        self.cache = cache
        loadTodos()
    }
    
    private func loadTodos() {
        if let savedTodos = cache.load() {
            todos = savedTodos
        }
    }
    
    private func saveTodos() {
        cache.save(todos: todos)
    }
    
    public func listTodos() {
        guard !todos.isEmpty else {
            print("📝 No todos found. Add some tasks to get started! 🌟")
            return
        }
        
        print("\n📝 Your Todo List:")
        print("-------------------")
        
        for (index, todo) in todos.enumerated() {
            print("\(index + 1). \(todo)")
        }
        
        print("-------------------\n")
    }
    
    public func addTodo(with title: String) {
        let newTodo = Todo(title: title)
        todos.append(newTodo)
        saveTodos()
        print("✅ Added: \"\(title)\" 🌟")
    }
    
    // Corrected index handling - function expects 0-based index
    public func toggleCompletion(forTodoAtIndex index: Int) {
        guard index >= 0 && index < todos.count else {
            print("❗ Invalid index. Please try again.")
            return
        }
        
        todos[index].isCompleted.toggle()
        saveTodos()
        
        let status = todos[index].isCompleted ? "completed" : "not completed"
        print("🌟 Marked \"\(todos[index].title)\" as \(status)!")
    }
    
    // Corrected index handling - function expects 0-based index
    public func deleteTodo(atIndex index: Int) {
        guard index >= 0 && index < todos.count else {
            print("❗ Invalid index. Please try again.")
            return
        }
        
        let deletedTodo = todos.remove(at: index)
        saveTodos()
        print("🗑️ Deleted: \"\(deletedTodo.title)\". Hope you meant to do that! 🌟")
    }
    
    public var count: Int {
        return todos.count
    }
    
}
