import Foundation
import Combine

/// Service for managing the timer functionality
class TimerService: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isRunning = false
    @Published var isPaused = false
    
    private var timer: Timer?
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    
    /// Start the timer
    func start() {
        guard !isRunning else { return }
        
        startTime = Date().addingTimeInterval(-pausedTime)
        isRunning = true
        isPaused = false
        pausedTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    /// Pause the timer
    func pause() {
        guard isRunning, !isPaused else { return }
        
        timer?.invalidate()
        timer = nil
        isPaused = true
        pausedTime = elapsedTime
    }
    
    /// Resume the timer
    func resume() {
        guard isPaused else { return }
        
        start()
    }
    
    /// Stop the timer
    func stop() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        elapsedTime = 0
        pausedTime = 0
        startTime = nil
    }
    
    /// Format time interval as MM:SS
    func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// Format time interval as HH:MM:SS
    func formattedTimeHours(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}