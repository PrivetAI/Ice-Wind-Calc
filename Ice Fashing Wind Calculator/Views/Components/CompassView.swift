import SwiftUI
import CoreGraphics

struct CompassView: View {
    @Binding var selectedDirection: WindDirection
    var strength: WindStrength

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let outerR = side / 2 - 8
            let labelR = outerR - 30
            let tickR = outerR - 4

            ZStack {
                // Outer frosted ring
                Circle()
                    .fill(Frost.card)
                    .frame(width: side, height: side)
                    .shadow(color: Color.black.opacity(0.04), radius: 10, y: 2)

                Circle()
                    .stroke(Frost.border, lineWidth: 1)
                    .frame(width: side, height: side)

                // Inner gradient disc
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Frost.iceLight, Frost.card],
                            center: .center,
                            startRadius: 0,
                            endRadius: side / 2 * 0.6
                        )
                    )
                    .frame(width: side - 56, height: side - 56)

                // Degree tick marks (every 15 deg)
                ForEach(0..<24, id: \.self) { i in
                    let deg = Double(i) * 15
                    let rad = CGFloat((deg - 90) * .pi / 180)
                    let inner = tickR - (i % 2 == 0 ? 10 : 5)
                    TickLine(
                        from: CGPoint(
                            x: center.x + inner * CoreGraphics.cos(rad),
                            y: center.y + inner * CoreGraphics.sin(rad)
                        ),
                        to: CGPoint(
                            x: center.x + tickR * CoreGraphics.cos(rad),
                            y: center.y + tickR * CoreGraphics.sin(rad)
                        )
                    )
                    .stroke(Frost.border, lineWidth: i % 2 == 0 ? 1.5 : 0.8)
                }

                // Direction tap targets
                ForEach(WindDirection.allCases, id: \.self) { dir in
                    let rad = CGFloat((dir.angleDegrees - 90) * .pi / 180)
                    let pos = CGPoint(
                        x: center.x + labelR * CoreGraphics.cos(rad) - geo.size.width / 2,
                        y: center.y + labelR * CoreGraphics.sin(rad) - geo.size.height / 2
                    )

                    DirectionLabel(
                        direction: dir,
                        isActive: selectedDirection == dir
                    )
                    .offset(x: pos.x, y: pos.y)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            selectedDirection = dir
                        }
                    }
                }

                // Animated wind needle
                WindNeedle()
                    .fill(Frost.iceAccent)
                    .frame(width: 8, height: outerR * 0.52)
                    .offset(y: -(outerR * 0.52) / 2 + 4)
                    .rotationEffect(.degrees(selectedDirection.angleDegrees))
                    .animation(.easeInOut(duration: 0.35), value: selectedDirection)

                // Center dot
                Circle()
                    .fill(Frost.iceAccent)
                    .frame(width: 10, height: 10)

                Circle()
                    .fill(Frost.card)
                    .frame(width: 4, height: 4)

                // Pulsing ring for strength
                Circle()
                    .stroke(Frost.iceAccent.opacity(0.2 + strength.intensityFactor * 0.3), lineWidth: 2)
                    .frame(width: side - 56 + CGFloat(strength.orderIndex) * 8,
                           height: side - 56 + CGFloat(strength.orderIndex) * 8)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

// MARK: - Sub-components

private struct DirectionLabel: View {
    let direction: WindDirection
    let isActive: Bool

    var body: some View {
        Text(direction.shortName)
            .font(.system(size: isActive ? 15 : 12, weight: isActive ? .bold : .medium))
            .foregroundColor(isActive ? Frost.iceAccent : Frost.textSecondary)
            .frame(width: 32, height: 32)
    }
}

private struct WindNeedle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.move(to: CGPoint(x: w / 2, y: 0))
        p.addLine(to: CGPoint(x: w, y: h))
        p.addQuadCurve(
            to: CGPoint(x: 0, y: h),
            control: CGPoint(x: w / 2, y: h - 6)
        )
        p.closeSubpath()
        return p
    }
}

private struct TickLine: Shape {
    let from: CGPoint
    let to: CGPoint

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: from)
        p.addLine(to: to)
        return p
    }
}
