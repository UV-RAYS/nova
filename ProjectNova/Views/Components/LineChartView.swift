import SwiftUI

/// A minimal line chart view
struct LineChartView: View {
    let data: [ChartData]
    let xAxisLabels: [String]
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Chart area
                ZStack(alignment: .bottomLeading) {
                    // Grid lines
                    GridLines(
                        frame: geometry.frame(in: .local),
                        data: data
                    )
                    
                    // Line path
                    LinePath(
                        data: data,
                        frame: geometry.frame(in: .local)
                    )
                }
                .frame(height: geometry.size.height - 30)
                
                // X-axis labels
                HStack {
                    ForEach(xAxisLabels.indices, id: \.self) { index in
                        Text(xAxisLabels[index])
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .frame(height: 30)
            }
        }
        .aspectRatio(2, contentMode: .fit)
    }
}

/// Data model for chart points
struct ChartData: Identifiable {
    let id = UUID()
    let value: Double
}

/// View for drawing grid lines
struct GridLines: View {
    let frame: CGRect
    let data: [ChartData]
    
    var body: some View {
        ZStack {
            // Horizontal grid lines
            ForEach(0..<5) { index in
                Path { path in
                    let y = frame.height - CGFloat(index) * (frame.height / 4)
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: frame.width, y: y))
                }
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

/// View for drawing the line path
struct LinePath: View {
    let data: [ChartData]
    let frame: CGRect
    
    var body: some View {
        Path { path in
            guard !data.isEmpty else { return }
            
            let maxValue = data.map { $0.value }.max() ?? 1
            let minValue = data.map { $0.value }.min() ?? 0
            let valueRange = max(maxValue - minValue, 1)
            
            let pointSpacing = frame.width / CGFloat(data.count - 1)
            
            for (index, point) in data.enumerated() {
                let x = CGFloat(index) * pointSpacing
                let y = frame.height - CGFloat((point.value - minValue) / valueRange) * frame.height
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(Color.blue, lineWidth: 2)
    }
}

/// Preview provider
struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        LineChartView(
            data: [
                ChartData(value: 10),
                ChartData(value: 25),
                ChartData(value: 40),
                ChartData(value: 30),
                ChartData(value: 50),
                ChartData(value: 45),
                ChartData(value: 60)
            ],
            xAxisLabels: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        )
        .padding()
    }
}