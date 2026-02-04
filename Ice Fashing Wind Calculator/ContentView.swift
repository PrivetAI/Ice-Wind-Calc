import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainInputView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label {
                        Text("Wind")
                    } icon: {
                        Image(uiImage: renderIcon(WindIconShape()))
                    }
                }
                .tag(0)
            
            ResultMapView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label {
                        Text("Map")
                    } icon: {
                        Image(uiImage: renderIcon(MapIconShape()))
                    }
                }
                .tag(1)
            
            HistoryView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    Label {
                        Text("History")
                    } icon: {
                        Image(uiImage: renderIcon(HistoryIconShape()))
                    }
                }
                .tag(2)
            
            HelpView()
                .tabItem {
                    Label {
                        Text("Help")
                    } icon: {
                        Image(uiImage: renderIcon(HelpIconShape()))
                    }
                }
                .tag(3)
        }
        .accentColor(Color(hex: "4A90E2"))
    }
    
    private func renderIcon<S: Shape>(_ shape: S) -> UIImage {
        let size = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let path = shape.path(in: CGRect(origin: .zero, size: size))
            let bezierPath = UIBezierPath(cgPath: path.cgPath)
            bezierPath.lineWidth = 1.5
            bezierPath.lineCapStyle = .round
            bezierPath.lineJoinStyle = .round
            UIColor.label.setStroke()
            bezierPath.stroke()
        }
    }
}

// MARK: - Icon Shapes

struct WindIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Line 1
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.3))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.55, y: h * 0.3),
            control: CGPoint(x: w * 0.3, y: h * 0.15)
        )
        path.addArc(
            center: CGPoint(x: w * 0.65, y: h * 0.3),
            radius: w * 0.1,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )
        
        // Line 2
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.55))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.7, y: h * 0.55),
            control: CGPoint(x: w * 0.4, y: h * 0.4)
        )
        path.addArc(
            center: CGPoint(x: w * 0.8, y: h * 0.55),
            radius: w * 0.08,
            startAngle: .degrees(180),
            endAngle: .degrees(-90),
            clockwise: false
        )
        
        // Line 3
        path.move(to: CGPoint(x: w * 0.05, y: h * 0.8))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.45, y: h * 0.8),
            control: CGPoint(x: w * 0.25, y: h * 0.65)
        )
        path.addArc(
            center: CGPoint(x: w * 0.55, y: h * 0.8),
            radius: w * 0.1,
            startAngle: .degrees(180),
            endAngle: .degrees(90),
            clockwise: true
        )
        
        return path
    }
}

struct MapIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        
        // Oval water body
        path.addEllipse(in: CGRect(
            x: w * 0.1,
            y: h * 0.2,
            width: w * 0.8,
            height: h * 0.6
        ))
        
        // Dot for fishing spot
        path.addEllipse(in: CGRect(
            x: w * 0.55,
            y: h * 0.4,
            width: w * 0.2,
            height: h * 0.2
        ))
        
        return path
    }
}

struct HistoryIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let center = CGPoint(x: w / 2, y: h / 2)
        let radius = min(w, h) / 2 - 2
        
        // Circle
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // Clock hands
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x, y: center.y - radius * 0.5))
        
        path.move(to: center)
        path.addLine(to: CGPoint(x: center.x + radius * 0.4, y: center.y + radius * 0.15))
        
        return path
    }
}

struct HelpIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let w = rect.width
        let h = rect.height
        let center = CGPoint(x: w / 2, y: h / 2)
        let radius = min(w, h) / 2 - 2
        
        // Circle
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        // Question mark curve
        path.move(to: CGPoint(x: w * 0.35, y: h * 0.35))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.5, y: h * 0.55),
            control: CGPoint(x: w * 0.65, y: h * 0.25)
        )
        path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.6))
        
        // Dot
        path.addEllipse(in: CGRect(
            x: w * 0.45,
            y: h * 0.7,
            width: w * 0.1,
            height: h * 0.1
        ))
        
        return path
    }
}
