import SwiftUI

/// View for controlling screen time and app blocking
struct ScreenTimeControlView: View {
    @StateObject private var viewModel: ScreenTimeViewModel
    @State private var showingBlockSheet = false
    @State private var selectedApps: Set<String> = []
    @State private var blockDuration = 30.0 // minutes
    
    init(viewModel: ScreenTimeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            // Status Header
            StatusHeaderView(isMockMode: true) // In a real app, this would check actual mode
            
            // Distracting Apps List
            List {
                ForEach(viewModel.distractingApps, id: \.self) { bundleId in
                    AppRowView(
                        bundleId: bundleId,
                        isBlocked: viewModel.isAppBlocked(bundleId),
                        isSelected: selectedApps.contains(bundleId)
                    ) {
                        toggleAppSelection(bundleId)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .refreshable {
                viewModel.loadScreenTimeData()
            }
            
            // Action Buttons
            VStack(spacing: 15) {
                Button(action: {
                    showingBlockSheet = true
                }) {
                    Text("Block Selected Apps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedApps.isEmpty ? Color.gray : Color.red)
                        .cornerRadius(10)
                }
                .disabled(selectedApps.isEmpty)
                
                Button("Unblock All") {
                    Task {
                        await viewModel.unblockApps(Array(viewModel.blockedApps))
                    }
                }
                .font(.headline)
                .foregroundColor(.blue)
            }
            .padding()
        }
        .navigationTitle("Focus Mode")
        .sheet(isPresented: $showingBlockSheet) {
            BlockDurationSheet(
                duration: $blockDuration,
                onBlock: blockSelectedApps
            )
        }
        .onAppear {
            viewModel.loadScreenTimeData()
        }
    }
    
    /// Toggle app selection
    private func toggleAppSelection(_ bundleId: String) {
        if selectedApps.contains(bundleId) {
            selectedApps.remove(bundleId)
        } else {
            selectedApps.insert(bundleId)
        }
    }
    
    /// Block selected apps
    private func blockSelectedApps() {
        Task {
            await viewModel.blockApps(Array(selectedApps), for: blockDuration)
            selectedApps.removeAll()
            showingBlockSheet = false
        }
    }
}

/// View for status header
struct StatusHeaderView: View {
    let isMockMode: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: isMockMode ? "testtube.2" : "checkmark.shield")
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text(isMockMode ? "Mock Mode" : "Screen Time Active")
                        .font(.headline)
                    Text(isMockMode ? "Using simulated data" : "Real-time monitoring enabled")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

/// View for an app row
struct AppRowView: View {
    let bundleId: String
    let isBlocked: Bool
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            // App Icon (placeholder)
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue)
                .frame(width: 40, height: 40)
                .overlay(
                    Text(String(bundleId.prefix(1).uppercased()))
                        .foregroundColor(.white)
                        .font(.headline)
                )
            
            VStack(alignment: .leading) {
                Text(bundleId.components(separatedBy: ".").last ?? bundleId)
                    .font(.body)
                Text(bundleId)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isBlocked {
                Text("Blocked")
                    .font(.caption)
                    .padding(5)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

/// Sheet for selecting block duration
struct BlockDurationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var duration: Double
    let onBlock: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("Block Duration")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 20) {
                    Text("\(Int(duration)) minutes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Slider(
                        value: $duration,
                        in: 10...240,
                        step: 10
                    ) {
                        Text("Duration")
                    }
                    .padding(.horizontal)
                }
                
                Button("Block Apps") {
                    onBlock()
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

/// Preview provider
struct ScreenTimeControlView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ScreenTimeControlView(viewModel: ScreenTimeViewModel(
                screenTimeService: ScreenTimeService()
            ))
        }
    }
}