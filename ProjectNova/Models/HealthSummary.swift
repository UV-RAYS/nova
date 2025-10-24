import Foundation

/// Summary of health data for a specific day
struct HealthSummary: Codable {
    let date: Date
    let activeEnergyBurned: Double // in kcal
    let exerciseTime: Double // in minutes
    let stepCount: Double
    let standHours: Int
    
    /// Initialize with default values
    init(date: Date = Date()) {
        self.date = date
        self.activeEnergyBurned = 0
        self.exerciseTime = 0
        self.stepCount = 0
        self.standHours = 0
    }
    
    /// Initialize with specific values
    init(date: Date, activeEnergyBurned: Double, exerciseTime: Double, stepCount: Double, standHours: Int) {
        self.date = date
        self.activeEnergyBurned = activeEnergyBurned
        self.exerciseTime = exerciseTime
        self.stepCount = stepCount
        self.standHours = standHours
    }
}