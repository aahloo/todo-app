import XCTest
//@testable import ToDo_App
@testable import TodoAppCore
    
import XCTest
@testable import ToDo_App

// MARK: - Todo Struct Tests
class TodoTests: XCTestCase {
    
    func testTodoInitialization() {
        // Given
        let title = "Test Todo"
        
        // When
        let todo = Todo(title: title)
        
        // Then
        XCTAssertEqual(todo.title, title)
        XCTAssertFalse(todo.isCompleted)
        XCTAssertNotNil(todo.id)
    }
    
    func testTodoCustomStringConvertible() {
        // Given
        let incompleteTodo = Todo(title: "Incomplete Task")
        var completeTodo = Todo(title: "Complete Task")
        completeTodo.isCompleted = true
        
        // When & Then
        XCTAssertEqual(incompleteTodo.description, "❌ Incomplete Task")
        XCTAssertEqual(completeTodo.description, "✅ Complete Task")
    }
    
    func testTodoCodable() {
        // Given
        let originalTodo = Todo(title: "Codable Test")
        
        // When - Encode
        let encoder = JSONEncoder()
        let data = try? encoder.encode(originalTodo)
        XCTAssertNotNil(data)
        
        // Then - Decode
        let decoder = JSONDecoder()
        let decodedTodo = try? decoder.decode(Todo.self, from: data!)
        
        XCTAssertNotNil(decodedTodo)
        XCTAssertEqual(originalTodo.id, decodedTodo!.id)
        XCTAssertEqual(originalTodo.title, decodedTodo!.title)
        XCTAssertEqual(originalTodo.isCompleted, decodedTodo!.isCompleted)
    }
}

// MARK: - InMemoryCache Tests
class InMemoryCacheTests: XCTestCase {
    
    var cache: InMemoryCache!
    
    override func setUp() {
        super.setUp()
        cache = InMemoryCache()
    }
    
    override func tearDown() {
        cache = nil
        super.tearDown()
    }
    
    func testSaveAndLoadTodos() {
        // Given
        let todos = [
            Todo(title: "First Todo"),
            Todo(title: "Second Todo")
        ]
        
        // When
        cache.save(todos: todos)
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertNotNil(loadedTodos)
        XCTAssertEqual(loadedTodos!.count, 2)
        XCTAssertEqual(loadedTodos![0].title, "First Todo")
        XCTAssertEqual(loadedTodos![1].title, "Second Todo")
    }
    
    func testLoadEmptyCache() {
        // When
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertNil(loadedTodos)
    }
    
    func testOverwriteTodos() {
        // Given
        let firstBatch = [Todo(title: "First Batch")]
        let secondBatch = [Todo(title: "Second Batch"), Todo(title: "Another Todo")]
        
        // When
        cache.save(todos: firstBatch)
        cache.save(todos: secondBatch)
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertEqual(loadedTodos!.count, 2)
        XCTAssertEqual(loadedTodos![0].title, "Second Batch")
    }
}

// MARK: - FileSystemCache Tests
class FileSystemCacheTests: XCTestCase {
    
    var cache: FileSystemCache!
        
    override func setUp() {
        super.setUp()
        cache = FileSystemCache()
        
        // clean up any existing test files
        cleanUpTestFiles()
        
    }
    
    override func tearDown() {
        // Clean up after each test
        cleanUpTestFiles()
        cache = nil
        super.tearDown()
    }
    
    private func cleanUpTestFiles() {
        
        let fileManager = FileManager.default
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent("todos.json")
        
        // remove the file if it exists
        try? fileManager.removeItem(at: fileURL)
        
    }
    
    func testSaveAndLoadTodos() {
        // Given
        let todos = [
            Todo(title: "File System Todo 1"),
            Todo(title: "File System Todo 2")
        ]
        
        // When
        cache.save(todos: todos)
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertNotNil(loadedTodos)
        XCTAssertEqual(loadedTodos!.count, 2)
        XCTAssertEqual(loadedTodos![0].title, "File System Todo 1")
        XCTAssertEqual(loadedTodos![1].title, "File System Todo 2")
    }
    
    func testLoadNonexistentFile() {
        // When
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertNil(loadedTodos)
    }
    
    func testSaveEmptyTodos() {
        // Given
        let emptyTodos: [Todo] = []
        
        // When
        cache.save(todos: emptyTodos)
        let loadedTodos = cache.load()
        
        // Then
        XCTAssertNotNil(loadedTodos)
        XCTAssertEqual(loadedTodos!.count, 0)
    }
    
    func testPersistenceBetweenSessions() {
        // Given
        let todos = [Todo(title: "Persistent Todo")]
        
        // When - First session
        cache.save(todos: todos)
        
        // Create a new cache instance to simulate app restart
        let newCache = FileSystemCache()
        let loadedTodos = newCache.load()
        
        // Then
        XCTAssertNotNil(loadedTodos)
        XCTAssertEqual(loadedTodos!.count, 1)
        XCTAssertEqual(loadedTodos![0].title, "Persistent Todo")
    }
}

// MARK: - Mock Cache for TodosManager Tests
class MockCache: Cache {
    var savedTodos: [Todo] = []
    var shouldFailLoad = false
    var saveCallCount = 0
    var loadCallCount = 0
    
    func save(todos: [Todo]) {
        saveCallCount += 1
        savedTodos = todos
    }
    
    func load() -> [Todo]? {
        loadCallCount += 1
        return shouldFailLoad ? nil : savedTodos
    }
}

// MARK: - TodosManager Tests
class TodosManagerTests: XCTestCase {
    
    var todosManager: TodosManager!
    var mockCache: MockCache!
    
    override func setUp() {
        super.setUp()
        mockCache = MockCache()
        todosManager = TodosManager(cache: mockCache)
    }
    
    override func tearDown() {
        todosManager = nil
        mockCache = nil
        super.tearDown()
    }
    
    func testInitializationWithEmptyCache() {
        // Given
        let emptyMockCache = MockCache()
        
        // When
        let manager = TodosManager(cache: emptyMockCache)
        
        // Then
        XCTAssertEqual(manager.count, 0)
        XCTAssertEqual(emptyMockCache.loadCallCount, 1)
    }
    
    func testInitializationWithExistingTodos() {
        // Given
        let existingTodos = [Todo(title: "Existing Todo")]
        mockCache.savedTodos = existingTodos
        
        // When
        let manager = TodosManager(cache: mockCache)
        
        // Then
        XCTAssertEqual(manager.count, 1)
    }
    
    func testAddTodo() {
        // Given
        let title = "New Todo"
        
        // When
        todosManager.addTodo(with: title)
        
        // Then
        XCTAssertEqual(todosManager.count, 1)
        XCTAssertEqual(mockCache.saveCallCount, 1)
        XCTAssertEqual(mockCache.savedTodos.count, 1)
        XCTAssertEqual(mockCache.savedTodos[0].title, title)
        XCTAssertFalse(mockCache.savedTodos[0].isCompleted)
    }
    
    func testAddMultipleTodos() {
        // When
        todosManager.addTodo(with: "First Todo")
        todosManager.addTodo(with: "Second Todo")
        todosManager.addTodo(with: "Third Todo")
        
        // Then
        XCTAssertEqual(todosManager.count, 3)
        XCTAssertEqual(mockCache.saveCallCount, 3)
        XCTAssertEqual(mockCache.savedTodos[1].title, "Second Todo")
    }
    
    func testToggleCompletionValid() {
        // Given
        todosManager.addTodo(with: "Toggle Test")
        let initialCompletionStatus = mockCache.savedTodos[0].isCompleted
        
        // When
        todosManager.toggleCompletion(forTodoAtIndex: 0)
        
        // Then
        XCTAssertNotEqual(mockCache.savedTodos[0].isCompleted, initialCompletionStatus)
        XCTAssertEqual(mockCache.saveCallCount, 2) // Once for add, once for toggle
    }
    
    func testToggleCompletionInvalidIndex() {
        // Given
        todosManager.addTodo(with: "Test Todo")
        let initialSaveCount = mockCache.saveCallCount
        
        // When & Then - Test negative index
        todosManager.toggleCompletion(forTodoAtIndex: -1)
        XCTAssertEqual(mockCache.saveCallCount, initialSaveCount) // Should not save
        
        // When & Then - Test out of bounds index
        todosManager.toggleCompletion(forTodoAtIndex: 1)
        XCTAssertEqual(mockCache.saveCallCount, initialSaveCount) // Should not save
    }
    
    func testDeleteTodoValid() {
        // Given
        todosManager.addTodo(with: "To Delete")
        todosManager.addTodo(with: "To Keep")
        XCTAssertEqual(todosManager.count, 2)
        
        // When
        todosManager.deleteTodo(atIndex: 0)
        
        // Then
        XCTAssertEqual(todosManager.count, 1)
        XCTAssertEqual(mockCache.savedTodos.count, 1)
        XCTAssertEqual(mockCache.savedTodos[0].title, "To Keep")
        XCTAssertEqual(mockCache.saveCallCount, 3) // Add, add, delete
    }
    
    func testDeleteTodoInvalidIndex() {
        // Given
        todosManager.addTodo(with: "Test Todo")
        let initialCount = todosManager.count
        let initialSaveCount = mockCache.saveCallCount
        
        // When & Then - Test negative index
        todosManager.deleteTodo(atIndex: -1)
        XCTAssertEqual(todosManager.count, initialCount)
        XCTAssertEqual(mockCache.saveCallCount, initialSaveCount)
        
        // When & Then - Test out of bounds index
        todosManager.deleteTodo(atIndex: 1)
        XCTAssertEqual(todosManager.count, initialCount)
        XCTAssertEqual(mockCache.saveCallCount, initialSaveCount)
    }
    
    func testDeleteAllTodos() {
        // Given
        todosManager.addTodo(with: "Todo 1")
        todosManager.addTodo(with: "Todo 2")
        todosManager.addTodo(with: "Todo 3")
        
        // When
        todosManager.deleteTodo(atIndex: 2) // Delete last
        todosManager.deleteTodo(atIndex: 1) // Delete middle (now last)
        todosManager.deleteTodo(atIndex: 0) // Delete first (now only)
        
        // Then
        XCTAssertEqual(todosManager.count, 0)
        XCTAssertEqual(mockCache.savedTodos.count, 0)
    }
    
    func testComplexWorkflow() {
        // Given - Start empty
        XCTAssertEqual(todosManager.count, 0)
        
        // When - Add some todos
        todosManager.addTodo(with: "Buy milk")
        todosManager.addTodo(with: "Walk dog")
        todosManager.addTodo(with: "Read book")
        
        // Then - Check count
        XCTAssertEqual(todosManager.count, 3)
        
        // When - Complete middle todo
        todosManager.toggleCompletion(forTodoAtIndex: 1)
        
        // Then - Check it's completed
        XCTAssertTrue(mockCache.savedTodos[1].isCompleted)
        XCTAssertFalse(mockCache.savedTodos[0].isCompleted)
        
        // When - Delete completed todo
        todosManager.deleteTodo(atIndex: 1)
        
        // Then - Check final state
        XCTAssertEqual(todosManager.count, 2)
        XCTAssertEqual(mockCache.savedTodos[0].title, "Buy milk")
        XCTAssertEqual(mockCache.savedTodos[1].title, "Read book")
    }
}

// MARK: - App.Command Tests
class AppCommandTests: XCTestCase {
    
    func testCommandRawValues() {
        XCTAssertEqual(App.Command.add.rawValue, "add")
        XCTAssertEqual(App.Command.list.rawValue, "list")
        XCTAssertEqual(App.Command.toggle.rawValue, "toggle")
        XCTAssertEqual(App.Command.delete.rawValue, "delete")
        XCTAssertEqual(App.Command.exit.rawValue, "exit")
    }
    
    func testCommandInitialization() {
        XCTAssertEqual(App.Command(rawValue: "add"), .add)
        XCTAssertEqual(App.Command(rawValue: "list"), .list)
        XCTAssertEqual(App.Command(rawValue: "toggle"), .toggle)
        XCTAssertEqual(App.Command(rawValue: "delete"), .delete)
        XCTAssertEqual(App.Command(rawValue: "exit"), .exit)
        XCTAssertNil(App.Command(rawValue: "invalid"))
    }
    
    func testCommandDescriptions() {
        XCTAssertTrue(App.Command.add.description.contains("add"))
        XCTAssertTrue(App.Command.list.description.contains("list"))
        XCTAssertTrue(App.Command.toggle.description.contains("toggle"))
        XCTAssertTrue(App.Command.delete.description.contains("delete"))
        XCTAssertTrue(App.Command.exit.description.contains("exit"))
    }
    
    func testCommandCaseIterable() {
        let allCommands = App.Command.allCases
        XCTAssertEqual(allCommands.count, 5)
        XCTAssertTrue(allCommands.contains(.add))
        XCTAssertTrue(allCommands.contains(.list))
        XCTAssertTrue(allCommands.contains(.toggle))
        XCTAssertTrue(allCommands.contains(.delete))
        XCTAssertTrue(allCommands.contains(.exit))
    }
}


