import XCTest
@testable import ProjectNova

/// Unit tests for Task model
class TaskTests: XCTestCase {
    
    func testTaskInitialization() {
        let task = Task(
            title: "Test Task",
            description: "This is a test task",
            targetValue: 30,
            unit: .minutes
        )
        
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "This is a test task")
        XCTAssertEqual(task.targetValue, 30)
        XCTAssertEqual(task.unit, .minutes)
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.currentValue, 0)
    }
    
    func testTaskProgress() {
        var task = Task(
            title: "Test Task",
            targetValue: 100,
            unit: .steps
        )
        
        // Test initial progress
        XCTAssertEqual(task.progress, 0)
        
        // Test partial progress
        task.currentValue = 50
        XCTAssertEqual(task.progress, 0.5)
        
        // Test completed progress
        task.currentValue = 100
        XCTAssertEqual(task.progress, 1.0)
        
        // Test overachievement
        task.currentValue = 150
        XCTAssertEqual(task.progress, 1.0) // Should max at 1.0
    }
    
    func testTaskCompletion() {
        var task = Task(
            title: "Test Task",
            targetValue: 30,
            unit: .minutes
        )
        
        XCTAssertFalse(task.isTaskCompleted)
        
        task.currentValue = 30
        XCTAssertTrue(task.isTaskCompleted)
        
        task.currentValue = 35
        XCTAssertTrue(task.isTaskCompleted)
    }
}