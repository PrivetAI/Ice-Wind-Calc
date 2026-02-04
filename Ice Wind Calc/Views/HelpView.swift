import SwiftUI

struct HelpView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("How It Works")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Why wind affects fishing")
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(Color(hex: "8A9AAC"))
                }
                .padding(.top, 20)
                
                // Plankton Section
                HelpSection(
                    title: "Plankton Movement",
                    content: "Wind pushes surface water and plankton to the downwind shore. Small fish follow the plankton, and larger predatory fish follow them. This creates natural feeding zones on the side where wind blows TO.",
                    diagram: { PlanktonDiagram() }
                )
                
                // Temperature Section
                HelpSection(
                    title: "Water Temperature",
                    content: "Wind causes mixing of water layers. On the downwind side, warmer surface water accumulates, making fish more active. The windward side gets cooler upwelling water from the bottom.",
                    diagram: { TemperatureDiagram() }
                )
                
                // Waves Section
                HelpSection(
                    title: "Wave Action",
                    content: "Waves on the downwind shore stir up sediment and wash insects into the water. This creates additional food sources for fish. Strong winds make this effect more pronounced.",
                    diagram: { WavesDiagram() }
                )
                
                // FAQ Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("FAQ")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    FAQItem(
                        question: "What if wind changes during the day?",
                        answer: "Fish positions change with wind direction. If wind shifts significantly, recalculate. It may take 1-2 hours for fish to reposition after major wind changes."
                    )
                    
                    FAQItem(
                        question: "Does this work for ice fishing?",
                        answer: "Yes! Wind affects under-ice currents and oxygen distribution. Drill holes on the downwind side for better results."
                    )
                    
                    FAQItem(
                        question: "What about very strong winds?",
                        answer: "Storm conditions (15+ m/s) can make fishing difficult. Fish may move to deeper water for shelter. Consider safety first."
                    )
                    
                    FAQItem(
                        question: "Is this reliable for all fish?",
                        answer: "Most effective for species that feed on plankton and small bait fish. Bottom feeders may be less affected by wind patterns."
                    )
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "151D26"))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "2A3A4C"), lineWidth: 1)
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .background(Color(hex: "0A1218").ignoresSafeArea())
    }
}

struct HelpSection<Diagram: View>: View {
    let title: String
    let content: String
    let diagram: () -> Diagram
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            
            diagram()
                .frame(height: 120)
            
            Text(content)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(Color(hex: "B0C0D0"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "151D26"))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "2A3A4C"), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    Text(question)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    ExpandIcon(isExpanded: isExpanded)
                        .frame(width: 12, height: 12)
                }
            }
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(Color(hex: "8A9AAC"))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(hex: "1E2A38"))
        )
    }
}

struct ExpandIcon: View {
    let isExpanded: Bool
    
    var body: some View {
        Path { path in
            if isExpanded {
                path.move(to: CGPoint(x: 0, y: 8))
                path.addLine(to: CGPoint(x: 6, y: 2))
                path.addLine(to: CGPoint(x: 12, y: 8))
            } else {
                path.move(to: CGPoint(x: 0, y: 2))
                path.addLine(to: CGPoint(x: 6, y: 8))
                path.addLine(to: CGPoint(x: 12, y: 2))
            }
        }
        .stroke(Color(hex: "4A90E2"), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
    }
}

// MARK: - Diagrams

struct PlanktonDiagram: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Water body
                Ellipse()
                    .fill(Color(hex: "1A3A5C"))
                    .frame(width: w * 0.9, height: h * 0.6)
                
                Ellipse()
                    .stroke(Color(hex: "4A90E2"), lineWidth: 2)
                    .frame(width: w * 0.9, height: h * 0.6)
                
                // Plankton dots moving right
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(Color(hex: "4CAF50"))
                        .frame(width: 6, height: 6)
                        .offset(
                            x: CGFloat(-60 + i * 18),
                            y: CGFloat.random(in: -15...15)
                        )
                }
                
                // Fish icons on right
                ForEach(0..<3, id: \.self) { i in
                    FishIcon()
                        .fill(Color(hex: "FFC107"))
                        .frame(width: 20, height: 12)
                        .offset(x: w * 0.25, y: CGFloat(-20 + i * 20))
                }
                
                // Wind arrows
                ForEach(0..<3, id: \.self) { i in
                    WindArrowSmall()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 30, height: 10)
                        .offset(x: CGFloat(-100 + i * 40), y: -h * 0.4)
                }
                
                // Labels
                Text("WIND")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .offset(x: -w * 0.15, y: -h * 0.45)
            }
            .frame(width: w, height: h)
        }
    }
}

struct FishIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Body
        path.move(to: CGPoint(x: 0, y: h * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.7, y: h * 0.5),
            control: CGPoint(x: w * 0.35, y: 0)
        )
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: h * 0.5),
            control: CGPoint(x: w * 0.35, y: h)
        )
        
        return path
    }
}

struct WindArrowSmall: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: h * 0.5))
        path.addLine(to: CGPoint(x: w, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.7, y: 0))
        path.move(to: CGPoint(x: w, y: h * 0.5))
        path.addLine(to: CGPoint(x: w * 0.7, y: h))
        
        return path
    }
}

struct TemperatureDiagram: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Water body with gradient
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "1A4A6C"), Color(hex: "0A2A3C")],
                            startPoint: .trailing,
                            endPoint: .leading
                        )
                    )
                    .frame(width: w * 0.9, height: h * 0.6)
                
                Ellipse()
                    .stroke(Color(hex: "4A90E2"), lineWidth: 2)
                    .frame(width: w * 0.9, height: h * 0.6)
                
                // Warm label
                Text("WARM")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "FF6B6B"))
                    .offset(x: w * 0.25, y: 0)
                
                // Cool label
                Text("COOL")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "4A90E2"))
                    .offset(x: -w * 0.25, y: 0)
                
                // Wind arrows
                ForEach(0..<3, id: \.self) { i in
                    WindArrowSmall()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 30, height: 10)
                        .offset(x: CGFloat(-100 + i * 40), y: -h * 0.4)
                }
            }
            .frame(width: w, height: h)
        }
    }
}

struct WavesDiagram: View {
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                // Shore line at right
                Path { path in
                    path.move(to: CGPoint(x: w * 0.8, y: h * 0.2))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.85, y: h * 0.8),
                        control: CGPoint(x: w * 0.9, y: h * 0.5)
                    )
                }
                .stroke(Color(hex: "8B7355"), lineWidth: 3)
                
                // Water
                Path { path in
                    path.move(to: CGPoint(x: 0, y: h * 0.3))
                    path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.3))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.8, y: h * 0.7),
                        control: CGPoint(x: w * 0.85, y: h * 0.5)
                    )
                    path.addLine(to: CGPoint(x: 0, y: h * 0.7))
                    path.closeSubpath()
                }
                .fill(Color(hex: "1A3A5C"))
                
                // Waves
                ForEach(0..<4, id: \.self) { i in
                    WaveLine()
                        .stroke(Color(hex: "4A90E2").opacity(0.6), lineWidth: 1.5)
                        .frame(width: w * 0.3, height: 8)
                        .offset(x: CGFloat(-w * 0.1 + Double(i) * 25), y: CGFloat(h * 0.45 + Double(i) * 5))
                }
                
                // Sediment particles
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(Color(hex: "8B7355"))
                        .frame(width: 4, height: 4)
                        .offset(
                            x: w * 0.35 + CGFloat.random(in: -30...30),
                            y: h * 0.55 + CGFloat.random(in: -10...10)
                        )
                }
                
                // Wind arrows
                ForEach(0..<3, id: \.self) { i in
                    WindArrowSmall()
                        .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                        .frame(width: 30, height: 10)
                        .offset(x: CGFloat(-80 + i * 40), y: h * 0.15)
                }
            }
            .frame(width: w, height: h)
        }
    }
}

struct WaveLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        path.move(to: CGPoint(x: 0, y: h * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.25, y: h * 0.5),
            control: CGPoint(x: w * 0.125, y: 0)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.5),
            control: CGPoint(x: w * 0.375, y: h)
        )
        path.addQuadCurve(
            to: CGPoint(x: w * 0.75, y: h * 0.5),
            control: CGPoint(x: w * 0.625, y: 0)
        )
        path.addQuadCurve(
            to: CGPoint(x: w, y: h * 0.5),
            control: CGPoint(x: w * 0.875, y: h)
        )
        
        return path
    }
}
