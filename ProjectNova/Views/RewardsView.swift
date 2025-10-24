import SwiftUI

/// View for displaying and managing rewards
struct RewardsView: View {
    @State private var earnedRewards: [RewardRule] = []
    @State private var availableRewards: [RewardRule] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Earned Rewards Section
                if !earnedRewards.isEmpty {
                    EarnedRewardsSection(rewards: earnedRewards)
                }
                
                // Available Rewards Section
                AvailableRewardsSection(rewards: availableRewards)
                
                // How Rewards Work
                HowRewardsWorkSection()
            }
            .padding()
        }
        .navigationTitle("Rewards")
        .onAppear {
            loadRewards()
        }
    }
    
    /// Load rewards data
    private func loadRewards() {
        // Mock data for demonstration
        earnedRewards = [
            RewardRule(
                name: "Early Bird",
                description: "Completed tasks before 9 AM",
                condition: .streak(days: 1),
                rewardType: .extensionTime(minutes: 15)
            ),
            RewardRule(
                name: "Fitness Enthusiast",
                description: "Exercised for 60+ minutes",
                condition: .healthGoal(metric: .exerciseMinutes, value: 60),
                rewardType: .appUnlock(bundleId: "com.apple.Music", durationMinutes: 20)
            )
        ]
        
        availableRewards = [
            RewardRule(
                name: "Productivity Master",
                description: "Complete 10 tasks in a day",
                condition: .taskCompletion(taskId: UUID()),
                rewardType: .extensionTime(minutes: 30)
            ),
            RewardRule(
                name: "Digital Balance",
                description: "Keep screen time under 2 hours",
                condition: .streak(days: 1),
                rewardType: .custom(description: "Choose your reward")
            )
        ]
    }
}

/// Section for earned rewards
struct EarnedRewardsSection: View {
    let rewards: [RewardRule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Earned Rewards")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                ForEach(rewards) { reward in
                    EarnedRewardCard(reward: reward)
                }
            }
        }
    }
}

/// Card for an earned reward
struct EarnedRewardCard: View {
    let reward: RewardRule
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(reward.name)
                    .font(.headline)
                
                Text(reward.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button("Apply") {
                // Apply reward logic
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

/// Section for available rewards
struct AvailableRewardsSection: View {
    let rewards: [RewardRule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Available Rewards")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                ForEach(rewards) { reward in
                    AvailableRewardCard(reward: reward)
                }
            }
        }
    }
}

/// Card for an available reward
struct AvailableRewardCard: View {
    let reward: RewardRule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(reward.name)
                        .font(.headline)
                    
                    Text(reward.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                RewardTypeBadge(rewardType: reward.rewardType)
            }
            
            RewardProgressView(condition: reward.condition)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

/// Badge showing reward type
struct RewardTypeBadge: View {
    let rewardType: RewardRule.RewardType
    
    var body: some View {
        switch rewardType {
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
}

/// View showing reward progress
struct RewardProgressView: View {
    let condition: RewardRule.RewardCondition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Progress")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: 0.6) // Mock progress
                .progressViewStyle(LinearProgressViewStyle())
        }
    }
}

/// Section explaining how rewards work
struct HowRewardsWorkSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("How Rewards Work")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("• Complete tasks to earn rewards")
                Text("• Rewards can unlock apps or extend focus time")
                Text("• Streaks and health goals offer special rewards")
                Text("• Apply rewards when you need them most")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

/// Preview provider
struct RewardsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RewardsView()
        }
    }
}