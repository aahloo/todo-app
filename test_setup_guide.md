# Unit Testing Setup Guide for Todo App

## Step 1: Add Test Target to Your Xcode Project

1. **In Xcode, select your project** (top item in the navigator)
2. **Click the "+" button** at the bottom of the target list
3. **Choose "Unit Testing Bundle"** from the test section
4. **Name it** something like `TodoAppTests`
5. **Make sure it targets your main app**

## Step 2: Configure Test Target

1. **Select your test target** in the project navigator
2. **Go to Build Settings**
3. **Find "Defines Module"** and set it to `Yes`
4. **In Build Phases**, make sure your main target is listed under "Target Dependencies"

## Step 3: Replace Default Test File

1. **Delete the default test file** (usually `TodoAppTestsTests.swift`)
2. **Create a new Swift file** named `TodoAppTests.swift`
3. **Copy the test code** from the artifact above
4. **Important**: Replace `YourTodoAppName` with your actual target name on this line:
   ```swift
   @testable import YourTodoAppName
   ```

## Step 4: Make Your Classes Testable

In your main `main.swift` file, you might need to make some classes `public` or `internal` (they're probably already accessible). The `@testable import` should handle most visibility issues.

## Step 5: Run the Tests

### Method 1: Run All Tests
- Press **Cmd+U** to run all tests
- Or go to **Product → Test**

### Method 2: Run Individual Test Classes
- **Right-click on a test class** in the code editor
- **Select "Run [ClassName]"**

### Method 3: Run Individual Test Methods
- **Click the diamond icon** next to any test method
- **It will turn into a play button** when you hover over it

## Test Coverage Overview

The test suite covers:

### ✅ **Todo Struct Tests**
- Proper initialization
- CustomStringConvertible implementation (emoji display)
- Codable functionality (JSON encoding/decoding)

### ✅ **InMemoryCache Tests**
- Save and load functionality
- Empty cache handling
- Data overwriting

### ✅ **FileSystemCache Tests**
- File system persistence
- Nonexistent file handling
- Cross-session persistence
- Empty data saving

### ✅ **TodosManager Tests**
- Initialization with/without existing data
- Adding todos (single and multiple)
- Toggle completion (valid and invalid indices)
- Delete todos (valid and invalid indices)
- Complex workflow scenarios
- Cache interaction validation

### ✅ **App.Command Tests**
- Raw value validation
- Command initialization
- Description content
- CaseIterable conformance

## Expected Test Results

When you run the tests, you should see:
- **Green checkmarks** ✅ for passing tests
- **Red X marks** ❌ for failing tests (hopefully none!)
- **Test summary** showing total tests run and results

## Troubleshooting Common Issues

### Import Error
If you get `@testable import` errors:
1. Make sure your main target name matches the import statement
2. Check that the test target depends on your main target

### File Access Issues
For FileSystemCache tests:
1. The tests create temporary directories
2. If tests fail due to file permissions, check your simulator/device settings

### Mock Cache Issues
The MockCache is designed to simulate different scenarios:
- Normal operation
- Failed loads
- Counting method calls

## Running Tests in Different Ways

### Command Line (Optional)
You can also run tests from the command line:
```bash
xcodebuild test -scheme YourSchemeName -destination 'platform=macOS'
```

### Continuous Integration
These tests are perfect for CI/CD pipelines if you plan to expand your project.

## What Each Test Validates

- **Data integrity**: Todos maintain their properties correctly
- **Persistence**: Data survives app restarts (FileSystemCache)
- **Edge cases**: Invalid indices, empty states
- **Business logic**: Toggle, add, delete operations work correctly
- **Error handling**: Invalid inputs are handled gracefully
- **Protocol compliance**: Cache implementations work as expected

Run the tests after making any changes to ensure you haven't broken existing functionality!