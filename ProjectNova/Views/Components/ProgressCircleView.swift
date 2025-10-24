import SwiftUI

/// A circular progress view
struct ProgressCircleView: View {
    let progress: Double // Value between 0.0 and 1.0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: 3
                )
            
            // Progress circle
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    progressColor,
                    style: StrokeStyle(
                        lineWidth: 3,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
        }
    }
    
    /// Color based on progress
    private var progressColor: Color {
        switch progress {
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
struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ProgressCircleView(progress: 0.2)
                .frame(width: 50, height: 50)
            
            ProgressCircleView(progress: 0.5)
                .frame(width: 50, height: 50)
            
            ProgressCircleView(progress: 0.8)
                .frame(width: 50, height: 50)
            
            ProgressCircleView(progress: 1.0)
                .frame(width: 50, height: 50)
        }
        .padding()
    }
}