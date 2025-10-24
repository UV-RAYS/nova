import Foundation
import CoreML

/// Service for generating AI insights (rule-based by default, with CoreML option)
class AIInsightsService: ObservableObject {
    private var isCoreMLAvailable = false
    private var model: MLModel?
    
    /// Generate insights based on user data
    func generateInsights(
        healthSummary: HealthSummary,
        screenTimeSummary: ScreenTimeSummary,
        tasksCompleted: Int,
        focusTime: Double
    ) async -> String {
        if isCoreMLAvailable, let model = model {
            return await generateInsightsWithCoreML(
                healthSummary: healthSummary,
                screenTimeSummary: screenTimeSummary,
                tasksCompleted: tasksCompleted,
                focusTime: focusTime
            )
        } else {
            return generateRuleBasedInsights(
                healthSummary: healthSummary,
                screenTimeSummary: screenTimeSummary,
                tasksCompleted: tasksCompleted,
                focusTime: focusTime
            )
        }
    }
    
    /// Generate rule-based insights (default mode)
    private func generateRuleBasedInsights(
        healthSummary: HealthSummary,
        screenTimeSummary: ScreenTimeSummary,
        tasksCompleted: Int,
        focusTime: Double
    ) -> String {
        var insights: [String] = []
        
        // Health insights
        if healthSummary.stepCount < 8000 {
            insights.append("Try to reach 8,000 steps today for better health.")
        } else if healthSummary.stepCount > 12000 {
            insights.append("Great job on your step count today!")
        }
        
        if healthSummary.activeEnergyBurned < 400 {
            insights.append("Consider increasing your activity to burn more calories.")
        }
        
        if healthSummary.exerciseTime < 30 {
            insights.append("Aim for at least 30 minutes of exercise daily.")
        }
        
        // Screen time insights
        if screenTimeSummary.totalScreenTime > 180 { // More than 3 hours
            insights.append("Your screen time is high today. Try taking more breaks.")
        } else if screenTimeSummary.totalScreenTime < 90 { // Less than 1.5 hours
            insights.append("Great job managing your screen time today!")
        }
        
        // Productivity insights
        if tasksCompleted == 0 {
            insights.append("No tasks completed today. Try setting small achievable goals.")
        } else if tasksCompleted >= 5 {
            insights.append("Excellent productivity today with \(tasksCompleted) tasks completed!")
        }
        
        if focusTime < 120 { // Less than 2 hours
            insights.append("Try to increase your focused work time tomorrow.")
        } else if focusTime > 240 { // More than 4 hours
            insights.append("Impressive focus time today!")
        }
        
        // Default insight if no specific conditions met
        if insights.isEmpty {
            insights.append("Keep up the good work on maintaining a balanced routine!")
        }
        
        return insights.joined(separator: " ")
    }
    
    /// Generate insights using CoreML model
    private func generateInsightsWithCoreML(
        healthSummary: HealthSummary,
        screenTimeSummary: ScreenTimeSummary,
        tasksCompleted: Int,
        focusTime: Double
    ) async -> String {
        // In a full implementation, this would use a CoreML model
        // For now, we'll fall back to rule-based insights
        return generateRuleBasedInsights(
            healthSummary: healthSummary,
            screenTimeSummary: screenTimeSummary,
            tasksCompleted: tasksCompleted,
            focusTime: focusTime
        )
    }
    
    /// Load a CoreML model for advanced insights
    func loadCoreMLModel(from url: URL) throws {
        model = try MLModel(contentsOf: url)
        isCoreMLAvailable = true
    }
}