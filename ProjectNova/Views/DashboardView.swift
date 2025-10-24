import SwiftUI

/// Main dashboard view showing health summary, tasks, and quick actions
struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Health Summary Section
                    HealthSummaryView(healthSummary: viewModel.healthSummary)
                    
                    // Quick Actions
                    QuickActionsView(viewModel: viewModel)
                    
                    // Today's Tasks
                    TasksSectionView(tasks: viewModel.tasks)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}

/// View for displaying health summary
struct HealthSummaryView: View {
    let healthSummary: HealthSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Today's Health")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatCardView(
                    title: "Steps",
                    value: Int(healthSummary.stepCount),
                    unit: "",
                    icon: "figure.walk",
                    color: .blue
                )
                
                StatCardView(
                    title: "Calories",
                    value: Int(healthSummary.activeEnergyBurned),
                    unit: "kcal",
                    icon: "flame",
                    color: .orange
                )
                
                StatCardView(
                    title: "Exercise",
                    value: Int(healthSummary.exerciseTime),
                    unit: "min",
                    icon: "sportscourt",
                    color: .green
                )
                
                StatCardView(
                    title: "Stand Hours",
                    value: healthSummary.standHours,
                    unit: "",
                    icon: "person.crop.rectangle.stack",
                    color: .purple
                )
            }
        }
    }
}

/// View for quick action buttons
struct QuickActionsView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 15) {
                NavigationLink(destination: TaskManagerView()) {
                    ActionButton(title: "Tasks", icon: "checklist")
                }
                
                NavigationLink(destination: TimerView()) {
                    ActionButton(title: "Timer", icon: viewModel.isTimerRunning ? "stopwatch.fill" : "stopwatch")
                }
                
                NavigationLink(destination: ScreenTimeControlView()) {
                    ActionButton(title: "Focus", icon: "app.badge.checkmark")
                }
            }
        }
    }
}

/// Reusable action button
struct ActionButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
    }
}

/// View for tasks section
struct TasksSectionView: View {
    let tasks: [Task]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Today's Tasks")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink("See All") {
                    TaskManagerView()
                }
                .font(.caption)
            }
            
            if tasks.isEmpty {
                EmptyTasksView()
            } else {
                VStack(spacing: 10) {
                    ForEach(tasks.prefix(3)) { task in
                        TaskRowView(task: task)
                    }
                }
            }
        }
    }
}

/// View for empty tasks state
struct EmptyTasksView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle")
                .font(.largeTitle)
                .foregroundColor(.gray)
            
            Text("No tasks yet")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            NavigationLink("Create Task") {
                TaskManagerView()
            }
            .font(.subheadline)
            .foregroundColor(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

/// Preview provider
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(viewModel: DashboardViewModel(
            healthService: HealthDataService(),
            taskService: TaskDataService(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)),
            timerService: TimerService()
        ))
    }
}