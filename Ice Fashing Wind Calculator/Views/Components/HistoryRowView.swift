import SwiftUI

struct HistoryRowView: View {
    let record: CalculationRecord

    var body: some View {
        HStack(spacing: 14) {
            // Mini compass indicator
            MiniCompass(direction: record.windDirection)
                .frame(width: 38, height: 38)

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    TagPill(text: record.windDirection.shortName, highlight: true)
                    TagPill(text: record.windStrength.label, highlight: false)
                    TagPill(text: record.waterBodyShape.label, highlight: false)
                }

                Text(record.formattedTimestamp)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Frost.textSecondary)
            }

            Spacer()

            ThinChevronRight()
                .stroke(Frost.textSecondary.opacity(0.5), style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                .frame(width: 7, height: 12)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Frost.border, lineWidth: 0.5)
        )
    }
}

// MARK: - Mini Compass

private struct MiniCompass: View {
    let direction: WindDirection

    var body: some View {
        ZStack {
            Circle()
                .fill(Frost.iceLight)
            Circle()
                .stroke(Frost.iceMid, lineWidth: 1)

            // Needle
            NeedleLine(direction: direction)
                .stroke(Frost.iceAccent, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))

            Circle()
                .fill(Frost.iceAccent)
                .frame(width: 4, height: 4)
        }
    }
}

private struct NeedleLine: Shape {
    let direction: WindDirection

    func path(in rect: CGRect) -> Path {
        var p = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2 * 0.6
        let angle = CGFloat((direction.angleDegrees - 90) * .pi / 180)
        p.move(to: c)
        p.addLine(to: CGPoint(x: c.x + r * CoreGraphics.cos(angle),
                               y: c.y + r * CoreGraphics.sin(angle)))
        return p
    }
}

// MARK: - Tag Pill

struct TagPill: View {
    let text: String
    let highlight: Bool

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: highlight ? .bold : .medium))
            .foregroundColor(highlight ? .white : Frost.textSecondary)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(
                Capsule().fill(highlight ? Frost.iceAccent : Frost.iceLight)
            )
    }
}
