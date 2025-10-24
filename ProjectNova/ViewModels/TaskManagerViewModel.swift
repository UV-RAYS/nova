import Foundation
import Combine

/// ViewModel for the task manager view
class TaskManagerViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isEditing = false
    @Published var selectedTask: Task?
    
    private let taskService: TaskDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(taskService: TaskDataService) {
        self.taskService = taskService
        self.tasks = taskService.tasks
        
        taskService.$tasks
            .sink { [weak self] tasks in
                self?.tasks = tasks
            }
            .store(in: &cancellables)
    }
    
    /// Add a new task
    func addTask(_ task: Task) {
        taskService.createTask(task)
    }
    
    /// Update an existing task
    func updateTask(_ task: Task) {
        taskService.updateTask(task)
    }
    
    /// Delete a task
    func deleteTask(_ task: Task) {
        taskService.deleteTask(task)
    }
    
    /// Mark task as completed
    func completeTask(_ task: Task) {
        taskService.completeTask(task)
    }
    
    /// Update task progress
    func updateTaskProgress(_ task: Task, progress: Double) {
        taskService.updateTaskProgress(task, progress: progress)
    }
    
    /// Begin editing a task
    func beginEditing(_ task: Task) {
        selectedTask = task
        isEditing = true
    }
    
    /// Finish editing a task
    func finishEditing() {
        isEditing = false
        selectedTask = nil
    }
}