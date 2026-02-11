import Foundation
import CoreGraphics

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
        case .northEast: return "North-East"
        case .east: return "East"
        case .southEast: return "South-East"
        case .south: return "South"
        case .southWest: return "South-West"
        case .west: return "West"
        case .northWest: return "North-West"
        }
    }

    var shortName: String { rawValue }

    var angleDegrees: Double {
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

    var angleRadians: CGFloat {
        CGFloat(angleDegrees) * .pi / 180.0
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

    var neighborDirections: [WindDirection] {
        let all = WindDirection.allCases
        guard let idx = all.firstIndex(of: self) else { return [] }
        let prev = all[(idx - 1 + all.count) % all.count]
        let next = all[(idx + 1) % all.count]
        return [prev, next]
    }

    static func nearest(toDegrees deg: Double) -> WindDirection {
        var normalized = deg.truncatingRemainder(dividingBy: 360)
        if normalized < 0 { normalized += 360 }
        let index = Int(((normalized + 22.5) / 45).truncatingRemainder(dividingBy: 8))
        return allCases[index]
    }
}
