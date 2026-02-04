import SwiftUI

struct WaterBodyView: View {
    let shape: WaterBodyShape
    let windDirection: WindDirection
    let windStrength: WindStrength
    let showZones: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            
            ZStack {
                // Water body shape with zones
                WaterBodyShape_Drawing(shape: shape)
                    .fill(Color(hex: "1A3A5C"))
                    .frame(width: shapeWidth(size), height: shapeHeight(size))
                
                if showZones {
                    // Feeding zones overlay
                    FeedingZonesOverlay(
                        shape: shape,
                        windDirection: windDirection,
                        intensity: windStrength.zoneIntensity
                    )
                    .frame(width: shapeWidth(size), height: shapeHeight(size))
                }
                
                // Water body outline
                WaterBodyShape_Drawing(shape: shape)
                    .stroke(Color(hex: "4A90E2"), lineWidth: 2)
                    .frame(width: shapeWidth(size), height: shapeHeight(size))
                
                // Wind direction arrow
                if showZones {
                    WindDirectionArrow(direction: windDirection)
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: size * 0.3, height: size * 0.3)
                        .offset(windArrowOffset(size: size))
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
    }
    
    private var aspectRatio: CGFloat {
        switch shape {
        case .circle: return 1
        case .oval: return 1.4
        case .river: return 3
        case .triangle: return 1.15
        case .irregular: return 1.2
        }
    }
    
    private func shapeWidth(_ size: CGFloat) -> CGFloat {
        switch shape {
        case .river: return size * 0.95
        default: return size * 0.85
        }
    }
    
    private func shapeHeight(_ size: CGFloat) -> CGFloat {
        switch shape {
        case .circle: return size * 0.85
        case .oval: return size * 0.6
        case .river: return size * 0.3
        case .triangle: return size * 0.75
        case .irregular: return size * 0.7
        }
    }
    
    private func windArrowOffset(size: CGFloat) -> CGSize {
        let offset = size * 0.35
        let angle = (windDirection.degrees + 180 - 90) * .pi / 180
        return CGSize(
            width: offset * cos(angle),
            height: offset * sin(angle)
        )
    }
}

struct WaterBodyShape_Drawing: Shape {
    let shape: WaterBodyShape
    
    func path(in rect: CGRect) -> Path {
        switch shape {
        case .circle:
            return Path(ellipseIn: rect)
        case .oval:
            return Path(ellipseIn: rect)
        case .river:
            return riverPath(in: rect)
        case .triangle:
            return trianglePath(in: rect)
        case .irregular:
            return irregularPath(in: rect)
        }
    }
    
    private func riverPath(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: h * 0.3))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.3, y: h * 0.15),
            control: CGPoint(x: w * 0.15, y: h * 0.1)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.7, y: h * 0.2),
            control: CGPoint(x: w * 0.5, y: h * 0.3)
        )
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.35),
            control: CGPoint(x: w * 0.85, y: h * 0.15)
        )
        path.addLine(to: CGPoint(x: w, y: h * 0.65))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.7, y: h * 0.8),
            control: CGPoint(x: w * 0.85, y: h * 0.85)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.3, y: h * 0.85),
            control: CGPoint(x: w * 0.5, y: h * 0.7)
        )
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h * 0.7),
            control: CGPoint(x: w * 0.15, y: h * 0.9)
        )
        path.closeSubpath()
        
        return path
    }
    
    private func trianglePath(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.5, y: 0))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.closeSubpath()
        
        return path
    }
    
    private func irregularPath(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: w * 0.2, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.05))
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.4),
            control: CGPoint(x: w * 0.95, y: h * 0.2)
        )
        path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h),
            control: CGPoint(x: w * 0.7, y: h * 0.95)
        )
        path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.85))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h * 0.5),
            control: CGPoint(x: 0, y: h * 0.7)
        )
        path.addLine(to: CGPoint(x: w * 0.1, y: h * 0.2))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.2, y: 0),
            control: CGPoint(x: w * 0.05, y: h * 0.1)
        )
        path.closeSubpath()
        
        return path
    }
}

struct FeedingZonesOverlay: View {
    let shape: WaterBodyShape
    let windDirection: WindDirection
    let intensity: Double
    
    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            
            // High activity zone (downwind)
            ZoneArc(
                direction: windDirection.opposite,
                spread: 45,
                color: Color(hex: "4CAF50").opacity(intensity * 0.6)
            )
            
            // Medium activity zones (adjacent to downwind)
            ForEach(windDirection.opposite.adjacent, id: \.self) { direction in
                ZoneArc(
                    direction: direction,
                    spread: 35,
                    color: Color(hex: "FFC107").opacity(intensity * 0.4)
                )
            }
            
            // Low activity zone (windward)
            ZoneArc(
                direction: windDirection,
                spread: 45,
                color: Color(hex: "607D8B").opacity(intensity * 0.3)
            )
        }
        .clipShape(WaterBodyShape_Drawing(shape: shape))
    }
}

struct ZoneArc: View {
    let direction: WindDirection
    let spread: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = max(geo.size.width, geo.size.height)
            let startAngle = direction.degrees - spread - 90
            let endAngle = direction.degrees + spread - 90
            
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: .degrees(startAngle),
                    endAngle: .degrees(endAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

struct WindDirectionArrow: Shape {
    let direction: WindDirection
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let length = min(rect.width, rect.height) / 2
        let angle = (direction.degrees - 90) * .pi / 180
        
        let start = CGPoint(
            x: center.x - length * 0.3 * cos(angle),
            y: center.y - length * 0.3 * sin(angle)
        )
        let end = CGPoint(
            x: center.x + length * cos(angle),
            y: center.y + length * sin(angle)
        )
        
        path.move(to: start)
        path.addLine(to: end)
        
        // Arrow head
        let headLength: CGFloat = 10
        let headAngle: CGFloat = 25 * .pi / 180
        
        let leftHead = CGPoint(
            x: end.x - headLength * cos(angle - headAngle),
            y: end.y - headLength * sin(angle - headAngle)
        )
        let rightHead = CGPoint(
            x: end.x - headLength * cos(angle + headAngle),
            y: end.y - headLength * sin(angle + headAngle)
        )
        
        path.move(to: end)
        path.addLine(to: leftHead)
        path.move(to: end)
        path.addLine(to: rightHead)
        
        return path
    }
}
