import Foundation

final class SettingsService {
    static let shared = SettingsService()
    private let key = "ice_fashing_app_settings_v1"
    private init() {}

    func load() -> AppSettings {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) else {
            return AppSettings()
        }
        return decoded
    }

    func save(_ settings: AppSettings) {
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func reset() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
