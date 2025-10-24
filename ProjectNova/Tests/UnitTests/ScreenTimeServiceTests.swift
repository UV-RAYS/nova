import XCTest
@testable import ProjectNova

/// Unit tests for ScreenTimeService
class ScreenTimeServiceTests: XCTestCase {
    
    func testDistractingAppsList() {
        let screenTimeService = ScreenTimeService()
        let apps = screenTimeService.getDistractingApps()
        
        XCTAssertFalse(apps.isEmpty)
        XCTAssertTrue(apps.contains("com.facebook.Facebook"))
        XCTAssertTrue(apps.contains("com.instagram.instagram"))
    }
    
    func testMockScreenTimeSummary() {
        let screenTimeService = ScreenTimeService()
        let apps = ["com.test.app1", "com.test.app2"]
        let summary = screenTimeService.mockScreenTimeSummary(for: apps)
        
        XCTAssertEqual(summary.appUsages.count, 2)
        XCTAssertEqual(summary.totalScreenTime, summary.appUsages.reduce(0) { $0 + $1.usageDuration })
        XCTAssertTrue(summary.totalScreenTime > 0)
    }
    
    func testAppUsageProperties() {
        let appUsage = AppUsage(
            bundleIdentifier: "com.test.app",
            appName: "Test App",
            usageDuration: 45.5
        )
        
        XCTAssertEqual(appUsage.bundleIdentifier, "com.test.app")
        XCTAssertEqual(appUsage.appName, "Test App")
        XCTAssertEqual(appUsage.usageDuration, 45.5)
    }
}