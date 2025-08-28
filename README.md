# Swift Todo Command-Line App

A feature-rich command-line todo application built in Swift, demonstrating core iOS development concepts including protocol-oriented programming, data persistence, and comprehensive unit testing.

## Features

- ✅ **CRUD Operations**: Add, list, toggle completion, and delete todos
- 💾 **Flexible Persistence**: Choose between file system or in-memory storage
- 🎨 **Enhanced UI**: Emoji-rich command-line interface for better user experience
- 🔄 **Retry Logic**: User-friendly input validation with retry capabilities
- 🧪 **Comprehensive Testing**: 25+ unit tests covering all functionality
- 📱 **iOS-Ready Architecture**: Clean separation of concerns for easy migration to iOS apps

## Usage

```bash
🌟 Welcome to the Todo App!🌟

Available Commands:
📌 add - Add a new todo
📝 list - List all todos  
🔄 toggle - Toggle completion status of a todo
🗑️ delete - Delete a todo
👋 exit - Close the app
```

## Architecture

The application is organized into modular components following Swift best practices:

### Core Components

- **`Todo.swift`** - Data model conforming to `Codable` and `CustomStringConvertible`
- **`Cache.swift`** - Protocol-based persistence layer with file system and in-memory implementations
- **`TodosManager.swift`** - Business logic layer managing todo operations and persistence
- **`App.swift`** - User interface layer handling command processing and user interaction
- **`main.swift`** - Application entry point

### Design Patterns

- **Protocol-Oriented Programming**: `Cache` protocol enables flexible storage strategies
- **Dependency Injection**: `TodosManager` accepts any `Cache` implementation
- **Command Pattern**: Enum-based command processing for extensible user interactions
- **Separation of Concerns**: Clear boundaries between data, business logic, and presentation layers

## Framework Structure

The app uses a **TodoAppCore** framework architecture:

- **Framework Benefits**: Enables comprehensive unit testing of command-line tools
- **Modular Design**: Core functionality separate from executable entry point  
- **Testability**: Full test coverage with mock objects and dependency injection
- **Reusability**: Core components easily portable to iOS/macOS apps

## Testing

Comprehensive test suite covering:

- ✅ **Data Models**: Todo struct initialization and string representation
- ✅ **Persistence**: Both file system and in-memory cache implementations
- ✅ **Business Logic**: All TodosManager CRUD operations with edge cases
- ✅ **User Interface**: Command enum validation and descriptions
- ✅ **Integration**: Complex workflows and error handling

Run tests: `⌘+U` in Xcode

## Technical Highlights

- **Swift 5** with modern language features
- **JSON-based persistence** using `Codable`
- **UUID-based unique identifiers** for data integrity
- **FileManager integration** for cross-session persistence
- **Protocol witness tables** for runtime polymorphism
- **Property observers** and computed properties
- **Error handling** with proper user feedback

## Requirements

- macOS 10.15+
- Xcode 12.0+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `Todo App.xcodeproj` in Xcode
3. Build and run (⌘+R)
