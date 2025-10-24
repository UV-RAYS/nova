import SwiftUI

/// A card view for displaying a statistic
struct StatCardView: View {
    let title: String
    let value: Int
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !unit.isEmpty {
                        Text(unit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}

/// Preview provider
struct StatCardView_Previews: PreviewProvider {
    static var previews: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCardView(
                title: "Steps",
                value: 8500,
                unit: "",
                icon: "figure.walk",
                color: .blue
            )
            
            StatCardView(
                title: "Calories",
                value: 420,
                unit: "kcal",
                icon: "flame",
                color: .orange
            )
        }
        .padding()
    }
}