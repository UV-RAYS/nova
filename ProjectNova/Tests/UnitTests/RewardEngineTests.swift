import XCTest
@testable import ProjectNova

/// Unit tests for RewardEngine
class RewardEngineTests: XCTestCase {
    
    func testRewardEvaluation() {
        let screenTimeService = ScreenTimeService()
        let rewardEngine = RewardEngine(screenTimeService: screenTimeService)
        
        // Create a mock report card
        let healthSummary = HealthSummary(
            date: Date(),
            activeEnergyBurned: 450,
            exerciseTime: 75,
            stepCount: 12000,
            standHours: 12
        )
        
        let screenTimeSummary = ScreenTimeSummary(
            date: Date(),
            totalScreenTime: 90,
            appUsages: []
        )
        
        let reportCard = ReportCard(
            date: Date(),
            tasksCompleted: 6,
            tasksMissed: 1,
            healthSummary: healthSummary,
            screenTimeSummary: screenTimeSummary,
            focusTime: 180,
            insights: "Great job!",
            rewardsApplied: []
        )
        
        let rewards = rewardEngine.evaluateRewards(for: reportCard)
        
        // Should have at least one reward for completing 5+ tasks
        XCTAssertFalse(rewards.isEmpty)
        
        // Check for specific rewards
        let hasProductivityBonus = rewards.contains { reward in
            reward.name == "Productivity Bonus"
        }
        
        let hasFitnessReward = rewards.contains { reward in
            reward.name == "Fitness Enthusiast"
        }
        
        let hasDigitalBalanceReward = rewards.contains { reward in
            reward.name == "Digital Balance"
        }
        
        XCTAssertTrue(hasProductivityBonus)
        XCTAssertTrue(hasFitnessReward)
        XCTAssertTrue(hasDigitalBalanceReward)
    }
    
    func testRewardEvaluationWithLowActivity() {
        let screenTimeService = ScreenTimeService()
        let rewardEngine = RewardEngine(screenTimeService: screenTimeService)
        
        // Create a mock report card with low activity
        let healthSummary = HealthSummary(
            date: Date(),
            activeEnergyBurned: 200,
            exerciseTime: 15,
            stepCount: 3000,
            standHours: 4
        )
        
        let screenTimeSummary = ScreenTimeSummary(
            date: Date(),
            totalScreenTime: 240,
            appUsages: []
        )
        
        let reportCard = ReportCard(
            date: Date(),
            tasksCompleted: 2,
            tasksMissed: 5,
            healthSummary: healthSummary,
            screenTimeSummary: screenTimeSummary,
            focusTime: 60,
            insights: "Could do better",
            rewardsApplied: []
        )
        
        let rewards = rewardEngine.evaluateRewards(for: reportCard)
        
        // Should have no rewards for low activity
        XCTAssertTrue(rewards.isEmpty)
    }
}