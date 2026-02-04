import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainInputView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    VStack {
                        WindIcon()
                        Text("Wind")
                    }
                }
                .tag(0)
            
            ResultMapView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    VStack {
                        MapIcon()
                        Text("Map")
                    }
                }
                .tag(1)
            
            HistoryView(viewModel: viewModel, selectedTab: $selectedTab)
                .tabItem {
                    VStack {
                        HistoryIcon()
                        Text("History")
                    }
                }
                .tag(2)
            
            HelpView()
                .tabItem {
                    VStack {
                        HelpIcon()
                        Text("Help")
                    }
                }
                .tag(3)
        }
        .accentColor(Color("AccentColor"))
    }
}

// MARK: - Custom Tab Icons

struct WindIcon: View {
    var body: some View {
        Image(systemName: "")
            .opacity(0)
            .overlay(
                GeometryReader { geo in
                    Path { path in
                        let w = geo.size.width
                        let h = geo.size.height
                        path.move(to: CGPoint(x: 0, y: h * 0.3))
                        path.addQuadCurve(to: CGPoint(x: w * 0.6, y: h * 0.3), control: CGPoint(x: w * 0.3, y: h * 0.1))
                        path.addArc(center: CGPoint(x: w * 0.7, y: h * 0.3), radius: w * 0.1, startAngle: .degrees(180), endAngle: .degrees(-90), clockwise: false)
                        
                        path.move(to: CGPoint(x: 0, y: h * 0.5))
                        path.addQuadCurve(to: CGPoint(x: w * 0.8, y: h * 0.5), control: CGPoint(x: w * 0.4, y: h * 0.35))
                        path.addArc(center: CGPoint(x: w * 0.85, y: h * 0.5), radius: w * 0.08, startAngle: .degrees(180), endAngle: .degrees(-90), clockwise: false)
                        
                        path.move(to: CGPoint(x: 0, y: h * 0.7))
                        path.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.7), control: CGPoint(x: w * 0.25, y: h * 0.55))
                        path.addArc(center: CGPoint(x: w * 0.6, y: h * 0.7), radius: w * 0.1, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
                    }
                    .stroke(Color.primary, lineWidth: 1.5)
                }
            )
            .frame(width: 24, height: 24)
    }
}

struct MapIcon: View {
    var body: some View {
        Image(systemName: "")
            .opacity(0)
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    ZStack {
                        Ellipse()
                            .stroke(Color.primary, lineWidth: 1.5)
                            .frame(width: w * 0.9, height: h * 0.7)
                        Circle()
                            .fill(Color.green.opacity(0.5))
                            .frame(width: w * 0.25, height: w * 0.25)
                            .offset(x: w * 0.15, y: h * 0.1)
                    }
                    .frame(width: w, height: h)
                }
            )
            .frame(width: 24, height: 24)
    }
}

struct HistoryIcon: View {
    var body: some View {
        Image(systemName: "")
            .opacity(0)
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    ZStack {
                        Circle()
                            .stroke(Color.primary, lineWidth: 1.5)
                        Path { path in
                            path.move(to: CGPoint(x: w * 0.5, y: h * 0.25))
                            path.addLine(to: CGPoint(x: w * 0.5, y: h * 0.5))
                            path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.6))
                        }
                        .stroke(Color.primary, lineWidth: 1.5)
                    }
                    .frame(width: w, height: h)
                }
            )
            .frame(width: 24, height: 24)
    }
}

struct HelpIcon: View {
    var body: some View {
        Image(systemName: "")
            .opacity(0)
            .overlay(
                GeometryReader { geo in
                    let w = geo.size.width
                    let h = geo.size.height
                    ZStack {
                        Circle()
                            .stroke(Color.primary, lineWidth: 1.5)
                        Text("?")
                            .font(.system(size: h * 0.5, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .frame(width: w, height: h)
                }
            )
            .frame(width: 24, height: 24)
    }
}
