# Project Nova

A full-featured iOS app combining Apple Watch HealthKit data, internal task/goal system, built-in timer, screen time control & reward unlocks, and AI insights.

## Features
- HealthKit integration for fitness data
- Screen time monitoring and control
- Task management with rewards system
- Data visualization with charts
- Nightly reports with AI insights
- Built-in timer with Pomodoro support

## Requirements
- Xcode 15+
- iOS 16.0+
- Apple Watch (for HealthKit data)
- Supervised device (for full Screen Time controls)

## Setup Instructions

1. Open `ProjectNova.xcodeproj` in Xcode
2. Select your development team in project settings
3. Enable the following capabilities:
   - HealthKit
   - Family Controls
   - Background Modes (if needed)
4. Build and run on simulator or device

## Entitlements Required

Add these entitlements in your app's entitlements file:

```
<key>com.apple.developer.healthkit</key>
<true/>
<key>com.apple.developer.family-controls</key>
<true/>
```

## Running in Simulator

To run in simulator with mock data:
1. Go to Settings in the app
2. Enable "Mock Mode"
3. The app will use simulated HealthKit and Screen Time data

## Archiving and Exporting .ipa

1. In Xcode, go to Product > Archive
2. Select the archive and click "Distribute App"
3. Choose "Development" or "Ad Hoc" distribution
4. Export the .ipa file
5. Use Sideloadly to install on your device

## Note on Provisioning

When using a free Apple ID, provisioning profiles expire after 7 days. For longer testing periods, enroll in the Apple Developer Program.

## CoreML Integration

To use CoreML for advanced AI insights:

1. Add your .mlmodel file to the project
2. In AIInsightsService.swift, uncomment and implement the CoreML loading code
3. Follow Apple's guidelines for converting models to CoreML format

## Assumptions

- Some Screen Time APIs require entitlements or supervised-device status; therefore emulator uses mock. App should degrade gracefully.
- No cloud services enabled by default (offline-first). Firebase / iCloud hooks included as commented code for future.
- User will finalize signing/entitlements on a macOS environment for `.ipa` export.

## Project Structure

```
ProjectNova/
├── App/
│   └── ProjectNovaApp.swift
├── Models/
│   ├── Task.swift
│   ├── HealthSummary.swift
│   ├── ReportCard.swift
│   └── RewardRule.swift
├── ViewModels/
│   ├── DashboardViewModel.swift
│   ├── TaskManagerViewModel.swift
│   ├── TimerViewModel.swift
│   ├── ReportViewModel.swift
│   └── ScreenTimeViewModel.swift
├── Views/
│   ├── DashboardView.swift
│   ├── TaskManagerView.swift
│   ├── TimerView.swift
│   ├── ReportCardView.swift
│   ├── ScreenTimeControlView.swift
│   ├── RewardsView.swift
│   └── Components/
│       ├── ProgressCircleView.swift
│       ├── StatCardView.swift
│       ├── TaskRowView.swift
│       ├── MinimalPieChartView.swift
│       └── LineChartView.swift
├── Services/
│   ├── HealthDataService.swift
│   ├── ScreenTimeService.swift
│   ├── TaskDataService.swift
│   ├── TimerService.swift
│   ├── NotificationService.swift
│   ├── ReportService.swift
│   ├── RewardEngine.swift
│   └── AIInsightsService.swift
├── Resources/
│   ├── Assets.xcassets
│   └── Config/
│       └── sample-data.json
├── Tests/
│   ├── UnitTests/
│   └── UITests/
└── README.md
```

## Testing

The project includes both unit tests and UI tests:

- Unit tests cover core logic like task management, reward evaluation, and data services
- UI tests verify key user flows like task creation and timer functionality

To run tests in Xcode:
1. Select the ProjectNova target
2. Go to Product > Test

## Data Privacy

All data is stored locally on the device. No data is transmitted to external servers. Users can export their data as JSON if needed.