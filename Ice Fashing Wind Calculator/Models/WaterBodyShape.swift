import Foundation

enum WaterBodyShape: String, CaseIterable, Codable {
    case circular = "circular"
    case elongated = "elongated"
    case channel = "channel"
    case wedge = "wedge"
    case freeform = "freeform"

    var label: String {
        switch self {
        case .circular: return "Circular"
        case .elongated: return "Elongated"
        case .channel: return "Channel"
        case .wedge: return "Wedge"
        case .freeform: return "Freeform"
        }
    }

    var hint: String {
        switch self {
        case .circular: return "Round pond or small lake"
        case .elongated: return "Oval or elliptical lake"
        case .channel: return "Narrow river or canal"
        case .wedge: return "Tapered bay or inlet"
        case .freeform: return "Irregular shoreline"
        }
    }
}
