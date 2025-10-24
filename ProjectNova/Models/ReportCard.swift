import Foundation

/// Nightly report card summarizing user's daily activity
struct ReportCard: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let tasksCompleted: Int
    let tasksMissed: Int
    let healthSummary: HealthSummary
    let screenTimeSummary: ScreenTimeSummary
    let focusTime: Double // in minutes
    let insights: String
    let rewardsApplied: [RewardRule]
    
    /// Initialize a new report card
    init(
        date: Date = Date(),
        tasksCompleted: Int = 0,
        tasksMissed: Int = 0,
        healthSummary: HealthSummary = HealthSummary(),
        screenTimeSummary: ScreenTimeSummary = ScreenTimeSummary(),
        focusTime: Double = 0,
        insights: String = "",
        rewardsApplied: [RewardRule] = []
    ) {
        self.date = date
        self.tasksCompleted = tasksCompleted
        self.tasksMissed = tasksMissed
        self.healthSummary = healthSummary
        self.screenTimeSummary = screenTimeSummary
        self.focusTime = focusTime
        self.insights = insights
        self.rewardsApplied = rewardsApplied
    }
}

/// Summary of screen time usage
struct ScreenTimeSummary: Codable {
    let date: Date
    let totalScreenTime: Double // in minutes
    let appUsages: [AppUsage]
    
    init(date: Date = Date(), totalScreenTime: Double = 0, appUsages: [AppUsage] = []) {
        self.date = date
        self.totalScreenTime = totalScreenTime
        self.appUsages = appUsages
    }
}

/// Usage data for a specific app
struct AppUsage: Codable {
    let bundleIdentifier: String
    let appName: String
    let usageDuration: Double // in minutes
    
    init(bundleIdentifier: String, appName: String, usageDuration: Double) {
        self.bundleIdentifier = bundleIdentifier
        self.appName = appName
        self.usageDuration = usageDuration
    }
}