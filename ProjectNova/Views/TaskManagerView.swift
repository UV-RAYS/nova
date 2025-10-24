import SwiftUI

/// View for managing tasks
struct TaskManagerView: View {
    @StateObject private var viewModel: TaskManagerViewModel
    @State private var showingAddTask = false
    @State private var showingEditTask = false
    
    init(viewModel: TaskManagerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.tasks) { task in
                    TaskRowView(task: task)
                        .swipeActions(edge: .trailing) {
                            Button("Delete") {
                                viewModel.deleteTask(task)
                            }
                            .tint(.red)
                            
                            Button("Edit") {
                                viewModel.beginEditing(task)
                                showingEditTask = true
                            }
                            .tint(.blue)
                        }
                        .onTapGesture {
                            // Toggle task completion
                            if task.isTaskCompleted {
                                // In a real app, you might want to uncomplete tasks
                            } else {
                                viewModel.completeTask(task)
                            }
                        }
                }
                .onDelete(perform: deleteTasks)
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                // Refresh tasks if needed
            }
        }
        .navigationTitle("Tasks")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddTask = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTask) {
            TaskEditView(task: nil) { newTask in
                viewModel.addTask(newTask)
            }
        }
        .sheet(isPresented: $showingEditTask) {
            if let task = viewModel.selectedTask {
                TaskEditView(task: task) { updatedTask in
                    viewModel.updateTask(updatedTask)
                    viewModel.finishEditing()
                }
            }
        }
    }
    
    /// Delete tasks at specified offsets
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            let task = viewModel.tasks[index]
            viewModel.deleteTask(task)
        }
    }
}

/// View for editing or creating a task
struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    var task: Task?
    var onSave: (Task) -> Void
    
    @State private var title = ""
    @State private var description = ""
    @State private var targetValue = 30.0
    @State private var unit: Task.TaskUnit = .minutes
    @State private var selectedReward: RewardRule?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Task Details") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section("Goal") {
                    HStack {
                        Text("Target")
                        Spacer()
                        TextField("Value", value: $targetValue, formatter: NumberFormatter())
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                    
                    Picker("Unit", selection: $unit) {
                        ForEach(Task.TaskUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue.capitalized)
                        }
                    }
                }
                
                Section("Reward (Optional)") {
                    // In a full implementation, this would allow selecting a reward
                    Text("Select Reward")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(task == nil ? "New Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
            .onAppear {
                if let task = task {
                    title = task.title
                    description = task.description
                    targetValue = task.targetValue
                    unit = task.unit
                    // selectedReward = task.reward
                }
            }
        }
    }
    
    /// Save the task
    private func saveTask() {
        let newTask = Task(
            title: title,
            description: description,
            targetValue: targetValue,
            unit: unit,
            reward: selectedReward
        )
        
        onSave(newTask)
        dismiss()
    }
}

/// Preview provider
struct TaskManagerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskManagerView(viewModel: TaskManagerViewModel(
                taskService: TaskDataService(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
            ))
        }
    }
}