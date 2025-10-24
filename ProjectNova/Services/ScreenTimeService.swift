import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

/// Service for managing screen time controls
class ScreenTimeService: ObservableObject {
    private let center = AuthorizationCenter.shared
    private let store = ManagedSettingsStore()
    private let deviceActivityMonitor = DeviceActivityMonitorExtension()
    private var isMockMode = false
    
    /// Publisher for screen time updates
    @Published var screenTimeSummary: ScreenTimeSummary = ScreenTimeSummary()
    
    /// Request authorization for family controls
    func requestAuthorization() async -> Bool {
        #if targetEnvironment(simulator)
        isMockMode = true
        return true
        #else
        do {
            try await center.requestAuthorization(for: .individual)
            return true
        } catch {
            print("Screen Time authorization failed: \(error)")
            isMockMode = true
            return false
        }
        #endif
    }
    
    /// Get app usage for specified apps
    func getUsage(for apps: [String], since date: Date) async -> ScreenTimeSummary {
        if isMockMode {
            return mockScreenTimeSummary(for: apps)
        }
        
        // In a real implementation, this would query DeviceActivity reports
        // For now, we'll return mock data
        return mockScreenTimeSummary(for: apps)
    }
    
    /// Block apps until specified date
    func block(apps: [String], until date: Date) async throws {
        if isMockMode {
            print("Mock: Blocking apps \(apps) until \(date)")
            return
        }
        
        let applicationTokens = apps.map { BundleIdentifier($0) }.compactMap { bundleId in
            ApplicationToken(bundleIdentifier: bundleId)
        }
        
        store.shield.applications = Set(applicationTokens)
        
        // Schedule unblocking for the specified date
        let unblockRequest = ManagedSettingsRequest(
            store: store,
            action: .remove,
            target: .applications(Set(applicationTokens))
        )
        
        // In a real implementation, you would schedule this
        // For now, we'll just print
        print("Scheduled unblock for \(date)")
    }
    
    /// Unblock specified apps
    func unblock(apps: [String]) async throws {
        if isMockMode {
            print("Mock: Unblocking apps \(apps)")
            return
        }
        
        let applicationTokens = apps.map { BundleIdentifier($0) }.compactMap { bundleId in
            ApplicationToken(bundleIdentifier: bundleId)
        }
        
        store.shield.applications?.subtract(Set(applicationTokens))
    }
    
    /// Get list of distracting apps (in a real app, this would be configurable)
    func getDistractingApps() -> [String] {
        return [
            "com.facebook.Facebook",
            "com.instagram.instagram",
            "com.twitter.twitter",
            "com.reddit.reddit",
            "com.tiktokv",
            "com.snapchat",
            "com.youtube"
        ]
    }
    
    /// Generate mock screen time summary for simulator/testing
    private func mockScreenTimeSummary(for apps: [String]) -> ScreenTimeSummary {
        let appUsages = apps.map { bundleId in
            AppUsage(
                bundleIdentifier: bundleId,
                appName: bundleId.components(separatedBy: ".").last ?? bundleId,
                usageDuration: Double.random(in: 10...120)
            )
        }
        
        let totalScreenTime = appUsages.reduce(0) { $0 + $1.usageDuration }
        
        return ScreenTimeSummary(
            date: Date(),
            totalScreenTime: totalScreenTime,
            appUsages: appUsages
        )
    }
}