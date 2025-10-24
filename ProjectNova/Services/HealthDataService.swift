import Foundation
import HealthKit
import Combine

/// Service for fetching health data from HealthKit or mock data
class HealthDataService: ObservableObject {
    private let healthStore = HKHealthStore()
    private var isMockMode = false
    
    /// Publisher for health summary updates
    @Published var healthSummary: HealthSummary = HealthSummary()
    
    /// Request HealthKit permissions
    func requestPermissions() async -> Bool {
        #if targetEnvironment(simulator)
        isMockMode = true
        return true
        #else
        let healthKitTypes: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.categoryType(forIdentifier: .appleStandHour)!
        ]
        
        do {
            try await healthStore.requestAuthorization(toShare: nil, read: healthKitTypes)
            return true
        } catch {
            print("HealthKit authorization failed: \(error)")
            isMockMode = true
            return false
        }
        #endif
    }
    
    /// Fetch daily health summary
    func fetchDailyHealthSummary(date: Date) async throws -> HealthSummary {
        if isMockMode || !HKHealthStore.isHealthDataAvailable() {
            return mockHealthSummary(for: date)
        }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        async let energy = fetchActiveEnergyBurned(predicate: predicate)
        async let exercise = fetchExerciseTime(predicate: predicate)
        async let steps = fetchStepCount(predicate: predicate)
        async let standHours = fetchStandHours(predicate: predicate)
        
        return HealthSummary(
            date: date,
            activeEnergyBurned: try await energy,
            exerciseTime: try await exercise,
            stepCount: try await steps,
            standHours: try await standHours
        )
    }
    
    // MARK: - Private Methods
    
    private func fetchActiveEnergyBurned(predicate: NSPredicate) async throws -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            throw HealthServiceError.typeNotAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let calories = sum.doubleValue(for: HKUnit.kilocalorie())
                continuation.resume(returning: calories)
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchExerciseTime(predicate: NSPredicate) async throws -> Double {
        guard let exerciseType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
            throw HealthServiceError.typeNotAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: exerciseType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let minutes = sum.doubleValue(for: HKUnit.minute())
                continuation.resume(returning: minutes)
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchStepCount(predicate: NSPredicate) async throws -> Double {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            throw HealthServiceError.typeNotAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let result = result, let sum = result.sumQuantity() else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let steps = sum.doubleValue(for: HKUnit.count())
                continuation.resume(returning: steps)
            }
            
            healthStore.execute(query)
        }
    }
    
    private func fetchStandHours(predicate: NSPredicate) async throws -> Int {
        guard let standType = HKCategoryType.categoryType(forIdentifier: .appleStandHour) else {
            throw HealthServiceError.typeNotAvailable
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(sampleType: standType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let samples = samples as? [HKCategorySample] else {
                    continuation.resume(returning: 0)
                    return
                }
                
                let standHours = samples.count
                continuation.resume(returning: standHours)
            }
            
            healthStore.execute(query)
        }
    }
    
    /// Generate mock health summary for simulator/testing
    private func mockHealthSummary(for date: Date) -> HealthSummary {
        let random = Double.random(in: 0.8...1.2)
        return HealthSummary(
            date: date,
            activeEnergyBurned: 350 * random,
            exerciseTime: 45 * random,
            stepCount: 8500 * random,
            standHours: Int(10 * random)
        )
    }
}

/// Errors specific to HealthDataService
enum HealthServiceError: Error {
    case typeNotAvailable
    case unauthorized
    case invalidQuery
}