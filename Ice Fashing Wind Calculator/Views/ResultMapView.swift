import SwiftUI

struct ResultMapView: View {
    @ObservedObject var viewModel: AppViewModel
    @Binding var selectedTab: Int
    @State private var showShapeSelector = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Feeding Zones")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Based on wind from \(viewModel.selectedWindDirection.displayName)")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                }
                .padding(.top, 20)
                
                // Water body map with zones
                VStack(spacing: 16) {
                    WaterBodyView(
                        shape: viewModel.selectedWaterBodyShape,
                        windDirection: viewModel.selectedWindDirection,
                        windStrength: viewModel.selectedWindStrength,
                        showZones: true
                    )
                    .frame(height: 250)
                    .padding(.horizontal, 20)
                    
                    // Legend
                    ZoneLegend()
                        .padding(.horizontal, 20)
                }
                
                // Shape selector button
                Button(action: { showShapeSelector = true }) {
                    HStack {
                        ShapeIcon(shape: viewModel.selectedWaterBodyShape)
                            .frame(width: 24, height: 24)
                        
                        Text("Water Body: \(viewModel.selectedWaterBodyShape.displayName)")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                        
                        Spacer()
                        
                        Text("Change")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(Color(hex: "4A90E2"))
                    }
                    .foregroundColor(.white)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: "151D26"))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "2A3A4C"), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                // Explanation
                VStack(alignment: .leading, spacing: 12) {
                    Text("Prediction")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(viewModel.getFeedingZoneDescription())
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(Color(hex: "B0C0D0"))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Wind info
                    HStack(spacing: 16) {
                        InfoBadge(
                            title: "Direction",
                            value: viewModel.selectedWindDirection.displayName,
                            icon: { MiniWindArrow(direction: viewModel.selectedWindDirection) }
                        )
                        
                        InfoBadge(
                            title: "Strength",
                            value: viewModel.selectedWindStrength.displayName,
                            icon: { WindStrengthMini(strength: viewModel.selectedWindStrength) }
                        )
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: "151D26"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "2A3A4C"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "0A1218").ignoresSafeArea())
        .sheet(isPresented: $showShapeSelector) {
            ShapeSelectorView(
                selectedShape: $viewModel.selectedWaterBodyShape,
                isPresented: $showShapeSelector
            )
        }
    }
}

struct ZoneLegend: View {
    var body: some View {
        HStack(spacing: 20) {
            LegendItem(color: Color(hex: "4CAF50"), text: "High activity")
            LegendItem(color: Color(hex: "FFC107"), text: "Medium")
            LegendItem(color: Color(hex: "607D8B"), text: "Low")
        }
    }
}

struct LegendItem: View {
    let color: Color
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(text)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(hex: "8A9AAC"))
        }
    }
}

struct ShapeIcon: View {
    let shape: WaterBodyShape
    
    var body: some View {
        GeometryReader { geo in
            WaterBodyShape_Drawing(shape: shape)
                .stroke(Color(hex: "4A90E2"), lineWidth: 1.5)
        }
    }
}

struct InfoBadge<Icon: View>: View {
    let title: String
    let value: String
    let icon: () -> Icon
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(Color(hex: "6A7A8C"))
            
            HStack(spacing: 6) {
                icon()
                    .frame(width: 16, height: 16)
                
                Text(value)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "1E2A38"))
        )
    }
}

struct WindStrengthMini: View {
    let strength: WindStrength
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1)
                    .fill(index < strengthLevel ? Color(hex: "4A90E2") : Color(hex: "2A3A4C"))
                    .frame(width: 3, height: CGFloat(4 + index * 2))
            }
        }
    }
    
    private var strengthLevel: Int {
        switch strength {
        case .weak: return 1
        case .moderate: return 2
        case .strong: return 3
        case .storm: return 4
        }
    }
}
