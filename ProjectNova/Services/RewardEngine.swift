import Foundation
import Combine

/// Engine for evaluating and applying rewards
class RewardEngine: ObservableObject {
    private let screenTimeService: ScreenTimeService
    
    /// Publisher for rewards updates
    @Published var earnedRewards: [RewardRule] = []
    
    init(screenTimeService: ScreenTimeService) {
        self.screenTimeService = screenTimeService
    }
    
    /// Evaluate rewards based on a report card
    func evaluateRewards(for report: ReportCard) -> [RewardRule] {
        var rewards: [RewardRule] = []
        
        // Example reward rules:
        
        // Reward for completing 5 or more tasks
        if report.tasksCompleted >= 5 {
            let reward = RewardRule(
                name: "Productivity Bonus",
                description: "Completed 5+ tasks today",
                condition: .taskCompletion(taskId: UUID()),
                rewardType: .extensionTime(minutes: 30)
            )
            rewards.append(reward)
        }
        
        // Reward for exercising 60+ minutes
        if report.healthSummary.exerciseTime >= 60 {
            let reward = RewardRule(
                name: "Fitness Enthusiast",
                description: "Exercised for 60+ minutes",
                condition: .healthGoal(metric: .exerciseMinutes, value: 60),
                rewardType: .appUnlock(bundleId: "com.apple.Music", durationMinutes: 20)
            )
            rewards.append(reward)
        }
        
        // Reward for low screen time
        if report.screenTimeSummary.totalScreenTime < 120 { // Less than 2 hours
            let reward = RewardRule(
                name: "Digital Balance",
                description: "Kept screen time under 2 hours",
                condition: .streak(days: 1),
                rewardType: .extensionTime(minutes: 15)
            )
            rewards.append(reward)
        }
        
        return rewards
    }
    
    /// Apply a reward
    func applyReward(_ reward: RewardRule) async {
        switch reward.rewardType {
        case .appUnlock(let bundleId, let durationMinutes):
            let unlockUntil = Date().addingTimeInterval(durationMinutes * 60)
            do {
                try await screenTimeService.unblock(apps: [bundleId])
                // Schedule re-blocking after duration
                DispatchQueue.main.asyncAfter(deadline: .now() + durationMinutes * 60) {
                    Task {
                        try? await self.screenTimeService.block(apps: [bundleId], until: Date())
                    }
                }
                print("Unlocked \(bundleId) for \(durationMinutes) minutes")
            } catch {
                print("Failed to apply app unlock reward: \(error)")
            }
            
        case .extensionTime(let minutes):
            // Extension time would typically be tracked in the app
            print("Earned \(minutes) minutes of extension time")
            
        case .custom(let description):
            print("Custom reward: \(description)")
        }
    }
    
    /// Save earned rewards to persistent storage
    func saveRewards(_ rewards: [RewardRule]) {
        // In a full implementation, this would save to CoreData
        earnedRewards = rewards
    }
    
    /// Load rewards from persistent storage
    func loadRewards() -> [RewardRule] {
        // In a full implementation, this would load from CoreData
        return earnedRewards
    }
}