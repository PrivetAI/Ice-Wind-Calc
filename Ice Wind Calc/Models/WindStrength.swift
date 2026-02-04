import Foundation

enum WindStrength: String, CaseIterable, Codable {
    case weak = "weak"
    case moderate = "moderate"
    case strong = "strong"
    case storm = "storm"
    
    var displayName: String {
        switch self {
        case .weak: return "Weak"
        case .moderate: return "Moderate"
        case .strong: return "Strong"
        case .storm: return "Storm"
        }
    }
    
    var speedRange: String {
        switch self {
        case .weak: return "1-3 m/s"
        case .moderate: return "4-7 m/s"
        case .strong: return "8-14 m/s"
        case .storm: return "15+ m/s"
        }
    }
    
    var description: String {
        switch self {
        case .weak: return "Leaves rustle, slight ripples on water"
        case .moderate: return "Small branches move, small waves form"
        case .strong: return "Large branches sway, whitecaps appear"
        case .storm: return "Whole trees move, foam on waves"
        }
    }
    
    var zoneIntensity: Double {
        switch self {
        case .weak: return 0.4
        case .moderate: return 0.6
        case .strong: return 0.8
        case .storm: return 1.0
        }
    }
}
