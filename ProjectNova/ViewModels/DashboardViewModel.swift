import Foundation
import Combine
import CoreData

/// ViewModel for the dashboard view
class DashboardViewModel: ObservableObject {
    @Published var healthSummary: HealthSummary = HealthSummary()
    @Published var tasks: [Task] = []
    @Published var elapsedTime: TimeInterval = 0
    @Published var isTimerRunning = false
    
    private let healthService: HealthDataService
    private let taskService: TaskDataService
    private let timerService: TimerService
    private var cancellables = Set<AnyCancellable>()
    
    init(healthService: HealthDataService, taskService: TaskDataService, timerService: TimerService) {
        self.healthService = healthService
        self.taskService = taskService
        self.timerService = timerService
        
        setupBindings()
        loadData()
    }
    
    /// Set up bindings between services and published properties
    private func setupBindings() {
        healthService.$healthSummary
            .sink { [weak self] summary in
                self?.healthSummary = summary
            }
            .store(in: &cancellables)
        
        timerService.$elapsedTime
            .sink { [weak self] time in
                self?.elapsedTime = time
            }
            .store(in: &cancellables)
        
        timerService.$isRunning
            .sink { [weak self] isRunning in
                self?.isTimerRunning = isRunning
            }
            .store(in: &cancellables)
    }
    
    /// Load initial data
    private func loadData() {
        Task {
            do {
                let today = Date()
                let summary = try await healthService.fetchDailyHealthSummary(date: today)
                DispatchQueue.main.async {
                    self.healthSummary = summary
                }
            } catch {
                print("Failed to load health data: \(error)")
            }
        }
    }
    
    /// Refresh health data
    func refreshHealthData() {
        Task {
            do {
                let today = Date()
                let summary = try await healthService.fetchDailyHealthSummary(date: today)
                DispatchQueue.main.async {
                    self.healthSummary = summary
                }
            } catch {
                print("Failed to refresh health data: \(error)")
            }
        }
    }
    
    /// Start the timer
    func startTimer() {
        timerService.start()
    }
    
    /// Pause the timer
    func pauseTimer() {
        timerService.pause()
    }
    
    /// Stop the timer
    func stopTimer() {
        timerService.stop()
    }
}