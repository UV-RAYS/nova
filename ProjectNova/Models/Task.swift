import Foundation

/// Represents a user task or goal
struct Task: Identifiable, Codable {
    let id = UUID()
    var title: String
    var description: String
    var isCompleted: Bool
    var targetValue: Double
    var currentValue: Double
    var unit: TaskUnit
    var reward: RewardRule?
    var createdAt: Date
    var completedAt: Date?
    
    /// Units for task metrics
    enum TaskUnit: String, Codable, CaseIterable {
        case minutes
        case steps
        case calories
        case count
    }
    
    /// Progress percentage (0.0 to 1.0)
    var progress: Double {
        guard targetValue > 0 else { return 0 }
        return min(currentValue / targetValue, 1.0)
    }
    
    /// Check if task is completed
    var isTaskCompleted: Bool {
        return progress >= 1.0
    }
    
    /// Initialize a new task
    init(title: String, description: String = "", targetValue: Double, unit: TaskUnit, reward: RewardRule? = nil) {
        self.title = title
        self.description = description
        self.isCompleted = false
        self.targetValue = targetValue
        self.currentValue = 0
        self.unit = unit
        self.reward = reward
        self.createdAt = Date()
    }
}