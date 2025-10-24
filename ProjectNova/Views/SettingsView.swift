import SwiftUI

/// View for app settings
struct SettingsView: View {
    @State private var isMockMode = true
    @State private var isLocalAuthEnabled = false
    @State private var reportTime = Date()
    
    var body: some View {
        NavigationView {
            Form {
                // General Section
                Section("General") {
                    Toggle("Mock Mode", isOn: $isMockMode)
                        .onChange(of: isMockMode) { _ in
                            // Handle mock mode toggle
                        }
                    
                    Toggle("Local Authentication", isOn: $isLocalAuthEnabled)
                        .onChange(of: isLocalAuthEnabled) { _ in
                            // Handle local auth toggle
                        }
                }
                
                // HealthKit Section
                Section("HealthKit") {
                    Button("Request HealthKit Permissions") {
                        // Request HealthKit permissions
                    }
                    
                    Text("HealthKit permissions are required to access your health and activity data.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Screen Time Section
                Section("Screen Time") {
                    Button("Request Screen Time Permissions") {
                        // Request Screen Time permissions
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Screen Time permissions are required for app blocking features.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("Note: Full Screen Time controls require a supervised device.")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                
                // Reports Section
                Section("Reports") {
                    DatePicker("Report Time", selection: $reportTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.compact)
                    
                    Text("Nightly reports will be generated at this time.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // About Section
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("Privacy Policy", destination: URL(string: "https://example.com/privacy")!)
                    
                    Link("Terms of Service", destination: URL(string: "https://example.com/terms")!)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

/// Preview provider
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}