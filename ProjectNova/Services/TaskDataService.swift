import Foundation
import CoreData
import Combine

/// Service for managing tasks with CoreData persistence
class TaskDataService: ObservableObject {
    private var moc: NSManagedObjectContext
    private var mockDataLoaded = false
    
    /// Publisher for tasks updates
    @Published var tasks: [Task] = []
    
    init(context: NSManagedObjectContext) {
        self.moc = context
        loadTasks()
    }
    
    /// Load tasks from CoreData
    private func loadTasks() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        do {
            let result = try moc.fetch(request) as! [TaskEntity]
            self.tasks = result.map { entity in
                Task(
                    title: entity.title ?? "",
                    description: entity.taskDescription ?? "",
                    targetValue: entity.targetValue,
                    unit: Task.TaskUnit(rawValue: entity.unit ?? "minutes") ?? .minutes,
                    reward: nil, // In a full implementation, you would load the reward
                    createdAt: entity.createdAt ?? Date()
                )
            }
        } catch {
            print("Failed to load tasks: \(error)")
            // Load mock data if CoreData fails
            loadMockData()
        }
    }
    
    /// Create a new task
    func createTask(_ task: Task) {
        let taskEntity = TaskEntity(context: moc)
        taskEntity.id = task.id
        taskEntity.title = task.title
        taskEntity.taskDescription = task.description
        taskEntity.isCompleted = task.isCompleted
        taskEntity.targetValue = task.targetValue
        taskEntity.currentValue = task.currentValue
        taskEntity.unit = task.unit.rawValue
        taskEntity.createdAt = task.createdAt
        taskEntity.completedAt = task.completedAt
        
        saveContext()
        loadTasks()
    }
    
    /// Update an existing task
    func updateTask(_ task: Task) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)
        
        do {
            let result = try moc.fetch(request) as! [TaskEntity]
            if let taskEntity = result.first {
                taskEntity.title = task.title
                taskEntity.taskDescription = task.description
                taskEntity.isCompleted = task.isCompleted
                taskEntity.targetValue = task.targetValue
                taskEntity.currentValue = task.currentValue
                taskEntity.unit = task.unit.rawValue
                taskEntity.completedAt = task.completedAt
                
                saveContext()
                loadTasks()
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    /// Delete a task
    func deleteTask(_ task: Task) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        request.predicate = NSPredicate(format: "id == %@", task.id.uuidString)
        
        do {
            let result = try moc.fetch(request) as! [TaskEntity]
            for taskEntity in result {
                moc.delete(taskEntity)
            }
            saveContext()
            loadTasks()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
    
    /// Mark task as completed
    func completeTask(_ task: Task) {
        var updatedTask = task
        updatedTask.isCompleted = true
        updatedTask.completedAt = Date()
        updatedTask.currentValue = updatedTask.targetValue
        updateTask(updatedTask)
    }
    
    /// Update task progress
    func updateTaskProgress(_ task: Task, progress: Double) {
        var updatedTask = task
        updatedTask.currentValue = progress
        if progress >= task.targetValue {
            updatedTask.isCompleted = true
            updatedTask.completedAt = Date()
        }
        updateTask(updatedTask)
    }
    
    /// Load mock data for testing/simulator
    func loadMockData() {
        guard !mockDataLoaded else { return }
        
        let mockTasks = [
            Task(title: "Morning Walk", description: "30-minute walk", targetValue: 30, unit: .minutes),
            Task(title: "Coding Practice", description: "Practice Swift for 1 hour", targetValue: 60, unit: .minutes),
            Task(title: "Drink Water", description: "8 glasses of water", targetValue: 8, unit: .count),
            Task(title: "Steps Goal", description: "Reach 10,000 steps", targetValue: 10000, unit: .steps)
        ]
        
        for task in mockTasks {
            createTask(task)
        }
        
        mockDataLoaded = true
    }
    
    /// Save context to CoreData
    private func saveContext() {
        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                print("Save failed: \(error)")
            }
        }
    }
}