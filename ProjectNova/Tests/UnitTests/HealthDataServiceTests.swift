import XCTest
@testable import ProjectNova

/// Unit tests for HealthDataService
class HealthDataServiceTests: XCTestCase {
    
    func testMockHealthSummary() {
        let healthService = HealthDataService()
        let date = Date()
        
        // Since we're in mock mode by default in tests, this should return mock data
        let summary = healthService.mockHealthSummary(for: date)
        
        XCTAssertEqual(summary.date, date)
        XCTAssertTrue(summary.activeEnergyBurned > 0)
        XCTAssertTrue(summary.exerciseTime > 0)
        XCTAssertTrue(summary.stepCount > 0)
        XCTAssertTrue(summary.standHours >= 0)
    }
    
    func testHealthSummaryProperties() {
        let date = Date()
        let summary = HealthSummary(
            date: date,
            activeEnergyBurned: 400,
            exerciseTime: 60,
            stepCount: 10000,
            standHours: 10
        )
        
        XCTAssertEqual(summary.date, date)
        XCTAssertEqual(summary.activeEnergyBurned, 400)
        XCTAssertEqual(summary.exerciseTime, 60)
        XCTAssertEqual(summary.stepCount, 10000)
        XCTAssertEqual(summary.standHours, 10)
    }
}