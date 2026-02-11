import SwiftUI

// MARK: - Palette

struct Frost {
    static let bg = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let card = Color.white
    static let iceLight = Color(red: 0.89, green: 0.95, blue: 0.99)
    static let iceMid = Color(red: 0.73, green: 0.87, blue: 0.98)
    static let iceAccent = Color(red: 0.56, green: 0.79, blue: 0.96)
    static let textPrimary = Color(red: 0.18, green: 0.22, blue: 0.28)
    static let textSecondary = Color(red: 0.50, green: 0.55, blue: 0.62)
    static let border = Color(red: 0.87, green: 0.90, blue: 0.93)
    static let dangerZone = Color(red: 0.94, green: 0.60, blue: 0.55)
    static let goodZone = Color(red: 0.47, green: 0.78, blue: 0.65)
    static let midZone = Color(red: 0.95, green: 0.82, blue: 0.50)
}

// MARK: - Tab Enum

enum AppTab: Int, CaseIterable {
    case wind = 0
    case journal = 1
    case patterns = 2
    case stats = 3
    case settings = 4

    var label: String {
        switch self {
        case .wind: return "Wind"
        case .journal: return "Journal"
        case .patterns: return "Patterns"
        case .stats: return "Stats"
        case .settings: return "Settings"
        }
    }
}

// MARK: - Content View

struct ContentView: View {
    @StateObject private var vm = AppViewModel()
    @StateObject private var journalVM = JournalViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    @State private var selectedTab: AppTab = .wind

    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content
            Group {
                switch selectedTab {
                case .wind:
                    windAnalysisTab
                case .journal:
                    JournalView(vm: journalVM)
                case .patterns:
                    PatternsGuideView()
                case .stats:
                    StatisticsView(journalVM: journalVM)
                case .settings:
                    SettingsView(settingsVM: settingsVM)
                }
            }

            // Custom tab bar
            customTabBar
        }
        .preferredColorScheme(.light)
    }

    // MARK: - Custom Tab Bar

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases, id: \.rawValue) { tab in
                Button(action: { withAnimation(.easeInOut(duration: 0.15)) { selectedTab = tab } }) {
                    VStack(spacing: 3) {
                        tabIcon(for: tab)
                            .frame(width: 22, height: 22)
                        Text(tab.label)
                            .font(.system(size: 10, weight: selectedTab == tab ? .bold : .regular))
                            .foregroundColor(selectedTab == tab ? Frost.iceAccent : Frost.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                }
            }
        }
        .padding(.bottom, 16)
        .background(
            Frost.card
                .shadow(color: Color.black.opacity(0.06), radius: 8, y: -2)
                .ignoresSafeArea(edges: .bottom)
        )
    }

    @ViewBuilder
    private func tabIcon(for tab: AppTab) -> some View {
        let color = selectedTab == tab ? Frost.iceAccent : Frost.textSecondary
        switch tab {
        case .wind:
            WindAnalysisIcon()
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        case .journal:
            TabJournalIcon()
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        case .patterns:
            PatternsIcon()
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        case .stats:
            StatsIcon()
                .fill(color)
        case .settings:
            SettingsIcon()
                .stroke(color, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
        }
    }

    // MARK: - Wind Analysis Tab (original main screen)

    private var windAnalysisTab: some View {
        NavigationView {
            ZStack {
                Frost.bg.ignoresSafeArea()

                GeometryReader { geo in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            headerArea
                            compassSection(size: geo.size)
                            strengthSelector
                            shapeRow
                            temperatureRow
                            analyzeButton
                            if vm.activeRecord != nil {
                                resultsPanel
                            }
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $vm.showHistorySheet) {
                HistoryView(vm: vm)
            }
            .sheet(isPresented: $vm.showSettingsSheet) {
                ShapeSelectorView(selectedShape: $vm.chosenShape, isPresented: $vm.showSettingsSheet)
            }
            .sheet(isPresented: $vm.showInfoSheet) {
                HelpView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Header

    private var headerArea: some View {
        VStack(spacing: 4) {
            Text("Ice Fashing Wind Calculator")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Frost.textPrimary)
                .padding(.top, 16)
            Text("Compass-driven feeding zone analysis")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Frost.textSecondary)
        }
        .padding(.bottom, 12)
    }

    // MARK: - Compass

    private func compassSection(size: CGSize) -> some View {
        let dim = min(size.width - 40, 300.0)
        return CompassView(selectedDirection: $vm.chosenDirection, strength: vm.chosenStrength)
            .frame(width: dim, height: dim)
            .padding(.vertical, 8)
    }

    // MARK: - Strength

    private var strengthSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Wind Strength")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Frost.textPrimary)

            WindStrengthPicker(selected: $vm.chosenStrength)
        }
        .padding(.top, 12)
    }

    // MARK: - Shape row

    private var shapeRow: some View {
        Button(action: { vm.showSettingsSheet = true }) {
            HStack {
                Text("Water Body")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Frost.textPrimary)
                Spacer()
                Text(vm.chosenShape.label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Frost.iceAccent)
                ThinChevronRight()
                    .stroke(Frost.textSecondary, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                    .frame(width: 8, height: 14)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Frost.card)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Frost.border, lineWidth: 1)
            )
        }
        .padding(.top, 12)
    }

    // MARK: - Temperature input

    private var temperatureRow: some View {
        HStack {
            Text("Air Temp")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Frost.textPrimary)

            Spacer()

            TextField("optional", text: $vm.airTemperatureText)
                .keyboardType(.numbersAndPunctuation)
                .font(.system(size: 14))
                .foregroundColor(Frost.textPrimary)
                .multilineTextAlignment(.trailing)
                .frame(width: 80)

            Text("C")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Frost.textSecondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Frost.border, lineWidth: 1)
        )
        .padding(.top, 8)
    }

    // MARK: - Analyze

    private var analyzeButton: some View {
        Button(action: { vm.analyze() }) {
            Text("Analyze Feeding Zones")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [Frost.iceAccent, Frost.iceMid],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
        }
        .padding(.top, 16)
    }

    // MARK: - Results

    private var resultsPanel: some View {
        VStack(alignment: .leading, spacing: 14) {
            ResultMapView(vm: vm)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            HStack(spacing: 16) {
                legendDot(color: Frost.goodZone, text: "Best spot")
                legendDot(color: Frost.midZone, text: "Fair")
                legendDot(color: Frost.dangerZone, text: "Poor")
            }
            .font(.system(size: 11, weight: .medium))

            adviceCard(title: "Feeding Zone", body: vm.currentFeedingAdvice)
            adviceCard(title: "Shelter Position", body: vm.currentShelterAdvice)

            if let wc = vm.currentWindChill {
                adviceCard(title: "Wind Chill", body: String(format: "Feels like %.1f C with current wind.", wc))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Frost.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Frost.border, lineWidth: 1)
        )
        .padding(.top, 16)
    }

    private func legendDot(color: Color, text: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(text).foregroundColor(Frost.textSecondary)
        }
    }

    private func adviceCard(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Frost.textPrimary)
            Text(body)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(Frost.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Frost.iceLight.opacity(0.5))
        )
    }
}

// MARK: - Thin Chevron

struct ThinChevronRight: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        p.addLine(to: CGPoint(x: 0, y: rect.height))
        return p
    }
}

// MARK: - Color hex extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
