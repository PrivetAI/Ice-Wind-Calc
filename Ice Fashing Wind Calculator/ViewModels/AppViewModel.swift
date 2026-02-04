import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var selectedWindDirection: WindDirection = .north
    @Published var selectedWindStrength: WindStrength = .moderate
    @Published var selectedWaterBodyShape: WaterBodyShape = .circle
    @Published var history: [CalculationRecord] = []
    @Published var currentRecord: CalculationRecord?
    
    private let storageService = StorageService.shared
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        history = storageService.loadHistory()
    }
    
    func calculateAndSave() {
        let record = CalculationRecord(
            windDirection: selectedWindDirection,
            windStrength: selectedWindStrength,
            waterBodyShape: selectedWaterBodyShape
        )
        
        storageService.saveRecord(record)
        currentRecord = record
        loadHistory()
    }
    
    func deleteRecord(_ record: CalculationRecord) {
        storageService.deleteRecord(record)
        loadHistory()
    }
    
    func selectHistoryRecord(_ record: CalculationRecord) {
        currentRecord = record
        selectedWindDirection = record.windDirection
        selectedWindStrength = record.windStrength
        selectedWaterBodyShape = record.waterBodyShape
    }
    
    func getFeedingZoneDescription() -> String {
        if let record = currentRecord {
            return record.feedingZoneDescription
        }
        
        let oppositeDirection = selectedWindDirection.opposite.displayName.lowercased()
        return "Fish will be feeding near the \(oppositeDirection) shore. Wind pushes plankton there."
    }
}
