import Foundation

class StorageService {
    static let shared = StorageService()
    
    private let historyKey = "calculation_history"
    private let maxRecords = 50
    
    private init() {}
    
    func saveRecord(_ record: CalculationRecord) {
        var history = loadHistory()
        history.insert(record, at: 0)
        
        if history.count > maxRecords {
            history = Array(history.prefix(maxRecords))
        }
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    func loadHistory() -> [CalculationRecord] {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let history = try? JSONDecoder().decode([CalculationRecord].self, from: data) else {
            return []
        }
        return history
    }
    
    func deleteRecord(_ record: CalculationRecord) {
        var history = loadHistory()
        history.removeAll { $0.id == record.id }
        
        if let encoded = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    func clearHistory() {
        UserDefaults.standard.removeObject(forKey: historyKey)
    }
}
