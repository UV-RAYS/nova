import SwiftUI

/// A view for displaying a task row
struct TaskRowView: View {
    let task: Task
    
    var body: some View {
        HStack {
            // Completion indicator
            if task.isTaskCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(task.title)
                    .font(.body)
                    .strikethrough(task.isTaskCompleted)
                
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .strikethrough(task.isTaskCompleted)
                }
                
                // Progress information
                HStack {
                    Text("\(Int(task.currentValue))/\(Int(task.targetValue)) \(task.unit.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(task.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 4)
                            .cornerRadius(2)
                        
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: CGFloat(task.progress) * geometry.size.width, height: 4)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 4)
            }
            
            Spacer()
        }
        .padding(.vertical, 1)
    }
    
    /// Color based on progress
    private var progressColor: Color {
        switch task.progress {
        case 0..<0.3:
            return .red
        case 0.3..<0.7:
            return .orange
        case 0.7..<1.0:
            return .yellow
        default:
            return .green
        }
    }
}

/// Preview provider
struct TaskRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TaskRowView(
                task: Task(
                    title: "Morning Walk",
                    description: "30-minute walk in the park",
                    targetValue: 30,
                    unit: .minutes
                )
            )
            
            TaskRowView(
                task: Task(
                    title: "Coding Practice",
                    description: "Work on SwiftUI project",
                    targetValue: 60,
                    unit: .minutes
                )
            )
            
            TaskRowView(
                task: Task(
                    title: "Read Book",
                    targetValue: 30,
                    unit: .minutes,
                    reward: RewardRule(
                        name: "Reader",
                        description: "Complete reading task",
                        condition: .taskCompletion(taskId: UUID()),
                        rewardType: .extensionTime(minutes: 15)
                    )
                )
            )
        }
        .padding()
    }
}