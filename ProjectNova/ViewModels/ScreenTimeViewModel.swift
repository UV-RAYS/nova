import Foundation
import Combine

/// ViewModel for the screen time view
class ScreenTimeViewModel: ObservableObject {
    @Published var screenTimeSummary: ScreenTimeSummary = ScreenTimeSummary()
    @Published var distractingApps: [String] = []
    @Published var blockedApps: [String] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let screenTimeService: ScreenTimeService
    private var cancellables = Set<AnyCancellable>()
    
    init(screenTimeService: ScreenTimeService) {
        self.screenTimeService = screenTimeService
        self.distractingApps = screenTimeService.getDistractingApps()
        
        setupBindings()
    }
    
    /// Set up bindings between screen time service and published properties
    private func setupBindings() {
        screenTimeService.$screenTimeSummary
            .sink { [weak self] summary in
                self?.screenTimeSummary = summary
            }
            .store(in: &cancellables)
    }
    
    /// Load screen time data
    func loadScreenTimeData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            let summary = await screenTimeService.getUsage(for: distractingApps, since: Date().addingTimeInterval(-86400)) // Last 24 hours
            
            DispatchQueue.main.async {
                self.screenTimeSummary = summary
                self.isLoading = false
            }
        }
    }
    
    /// Block selected apps
    func blockApps(_ apps: [String], for minutes: Double) async {
        isLoading = true
        errorMessage = nil
        
        let unblockDate = Date().addingTimeInterval(minutes * 60)
        
        do {
            try await screenTimeService.block(apps: apps, until: unblockDate)
            blockedApps.append(contentsOf: apps)
            
            // Remove duplicates
            blockedApps = Array(Set(blockedApps))
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to block apps: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Unblock selected apps
    func unblockApps(_ apps: [String]) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await screenTimeService.unblock(apps: apps)
            
            // Remove from blocked apps list
            blockedApps.removeAll { apps.contains($0) }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to unblock apps: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    /// Check if an app is currently blocked
    func isAppBlocked(_ bundleId: String) -> Bool {
        return blockedApps.contains(bundleId)
    }
}