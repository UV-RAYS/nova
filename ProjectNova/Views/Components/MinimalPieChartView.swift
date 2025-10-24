import SwiftUI

/// A minimal pie chart view
struct MinimalPieChartView: View {
    let data: [PieChartData]
    let lineWidth: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(
                    Color.gray.opacity(0.3),
                    lineWidth: lineWidth
                )
            
            // Data segments
            ForEach(Array(data.enumerated()), id: \.element.id) { index, segment in
                PieChartSegment(
                    data: segment,
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    lineWidth: lineWidth
                )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// Calculate start angle for a segment
    private func startAngle(for index: Int) -> Angle {
        let previousSegments = data.prefix(index)
        let totalValue = data.reduce(0) { $0 + $1.value }
        let startValue = previousSegments.reduce(0) { $0 + $1.value }
        
        return .degrees(totalValue > 0 ? (startValue / totalValue) * 360 : 0)
    }
    
    /// Calculate end angle for a segment
    private func endAngle(for index: Int) -> Angle {
        let totalValue = data.reduce(0) { $0 + $1.value }
        let segmentValue = data[index].value
        
        return .degrees(totalValue > 0 ? (segmentValue / totalValue) * 360 : 0)
    }
}

/// Data model for pie chart segments
struct PieChartData: Identifiable {
    let id = UUID()
    let value: Double
    let color: Color
    let label: String
}

/// A single segment of the pie chart
struct PieChartSegment: View {
    let data: PieChartData
    let startAngle: Angle
    let endAngle: Angle
    let lineWidth: CGFloat
    
    var body: some View {
        Circle()
            .trim(from: startFraction, to: endFraction)
            .stroke(
                data.color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .butt
                )
            )
            .rotationEffect(startAngle - .degrees(90))
    }
    
    private var startFraction: CGFloat {
        CGFloat(startAngle.degrees / 360)
    }
    
    private var endFraction: CGFloat {
        CGFloat((startAngle + endAngle).degrees / 360)
    }
}

/// Preview provider
struct MinimalPieChartView_Previews: PreviewProvider {
    static var previews: some View {
        MinimalPieChartView(
            data: [
                PieChartData(value: 30, color: .blue, label: "Work"),
                PieChartData(value: 25, color: .green, label: "Exercise"),
                PieChartData(value: 20, color: .orange, label: "Leisure"),
                PieChartData(value: 15, color: .red, label: "Social"),
                PieChartData(value: 10, color: .purple, label: "Other")
            ]
        )
        .frame(height: 200)
        .padding()
    }
}