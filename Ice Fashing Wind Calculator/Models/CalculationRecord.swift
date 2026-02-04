import Foundation

struct CalculationRecord: Codable, Identifiable {
    let id: UUID
    let date: Date
    let windDirection: WindDirection
    let windStrength: WindStrength
    let waterBodyShape: WaterBodyShape
    
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        windDirection: WindDirection,
        windStrength: WindStrength,
        waterBodyShape: WaterBodyShape
    ) {
        self.id = id
        self.date = date
        self.windDirection = windDirection
        self.windStrength = windStrength
        self.waterBodyShape = waterBodyShape
    }
    
    var feedingZoneDescription: String {
        let oppositeDirection = windDirection.opposite.displayName.lowercased()
        return "Fish will be feeding near the \(oppositeDirection) shore. Wind pushes plankton there."
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
