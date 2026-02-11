import Foundation

final class StorageService {
    static let shared = StorageService()

    private let recordsKey = "ice_fashing_records_v2"
    private let settingsKey = "ice_fashing_settings_v2"
    private let capacity = 80

    private init() {}

    // MARK: - Records

    func persist(_ record: CalculationRecord) {
        var list = fetchAllRecords()
        list.insert(record, at: 0)
        if list.count > capacity {
            list = Array(list.prefix(capacity))
        }
        save(list)
    }

    func fetchAllRecords() -> [CalculationRecord] {
        guard let data = UserDefaults.standard.data(forKey: recordsKey),
              let decoded = try? JSONDecoder().decode([CalculationRecord].self, from: data) else {
            return []
        }
        return decoded
    }

    func remove(_ record: CalculationRecord) {
        var list = fetchAllRecords()
        list.removeAll { $0.id == record.id }
        save(list)
    }

    func removeAll() {
        UserDefaults.standard.removeObject(forKey: recordsKey)
    }

    private func save(_ list: [CalculationRecord]) {
        if let encoded = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encoded, forKey: recordsKey)
        }
    }

    // MARK: - Settings

    func saveLastShape(_ shape: WaterBodyShape) {
        UserDefaults.standard.set(shape.rawValue, forKey: settingsKey + "_shape")
    }

    func loadLastShape() -> WaterBodyShape? {
        guard let raw = UserDefaults.standard.string(forKey: settingsKey + "_shape") else { return nil }
        return WaterBodyShape(rawValue: raw)
    }
}
