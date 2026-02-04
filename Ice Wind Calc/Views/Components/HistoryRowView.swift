import SwiftUI

struct HistoryRowView: View {
    let record: CalculationRecord
    
    var body: some View {
        HStack(spacing: 16) {
            // Mini water body preview
            WaterBodyView(
                shape: record.waterBodyShape,
                windDirection: record.windDirection,
                windStrength: record.windStrength,
                showZones: true
            )
            .frame(width: 60, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    // Wind direction badge
                    HStack(spacing: 4) {
                        MiniWindArrow(direction: record.windDirection)
                            .frame(width: 14, height: 14)
                        Text(record.windDirection.shortName)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Color(hex: "4A90E2"))
                    )
                    
                    // Wind strength badge
                    Text(record.windStrength.displayName)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(hex: "2A3A4C"))
                        )
                    
                    // Shape badge
                    Text(record.waterBodyShape.displayName)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color(hex: "2A3A4C"))
                        )
                }
                
                Text(record.formattedDate)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(Color(hex: "6A7A8C"))
            }
            
            Spacer()
            
            // Chevron
            ChevronRight()
                .stroke(Color(hex: "4A5A6C"), lineWidth: 2)
                .frame(width: 10, height: 16)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "151D26"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "2A3A4C"), lineWidth: 1)
        )
    }
}

struct MiniWindArrow: View {
    let direction: WindDirection
    
    var body: some View {
        GeometryReader { geo in
            Path { path in
                let w = geo.size.width
                let h = geo.size.height
                let center = CGPoint(x: w / 2, y: h / 2)
                let length = min(w, h) / 2 * 0.8
                let angle = (direction.degrees - 90) * .pi / 180
                
                let end = CGPoint(
                    x: center.x + length * cos(angle),
                    y: center.y + length * sin(angle)
                )
                
                path.move(to: center)
                path.addLine(to: end)
                
                let headLength: CGFloat = 4
                let headAngle: CGFloat = 30 * .pi / 180
                
                path.addLine(to: CGPoint(
                    x: end.x - headLength * cos(angle - headAngle),
                    y: end.y - headLength * sin(angle - headAngle)
                ))
                path.move(to: end)
                path.addLine(to: CGPoint(
                    x: end.x - headLength * cos(angle + headAngle),
                    y: end.y - headLength * sin(angle + headAngle)
                ))
            }
            .stroke(Color.white, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
        }
    }
}

struct ChevronRight: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
