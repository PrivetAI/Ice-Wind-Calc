import Foundation

enum WaterBodyShape: String, CaseIterable, Codable {
    case circle = "circle"
    case oval = "oval"
    case river = "river"
    case triangle = "triangle"
    case irregular = "irregular"
    
    var displayName: String {
        switch self {
        case .circle: return "Circle"
        case .oval: return "Oval"
        case .river: return "River"
        case .triangle: return "Triangle"
        case .irregular: return "Irregular"
        }
    }
    
    var description: String {
        switch self {
        case .circle: return "Round pond or lake"
        case .oval: return "Oval shaped lake"
        case .river: return "Long narrow water body"
        case .triangle: return "Triangular reservoir"
        case .irregular: return "Complex shoreline"
        }
    }
}
