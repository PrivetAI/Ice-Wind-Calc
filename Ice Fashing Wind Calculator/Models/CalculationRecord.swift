import Foundation

struct CalculationRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let timestamp: Date
    let windDirection: WindDirection
    let windStrength: WindStrength
    let waterBodyShape: WaterBodyShape
    let airTemperatureCelsius: Double?

    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        windDirection: WindDirection,
        windStrength: WindStrength,
        waterBodyShape: WaterBodyShape,
        airTemperatureCelsius: Double? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.windDirection = windDirection
        self.windStrength = windStrength
        self.waterBodyShape = waterBodyShape
        self.airTemperatureCelsius = airTemperatureCelsius
    }

    var feedingAdvice: String {
        let target = windDirection.opposite.displayName.lowercased()
        let intensity = windStrength.label.lowercased()
        return "With \(intensity) wind from the \(windDirection.displayName.lowercased()), plankton accumulates near the \(target) shore. Position yourself there for best results."
    }

    var shelterAdvice: String {
        let shelter = windDirection.opposite.displayName.lowercased()
        switch windStrength {
        case .calm:
            return "No shelter needed in calm conditions. Fish anywhere comfortably."
        case .light:
            return "Light wind. A small windbreak facing \(windDirection.displayName.lowercased()) is sufficient."
        case .moderate:
            return "Set up your shelter on the \(shelter) side, angled to block wind from the \(windDirection.displayName.lowercased())."
        case .strong:
            return "Strong wind. Secure your shelter firmly on the \(shelter) shore. Use ice anchors."
        case .gale:
            return "Dangerous conditions. Consider postponing. If you must fish, stay near the \(shelter) shore with full shelter."
        }
    }

    var windChillCelsius: Double? {
        guard let temp = airTemperatureCelsius else { return nil }
        let v = windStrength.averageSpeedMps * 3.6
        guard v > 4.8 else { return temp }
        let wc = 13.12 + 0.6215 * temp - 11.37 * pow(v, 0.16) + 0.3965 * temp * pow(v, 0.16)
        return (wc * 10).rounded() / 10
    }

    var formattedTimestamp: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        fmt.locale = Locale(identifier: "en_US")
        return fmt.string(from: timestamp)
    }

    static func == (lhs: CalculationRecord, rhs: CalculationRecord) -> Bool {
        lhs.id == rhs.id
    }
}
