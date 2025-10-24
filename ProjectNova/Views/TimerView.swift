import SwiftUI

/// View for the timer functionality
struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    
    init(viewModel: TimerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Timer Display
            TimerDisplayView(timeString: viewModel.formattedTimeHours())
            
            // Task Selection
            if let selectedTask = viewModel.selectedTask {
                SelectedTaskView(task: selectedTask)
            } else {
                TaskSelectionView { task in
                    viewModel.selectedTask = task
                }
            }
            
            // Control Buttons
            TimerControlsView(
                isRunning: viewModel.isRunning,
                isPaused: viewModel.isPaused,
                onStart: viewModel.start,
                onPause: viewModel.pause,
                onResume: viewModel.resume,
                onStop: viewModel.stop,
                onAssign: viewModel.assignToTask
            )
            
            Spacer()
        }
        .padding()
        .navigationTitle("Timer")
    }
}

/// View for displaying the timer
struct TimerDisplayView: View {
    let timeString: String
    
    var body: some View {
        Text(timeString)
            .font(.system(size: 48, weight: .light, design: .monospaced))
            .foregroundColor(.primary)
            .padding()
            .overlay(
                Circle()
                    .strokeBorder(Color.blue.opacity(0.2), lineWidth: 2)
            )
    }
}

/// View for showing the selected task
struct SelectedTaskView: View {
    let task: Task
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Logging to:")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(task.title)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

/// View for selecting a task
struct TaskSelectionView: View {
    let onSelect: (Task) -> Void
    
    // In a real implementation, this would come from a task service
    private let mockTasks = [
        Task(title: "Morning Walk", targetValue: 30, unit: .minutes),
        Task(title: "Coding Practice", targetValue: 60, unit: .minutes),
        Task(title: "Reading", targetValue: 30, unit: .minutes)
    ]
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Select a task to log time")
                .font(.headline)
            
            ForEach(mockTasks) { task in
                Button(action: {
                    onSelect(task)
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.body)
                            Text("\(Int(task.currentValue))/\(Int(task.targetValue)) \(task.unit.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        ProgressCircleView(progress: task.progress)
                            .frame(width: 30, height: 30)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
            }
        }
    }
}

/// View for timer control buttons
struct TimerControlsView: View {
    let isRunning: Bool
    let isPaused: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onStop: () -> Void
    let onAssign: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            if isRunning {
                Button(action: onPause) {
                    ControlButton(title: "Pause", icon: "pause.fill", color: .orange)
                }
                
                Button(action: onStop) {
                    ControlButton(title: "Stop", icon: "stop.fill", color: .red)
                }
            } else if isPaused {
                Button(action: onResume) {
                    ControlButton(title: "Resume", icon: "play.fill", color: .green)
                }
                
                Button(action: onAssign) {
                    ControlButton(title: "Assign", icon: "checkmark.circle.fill", color: .blue)
                }
            } else {
                Button(action: onStart) {
                    ControlButton(title: "Start", icon: "play.fill", color: .green)
                }
            }
        }
    }
}

/// Reusable control button
struct ControlButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

/// Preview provider
struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TimerView(viewModel: TimerViewModel(
                timerService: TimerService(),
                taskService: TaskDataService(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
            ))
        }
    }
}