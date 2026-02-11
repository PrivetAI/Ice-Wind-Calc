import Foundation

enum WindStrength: String, CaseIterable, Codable {
    case calm = "calm"
    case light = "light"
    case moderate = "moderate"
    case strong = "strong"
    case gale = "gale"

    var label: String {
        switch self {
        case .calm: return "Calm"
        case .light: return "Light"
        case .moderate: return "Moderate"
        case .strong: return "Strong"
        case .gale: return "Gale"
        }
    }

    var speedRangeText: String {
        switch self {
        case .calm: return "0-1 m/s"
        case .light: return "2-4 m/s"
        case .moderate: return "5-8 m/s"
        case .strong: return "9-14 m/s"
        case .gale: return "15+ m/s"
        }
    }

    var briefDescription: String {
        switch self {
        case .calm: return "Smoke rises vertically, mirror-like water"
        case .light: return "Gentle breeze, small ripples on surface"
        case .moderate: return "Steady wind, small waves with crests"
        case .strong: return "Trees sway, whitecaps common"
        case .gale: return "Difficult to walk, foam streaks on water"
        }
    }

    var intensityFactor: Double {
        switch self {
        case .calm: return 0.1
        case .light: return 0.35
        case .moderate: return 0.55
        case .strong: return 0.78
        case .gale: return 1.0
        }
    }

    var averageSpeedMps: Double {
        switch self {
        case .calm: return 0.5
        case .light: return 3.0
        case .moderate: return 6.5
        case .strong: return 11.5
        case .gale: return 18.0
        }
    }

    var orderIndex: Int {
        switch self {
        case .calm: return 0
        case .light: return 1
        case .moderate: return 2
        case .strong: return 3
        case .gale: return 4
        }
    }
}
