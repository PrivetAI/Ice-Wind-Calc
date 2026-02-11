import Foundation
import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings

    private let service = SettingsService.shared

    init() {
        self.settings = service.load()
    }

    func save() {
        service.save(settings)
    }

    func resetAllData() {
        service.reset()
        JournalService.shared.deleteAll()
        StorageService.shared.removeAll()
        settings = AppSettings()
        save()
    }
}
