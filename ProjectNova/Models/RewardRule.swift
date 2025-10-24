import Foundation

/// Rule for rewarding task completion
struct RewardRule: Identifiable, Codable {
    let id = UUID()
    var name: String
    var description: String
    var condition: RewardCondition
    var rewardType: RewardType
    var isActive: Bool
    
    /// Condition for earning a reward
    enum RewardCondition: Codable {
        case taskCompletion(taskId: UUID)
        case streak(days: Int)
        case healthGoal(metric: HealthMetric, value: Double)
    }
    
    /// Type of reward to give
    enum RewardType: Codable {
        case appUnlock(bundleId: String, durationMinutes: Double)
        case extensionTime(minutes: Double)
        case custom(description: String)
    }
    
    /// Health metrics for reward conditions
    enum HealthMetric: String, Codable {
        case steps
        case calories
        case exerciseMinutes
    }
    
    /// Initialize a new reward rule
    init(name: String, description: String, condition: RewardCondition, rewardType: RewardType) {
        self.name = name
        self.description = description
        self.condition = condition
        self.rewardType = rewardType
        self.isActive = true
    }
}