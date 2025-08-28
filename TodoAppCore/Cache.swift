import Foundation

// Create the `Cache` protocol that defines the following method signatures:
//  `func save(todos: [Todo])`: Persists the given todos.
//  `func load() -> [Todo]?`: Retrieves and returns the saved todos, or nil if none exist.
public protocol Cache {
    
    func save(todos: [Todo])
    func load() -> [Todo]?

}

// `FileSystemCache`: This implementation should utilize the file system
// to persist and retrieve the list of todos.
public final class FileSystemCache: Cache {
    
    private let fileName = "todos.json"
    private let fileManager = FileManager.default
    
    private var fileURL: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent(fileName)
    }
    
    public func save(todos: [Todo]) {
        do {
            let data = try JSONEncoder().encode(todos)
            try data.write(to: fileURL)
        } catch {
            print("❗ Error saving todos: \(error)")
        }
    }
    
    public func load() -> [Todo]? {
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let todos = try JSONDecoder().decode([Todo].self, from: data)
            return todos
        } catch {
            print("❗ Error loading todos: \(error)")
            return nil
        }
    }
    
}

// `InMemoryCache`: : Keeps todos in an array or similar structure during the session.
// This won't retain todos across different app launches, but serves as a quick in-session cache.
public final class InMemoryCache: Cache {
    
    private var todos: [Todo] = []
    
    public func save(todos: [Todo]) {
        self.todos = todos
    }
    
    public func load() -> [Todo]? {
        return todos.isEmpty ? nil : todos
    }

}
