import Foundation

struct JournalEntry: Codable, Identifiable, Equatable {
    let id: UUID
    var date: Date
    var windDirection: WindDirection
    var windStrength: WindStrength
    var temperatureCelsius: Double?
    var waterBodyShape: WaterBodyShape
    var hoursFished: Double
    var fishCaught: Int
    var species: String
    var notes: String
    var rating: Int // 1-5

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        windDirection: WindDirection = .north,
        windStrength: WindStrength = .moderate,
        temperatureCelsius: Double? = nil,
        waterBodyShape: WaterBodyShape = .circular,
        hoursFished: Double = 0,
        fishCaught: Int = 0,
        species: String = "",
        notes: String = "",
        rating: Int = 3
    ) {
        self.id = id
        self.date = date
        self.windDirection = windDirection
        self.windStrength = windStrength
        self.temperatureCelsius = temperatureCelsius
        self.waterBodyShape = waterBodyShape
        self.hoursFished = hoursFished
        self.fishCaught = fishCaught
        self.species = species
        self.notes = notes
        self.rating = rating
    }

    var formattedDate: String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .none
        fmt.locale = Locale(identifier: "en_US")
        return fmt.string(from: date)
    }

    static func == (lhs: JournalEntry, rhs: JournalEntry) -> Bool {
        lhs.id == rhs.id
    }
}
