import Foundation
import Combine

/// ViewModel for the timer view
class TimerViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var selectedTask: Task?
    
    private let timerService: TimerService
    private let taskService: TaskDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(timerService: TimerService, taskService: TaskDataService) {
        self.timerService = timerService
        self.taskService = taskService
        
        setupBindings()
    }
    
    /// Set up bindings between timer service and published properties
    private func setupBindings() {
        timerService.$elapsedTime
            .sink { [weak self] time in
                self?.elapsedTime = time
            }
            .store(in: &cancellables)
        
        timerService.$isRunning
            .sink { [weak self] running in
                self?.isRunning = running
            }
            .store(in: &cancellables)
        
        timerService.$isPaused
            .sink { [weak self] paused in
                self?.isPaused = paused
            }
            .store(in: &cancellables)
    }
    
    /// Start the timer
    func start() {
        timerService.start()
    }
    
    /// Pause the timer
    func pause() {
        timerService.pause()
    }
    
    /// Resume the timer
    func resume() {
        timerService.resume()
    }
    
    /// Stop the timer
    func stop() {
        timerService.stop()
    }
    
    /// Format elapsed time as MM:SS
    func formattedTime() -> String {
        return timerService.formattedTime(elapsedTime)
    }
    
    /// Format elapsed time as HH:MM:SS
    func formattedTimeHours() -> String {
        return timerService.formattedTimeHours(elapsedTime)
    }
    
    /// Assign elapsed time to selected task
    func assignToTask() {
        guard let task = selectedTask else { return }
        
        // Convert elapsed time to minutes
        let minutes = elapsedTime / 60
        
        // Update task progress
        var updatedTask = task
        updatedTask.currentValue = minutes
        
        if minutes >= task.targetValue {
            updatedTask.isCompleted = true
            updatedTask.completedAt = Date()
        }
        
        taskService.updateTask(updatedTask)
    }
}