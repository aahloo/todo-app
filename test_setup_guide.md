## Unit Testing Guide

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

## What Each Test Validates

- **Data integrity**: Todos maintain their properties correctly
- **Persistence**: Data survives app restarts (FileSystemCache)
- **Edge cases**: Invalid indices, empty states
- **Business logic**: Toggle, add, delete operations work correctly
- **Error handling**: Invalid inputs are handled gracefully
- **Protocol compliance**: Cache implementations work as expected

