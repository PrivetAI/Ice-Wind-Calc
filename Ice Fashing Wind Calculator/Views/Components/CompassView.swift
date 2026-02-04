import SwiftUI
import Foundation

struct CompassView: View {
    @Binding var selectedDirection: WindDirection
    
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = size / 2 - 40
            
            ZStack {
                // Outer ring
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "3A4A5C"), Color(hex: "2A3A4C")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: size - 20, height: size - 20)
                
                // Inner circle gradient
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "1E2A38"), Color(hex: "0F1620")],
                            center: .center,
                            startRadius: 0,
                            endRadius: size / 2
                        )
                    )
                    .frame(width: size - 30, height: size - 30)
                
                // Direction buttons
                ForEach(WindDirection.allCases, id: \.self) { direction in
                    let angle = CGFloat(direction.degrees - 90)
                    let radians = angle * .pi / 180
                    let x = center.x + radius * CoreGraphics.cos(radians) - geo.size.width / 2
                    let y = center.y + radius * CoreGraphics.sin(radians) - geo.size.height / 2
                    
                    DirectionButton(
                        direction: direction,
                        isSelected: selectedDirection == direction
                    )
                    .offset(x: x, y: y)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedDirection = direction
                        }
                    }
                }
                
                // Center indicator
                Circle()
                    .fill(Color(hex: "4A90E2"))
                    .frame(width: 12, height: 12)
                
                // Wind arrow from center to selected direction
                WindArrowShape(direction: selectedDirection)
                    .stroke(
                        LinearGradient(
                            colors: [Color(hex: "4A90E2"), Color(hex: "6AB0FF")],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: radius * 1.3, height: radius * 1.3)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct DirectionButton: View {
    let direction: WindDirection
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isSelected ? Color(hex: "4A90E2") : Color(hex: "2A3A4C"))
                .frame(width: 44, height: 44)
            
            Circle()
                .stroke(isSelected ? Color(hex: "6AB0FF") : Color(hex: "3A4A5C"), lineWidth: 2)
                .frame(width: 44, height: 44)
            
            Text(direction.shortName)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : Color(hex: "8A9AAC"))
        }
        .shadow(color: isSelected ? Color(hex: "4A90E2").opacity(0.5) : .clear, radius: 8)
    }
}

struct WindArrowShape: Shape {
    let direction: WindDirection
    
    var animatableData: Double {
        get { direction.degrees }
        set { }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let arrowLength = min(rect.width, rect.height) / 2 * 0.7
        let angle = CGFloat((direction.degrees - 90) * .pi / 180)
        
        let endPoint = CGPoint(
            x: center.x + arrowLength * CoreGraphics.cos(angle),
            y: center.y + arrowLength * CoreGraphics.sin(angle)
        )
        
        path.move(to: center)
        path.addLine(to: endPoint)
        
        // Arrow head
        let headLength: CGFloat = 12
        let headAngle: CGFloat = 25 * .pi / 180
        
        let leftHead = CGPoint(
            x: endPoint.x - headLength * CoreGraphics.cos(angle - headAngle),
            y: endPoint.y - headLength * CoreGraphics.sin(angle - headAngle)
        )
        let rightHead = CGPoint(
            x: endPoint.x - headLength * CoreGraphics.cos(angle + headAngle),
            y: endPoint.y - headLength * CoreGraphics.sin(angle + headAngle)
        )
        
        path.move(to: endPoint)
        path.addLine(to: leftHead)
        path.move(to: endPoint)
        path.addLine(to: rightHead)
        
        return path
    }
}
