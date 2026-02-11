import Foundation

enum TemperatureUnit: String, Codable, CaseIterable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"

    var label: String {
        switch self {
        case .celsius: return "Celsius"
        case .fahrenheit: return "Fahrenheit"
        }
    }

    var symbol: String {
        switch self {
        case .celsius: return "C"
        case .fahrenheit: return "F"
        }
    }
}

enum WindSpeedUnit: String, Codable, CaseIterable {
    case kmh = "kmh"
    case mph = "mph"
    case ms = "ms"

    var label: String {
        switch self {
        case .kmh: return "km/h"
        case .mph: return "mph"
        case .ms: return "m/s"
        }
    }
}

struct AppSettings: Codable {
    var temperatureUnit: TemperatureUnit
    var windSpeedUnit: WindSpeedUnit
    var defaultWaterBody: WaterBodyShape

    init(
        temperatureUnit: TemperatureUnit = .celsius,
        windSpeedUnit: WindSpeedUnit = .kmh,
        defaultWaterBody: WaterBodyShape = .circular
    ) {
        self.temperatureUnit = temperatureUnit
        self.windSpeedUnit = windSpeedUnit
        self.defaultWaterBody = defaultWaterBody
    }
}
