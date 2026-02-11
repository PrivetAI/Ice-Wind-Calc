import Foundation
import SwiftUI
import Combine

final class AppViewModel: ObservableObject {
    // MARK: - Published state
    @Published var chosenDirection: WindDirection = .north
    @Published var chosenStrength: WindStrength = .moderate
    @Published var chosenShape: WaterBodyShape = .circular
    @Published var airTemperatureText: String = ""
    @Published var records: [CalculationRecord] = []
    @Published var activeRecord: CalculationRecord?
    @Published var showHistorySheet: Bool = false
    @Published var showSettingsSheet: Bool = false
    @Published var showInfoSheet: Bool = false

    private let storage = StorageService.shared

    init() {
        records = storage.fetchAllRecords()
        if let saved = storage.loadLastShape() {
            chosenShape = saved
        }
    }

    // MARK: - Actions

    func analyze() {
        let temp: Double? = Double(airTemperatureText)
        let record = CalculationRecord(
            windDirection: chosenDirection,
            windStrength: chosenStrength,
            waterBodyShape: chosenShape,
            airTemperatureCelsius: temp
        )
        storage.persist(record)
        storage.saveLastShape(chosenShape)
        activeRecord = record
        records = storage.fetchAllRecords()
    }

    func removeRecord(_ record: CalculationRecord) {
        storage.remove(record)
        records = storage.fetchAllRecords()
        if activeRecord?.id == record.id {
            activeRecord = nil
        }
    }

    func restoreRecord(_ record: CalculationRecord) {
        chosenDirection = record.windDirection
        chosenStrength = record.windStrength
        chosenShape = record.waterBodyShape
        if let t = record.airTemperatureCelsius {
            airTemperatureText = String(format: "%.0f", t)
        } else {
            airTemperatureText = ""
        }
        activeRecord = record
        showHistorySheet = false
    }

    func purgeAllRecords() {
        storage.removeAll()
        records = []
        activeRecord = nil
    }

    var currentFeedingAdvice: String {
        if let r = activeRecord { return r.feedingAdvice }
        let target = chosenDirection.opposite.displayName.lowercased()
        return "Fish tend to feed near the \(target) shore due to plankton drift."
    }

    var currentShelterAdvice: String {
        if let r = activeRecord { return r.shelterAdvice }
        return "Tap Analyze to get shelter positioning advice."
    }

    var currentWindChill: Double? {
        activeRecord?.windChillCelsius
    }
}
