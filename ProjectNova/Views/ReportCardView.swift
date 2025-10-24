import SwiftUI

/// View for displaying a report card
struct ReportCardView: View {
    @StateObject private var viewModel: ReportViewModel
    
    init(viewModel: ReportViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                ReportHeaderView(date: viewModel.reportCard?.date ?? Date())
                
                if let report = viewModel.reportCard {
                    // Stats Overview
                    StatsOverviewView(report: report)
                    
                    // Health Summary
                    HealthSummarySectionView(healthSummary: report.healthSummary)
                    
                    // Screen Time Summary
                    ScreenTimeSectionView(screenTimeSummary: report.screenTimeSummary)
                    
                    // Tasks Summary
                    TasksSummaryView(tasksCompleted: report.tasksCompleted, tasksMissed: report.tasksMissed)
                    
                    // Focus Time
                    FocusTimeView(focusTime: report.focusTime)
                    
                    // AI Insights
                    InsightsSectionView(insights: report.insights)
                    
                    // Rewards Applied
                    if !report.rewardsApplied.isEmpty {
                        RewardsSectionView(rewards: report.rewardsApplied)
                    }
                } else {
                    // Loading or empty state
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView("Generating Report...")
                                .scaleEffect(1.5)
                        } else {
                            Text("No report available")
                                .font(.headline)
                            
                            Button("Generate Report") {
                                viewModel.generateReport()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .navigationTitle("Report Card")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("Export as JSON") {
                        // Export functionality
                    }
                    
                    Button("Export as PDF") {
                        // Export functionality
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .onAppear {
            if viewModel.reportCard == nil {
                viewModel.generateReport()
            }
        }
    }
}

/// View for the report header
struct ReportHeaderView: View {
    let date: Date
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Daily Report")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(date, style: .date)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}

/// View for stats overview
struct StatsOverviewView: View {
    let report: ReportCard
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCardView(
                title: "Tasks Done",
                value: report.tasksCompleted,
                unit: "",
                icon: "checkmark.circle.fill",
                color: .green
            )
            
            StatCardView(
                title: "Focus Time",
                value: Int(report.focusTime),
                unit: "min",
                icon: "clock.fill",
                color: .blue
            )
            
            StatCardView(
                title: "Steps",
                value: Int(report.healthSummary.stepCount),
                unit: "",
                icon: "figure.walk",
                color: .orange
            )
            
            StatCardView(
                title: "Screen Time",
                value: Int(report.screenTimeSummary.totalScreenTime),
                unit: "min",
                icon: "iphone",
                color: .purple
            )
        }
    }
}

/// View for health summary section
struct HealthSummarySectionView: View {
    let healthSummary: HealthSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Health Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatCardView(
                    title: "Calories",
                    value: Int(healthSummary.activeEnergyBurned),
                    unit: "kcal",
                    icon: "flame",
                    color: .red
                )
                
                StatCardView(
                    title: "Exercise",
                    value: Int(healthSummary.exerciseTime),
                    unit: "min",
                    icon: "sportscourt",
                    color: .green
                )
            }
        }
    }
}

/// View for screen time section
struct ScreenTimeSectionView: View {
    let screenTimeSummary: ScreenTimeSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Screen Time")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Total Screen Time")
                    Spacer()
                    Text("\(Int(screenTimeSummary.totalScreenTime)) min")
                        .fontWeight(.medium)
                }
                
                ForEach(screenTimeSummary.appUsages.prefix(5)) { appUsage in
                    HStack {
                        Text(appUsage.appName)
                        Spacer()
                        Text("\(Int(appUsage.usageDuration)) min")
                    }
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

/// View for tasks summary
struct TasksSummaryView: View {
    let tasksCompleted: Int
    let tasksMissed: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Tasks")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 30) {
                VStack(spacing: 5) {
                    Text("\(tasksCompleted)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Completed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack(spacing: 5) {
                    Text("\(tasksMissed)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Missed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

/// View for focus time
struct FocusTimeView: View {
    let focusTime: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Focus Time")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                Text("\(Int(focusTime)) minutes")
                    .font(.title2)
                    .fontWeight(.medium)
                
                Spacer()
                
                ProgressCircleView(progress: min(focusTime / 240.0, 1.0)) // Assuming 4 hours is the goal
                    .frame(width: 50, height: 50)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

/// View for AI insights section
struct InsightsSectionView: View {
    let insights: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("AI Insights")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(insights)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
    }
}

/// View for rewards section
struct RewardsSectionView: View {
    let rewards: [RewardRule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Rewards Earned")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                ForEach(rewards) { reward in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(reward.name)
                                .font(.body)
                                .fontWeight(.medium)
                            Text(reward.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        switch reward.rewardType {
                        case .appUnlock(_, let duration):
                            Text("\(Int(duration)) min")
                                .font(.caption)
                                .padding(5)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        case .extensionTime(let minutes):
                            Text("+\(Int(minutes)) min")
                                .font(.caption)
                                .padding(5)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        case .custom:
                            Text("Custom")
                                .font(.caption)
                                .padding(5)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
            }
        }
    }
}

/// Preview provider
struct ReportCardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ReportCardView(viewModel: ReportViewModel(
                reportService: ReportService(
                    healthService: HealthDataService(),
                    screenTimeService: ScreenTimeService(),
                    aiInsightsService: AIInsightsService()
                )
            ))
        }
    }
}