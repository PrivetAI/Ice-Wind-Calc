import SwiftUI
import CoreGraphics

struct WaterBodyView: View {
    let shape: WaterBodyShape
    let windDirection: WindDirection
    let windStrength: WindStrength
    let showOverlay: Bool

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Water fill
                BodyOutline(shape: shape)
                    .fill(Frost.iceLight)

                if showOverlay {
                    // Feeding zones
                    ZoneWedge(direction: windDirection.opposite, spread: 50, color: Frost.goodZone.opacity(windStrength.intensityFactor * 0.55))
                        .clipShape(BodyOutline(shape: shape))

                    ForEach(windDirection.opposite.neighborDirections, id: \.self) { nd in
                        ZoneWedge(direction: nd, spread: 38, color: Frost.midZone.opacity(windStrength.intensityFactor * 0.35))
                            .clipShape(BodyOutline(shape: shape))
                    }

                    ZoneWedge(direction: windDirection, spread: 50, color: Frost.dangerZone.opacity(windStrength.intensityFactor * 0.25))
                        .clipShape(BodyOutline(shape: shape))
                }

                // Outline
                BodyOutline(shape: shape)
                    .stroke(Frost.iceMid, lineWidth: 1.5)

                // Wind arrow indicator
                if showOverlay {
                    ThinArrow(direction: windDirection)
                        .stroke(Frost.textSecondary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                        .frame(width: min(w, h) * 0.25, height: min(w, h) * 0.25)
                        .offset(arrowOffset(w: w, h: h))
                }
            }
            .frame(width: w, height: h)
        }
    }

    private func arrowOffset(w: CGFloat, h: CGFloat) -> CGSize {
        let mag: CGFloat = min(w, h) * 0.35
        let rad = CGFloat((windDirection.angleDegrees + 180 - 90) * .pi / 180)
        return CGSize(width: mag * CoreGraphics.cos(rad), height: mag * CoreGraphics.sin(rad))
    }
}

// MARK: - Body Outline

struct BodyOutline: Shape {
    let shape: WaterBodyShape

    func path(in rect: CGRect) -> Path {
        switch shape {
        case .circular: return Path(ellipseIn: rect.insetBy(dx: 4, dy: 4))
        case .elongated: return Path(ellipseIn: rect.insetBy(dx: 4, dy: rect.height * 0.18))
        case .channel: return channelPath(in: rect)
        case .wedge: return wedgePath(in: rect)
        case .freeform: return freeformPath(in: rect)
        }
    }

    private func channelPath(in r: CGRect) -> Path {
        var p = Path()
        let inset: CGFloat = 6
        let h3 = r.height * 0.35
        p.move(to: CGPoint(x: inset, y: r.midY - h3 / 2))
        p.addQuadCurve(to: CGPoint(x: r.width * 0.5, y: r.midY - h3 / 2 - 8),
                        control: CGPoint(x: r.width * 0.25, y: r.midY - h3 / 2 + 12))
        p.addQuadCurve(to: CGPoint(x: r.width - inset, y: r.midY - h3 / 2 + 4),
                        control: CGPoint(x: r.width * 0.75, y: r.midY - h3 / 2 - 14))
        p.addLine(to: CGPoint(x: r.width - inset, y: r.midY + h3 / 2 + 4))
        p.addQuadCurve(to: CGPoint(x: r.width * 0.5, y: r.midY + h3 / 2 + 8),
                        control: CGPoint(x: r.width * 0.75, y: r.midY + h3 / 2 + 18))
        p.addQuadCurve(to: CGPoint(x: inset, y: r.midY + h3 / 2),
                        control: CGPoint(x: r.width * 0.25, y: r.midY + h3 / 2 - 6))
        p.closeSubpath()
        return p
    }

    private func wedgePath(in r: CGRect) -> Path {
        var p = Path()
        let inset: CGFloat = 8
        p.move(to: CGPoint(x: r.midX, y: inset))
        p.addLine(to: CGPoint(x: r.width - inset, y: r.height - inset))
        p.addQuadCurve(to: CGPoint(x: inset, y: r.height - inset),
                        control: CGPoint(x: r.midX, y: r.height - inset + 14))
        p.closeSubpath()
        return p
    }

    private func freeformPath(in r: CGRect) -> Path {
        var p = Path()
        let w = r.width
        let h = r.height
        p.move(to: CGPoint(x: w * 0.25, y: h * 0.08))
        p.addQuadCurve(to: CGPoint(x: w * 0.78, y: h * 0.15), control: CGPoint(x: w * 0.55, y: h * 0.02))
        p.addQuadCurve(to: CGPoint(x: w * 0.92, y: h * 0.52), control: CGPoint(x: w * 0.97, y: h * 0.30))
        p.addQuadCurve(to: CGPoint(x: w * 0.58, y: h * 0.90), control: CGPoint(x: w * 0.88, y: h * 0.78))
        p.addQuadCurve(to: CGPoint(x: w * 0.15, y: h * 0.72), control: CGPoint(x: w * 0.30, y: h * 0.95))
        p.addQuadCurve(to: CGPoint(x: w * 0.08, y: h * 0.38), control: CGPoint(x: w * 0.04, y: h * 0.58))
        p.addQuadCurve(to: CGPoint(x: w * 0.25, y: h * 0.08), control: CGPoint(x: w * 0.10, y: h * 0.18))
        p.closeSubpath()
        return p
    }
}

// MARK: - Zone Wedge

struct ZoneWedge: View {
    let direction: WindDirection
    let spread: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let c = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let r = max(geo.size.width, geo.size.height)
            Path { path in
                path.move(to: c)
                path.addArc(center: c, radius: r,
                            startAngle: .degrees(direction.angleDegrees - spread - 90),
                            endAngle: .degrees(direction.angleDegrees + spread - 90),
                            clockwise: false)
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

// MARK: - Thin Arrow

struct ThinArrow: Shape {
    let direction: WindDirection

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let len = min(rect.width, rect.height) / 2
        let angle = CGFloat((direction.angleDegrees - 90) * .pi / 180)
        let tip = CGPoint(x: c.x + len * CoreGraphics.cos(angle),
                          y: c.y + len * CoreGraphics.sin(angle))
        p.move(to: c)
        p.addLine(to: tip)

        let hl: CGFloat = 8
        let ha: CGFloat = 28 * .pi / 180
        p.move(to: tip)
        p.addLine(to: CGPoint(x: tip.x - hl * CoreGraphics.cos(angle - ha),
                               y: tip.y - hl * CoreGraphics.sin(angle - ha)))
        p.move(to: tip)
        p.addLine(to: CGPoint(x: tip.x - hl * CoreGraphics.cos(angle + ha),
                               y: tip.y - hl * CoreGraphics.sin(angle + ha)))
        return p
    }
}
