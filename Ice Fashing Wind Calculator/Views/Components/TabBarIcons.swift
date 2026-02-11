import SwiftUI

// MARK: - Wind Analysis Icon (compass-like)

struct WindAnalysisIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX
        let cy = rect.midY
        let r = min(rect.width, rect.height) / 2 - 1
        // Circle
        p.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
        // Needle pointing up
        p.move(to: CGPoint(x: cx, y: cy - r * 0.65))
        p.addLine(to: CGPoint(x: cx - r * 0.15, y: cy + r * 0.2))
        p.addLine(to: CGPoint(x: cx + r * 0.15, y: cy + r * 0.2))
        p.closeSubpath()
        // Dot
        p.addEllipse(in: CGRect(x: cx - 1.5, y: cy - 1.5, width: 3, height: 3))
        return p
    }
}

// MARK: - Journal Icon (book)

struct TabJournalIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        p.addRoundedRect(in: CGRect(x: 1, y: 0, width: w - 2, height: h), cornerSize: CGSize(width: 2, height: 2))
        p.move(to: CGPoint(x: w * 0.28, y: 0))
        p.addLine(to: CGPoint(x: w * 0.28, y: h))
        p.move(to: CGPoint(x: w * 0.4, y: h * 0.28))
        p.addLine(to: CGPoint(x: w * 0.82, y: h * 0.28))
        p.move(to: CGPoint(x: w * 0.4, y: h * 0.48))
        p.addLine(to: CGPoint(x: w * 0.72, y: h * 0.48))
        p.move(to: CGPoint(x: w * 0.4, y: h * 0.68))
        p.addLine(to: CGPoint(x: w * 0.65, y: h * 0.68))
        return p
    }
}

// MARK: - Patterns Icon (wind lines)

struct PatternsIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Three wavy lines
        p.move(to: CGPoint(x: w * 0.1, y: h * 0.25))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.25), control: CGPoint(x: w * 0.3, y: h * 0.1))
        p.addQuadCurve(to: CGPoint(x: w * 0.9, y: h * 0.25), control: CGPoint(x: w * 0.7, y: h * 0.4))

        p.move(to: CGPoint(x: w * 0.1, y: h * 0.5))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.5), control: CGPoint(x: w * 0.3, y: h * 0.35))
        p.addQuadCurve(to: CGPoint(x: w * 0.9, y: h * 0.5), control: CGPoint(x: w * 0.7, y: h * 0.65))

        p.move(to: CGPoint(x: w * 0.1, y: h * 0.75))
        p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.75), control: CGPoint(x: w * 0.3, y: h * 0.6))
        p.addQuadCurve(to: CGPoint(x: w * 0.9, y: h * 0.75), control: CGPoint(x: w * 0.7, y: h * 0.9))
        return p
    }
}

// MARK: - Stats Icon (bar chart)

struct StatsIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width
        let h = rect.height
        // Bars
        p.addRect(CGRect(x: w * 0.08, y: h * 0.5, width: w * 0.18, height: h * 0.45))
        p.addRect(CGRect(x: w * 0.31, y: h * 0.2, width: w * 0.18, height: h * 0.75))
        p.addRect(CGRect(x: w * 0.54, y: h * 0.35, width: w * 0.18, height: h * 0.6))
        p.addRect(CGRect(x: w * 0.77, y: h * 0.05, width: w * 0.18, height: h * 0.9))
        return p
    }
}

// MARK: - Settings Icon (gear)

struct SettingsIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX
        let cy = rect.midY
        let outerR = min(rect.width, rect.height) / 2 - 1
        let innerR = outerR * 0.7
        let teethCount = 8

        // Gear outline
        for i in 0..<(teethCount * 2) {
            let r = i % 2 == 0 ? outerR : innerR
            let angle = CGFloat(Double(i) * .pi / Double(teethCount)) - .pi / 2
            let pt = CGPoint(x: cx + r * cos(angle), y: cy + r * sin(angle))
            if i == 0 { p.move(to: pt) } else { p.addLine(to: pt) }
        }
        p.closeSubpath()

        // Center hole
        let holeR = outerR * 0.3
        p.addEllipse(in: CGRect(x: cx - holeR, y: cy - holeR, width: holeR * 2, height: holeR * 2))
        return p
    }
}
