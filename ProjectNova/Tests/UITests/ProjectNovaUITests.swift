import XCTest

/// UI tests for Project Nova
class ProjectNovaUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run.
        // The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDashboardView() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Test that dashboard elements are present
        XCTAssertTrue(app.navigationBars["Dashboard"].exists)
        XCTAssertTrue(app.staticTexts["Today's Health"].exists)
        XCTAssertTrue(app.staticTexts["Quick Actions"].exists)
        XCTAssertTrue(app.staticTexts["Today's Tasks"].exists)
    }
    
    func testTaskCreation() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to tasks view
        app.buttons["Tasks"].tap()
        
        // Tap add button
        app.navigationBars["Tasks"].buttons["Add"].tap()
        
        // Fill in task details
        let titleField = app.textFields["Title"]
        titleField.tap()
        titleField.typeText("UI Test Task")
        
        let descriptionField = app.textFields["Description"]
        descriptionField.tap()
        descriptionField.typeText("Task created during UI test")
        
        // Save task
        app.navigationBars["New Task"].buttons["Save"].tap()
        
        // Verify task was created
        XCTAssertTrue(app.staticTexts["UI Test Task"].exists)
    }
    
    func testTimerFunctionality() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to timer view
        app.buttons["Timer"].tap()
        
        // Verify timer elements are present
        XCTAssertTrue(app.staticTexts["00:00"].exists)
        XCTAssertTrue(app.buttons["Start"].exists)
        
        // Start timer
        app.buttons["Start"].tap()
        
        // Verify timer state changed
        XCTAssertTrue(app.buttons["Pause"].exists)
        XCTAssertTrue(app.buttons["Stop"].exists)
    }
}