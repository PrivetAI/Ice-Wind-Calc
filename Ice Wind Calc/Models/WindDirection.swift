import Foundation

enum WindDirection: String, CaseIterable, Codable {
    case north = "N"
    case northEast = "NE"
    case east = "E"
    case southEast = "SE"
    case south = "S"
    case southWest = "SW"
    case west = "W"
    case northWest = "NW"
    
    var displayName: String {
        switch self {
        case .north: return "North"
        case .northEast: return "Northeast"
        case .east: return "East"
        case .southEast: return "Southeast"
        case .south: return "South"
        case .southWest: return "Southwest"
        case .west: return "West"
        case .northWest: return "Northwest"
        }
    }
    
    var shortName: String {
        return rawValue
    }
    
    var degrees: Double {
        switch self {
        case .north: return 0
        case .northEast: return 45
        case .east: return 90
        case .southEast: return 135
        case .south: return 180
        case .southWest: return 225
        case .west: return 270
        case .northWest: return 315
        }
    }
    
    var opposite: WindDirection {
        switch self {
        case .north: return .south
        case .northEast: return .southWest
        case .east: return .west
        case .southEast: return .northWest
        case .south: return .north
        case .southWest: return .northEast
        case .west: return .east
        case .northWest: return .southEast
        }
    }
    
    var adjacent: [WindDirection] {
        switch self {
        case .north: return [.northEast, .northWest]
        case .northEast: return [.north, .east]
        case .east: return [.northEast, .southEast]
        case .southEast: return [.east, .south]
        case .south: return [.southEast, .southWest]
        case .southWest: return [.south, .west]
        case .west: return [.southWest, .northWest]
        case .northWest: return [.west, .north]
        }
    }
}
