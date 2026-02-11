import Foundation

final class JournalService {
    static let shared = JournalService()
    private let key = "ice_fashing_journal_v1"
    private init() {}

    func fetchAll() -> [JournalEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) else {
            return []
        }
        return decoded.sorted { $0.date > $1.date }
    }

    func save(_ entry: JournalEntry) {
        var list = fetchAll()
        if let idx = list.firstIndex(where: { $0.id == entry.id }) {
            list[idx] = entry
        } else {
            list.insert(entry, at: 0)
        }
        persist(list)
    }

    func delete(_ entry: JournalEntry) {
        var list = fetchAll()
        list.removeAll { $0.id == entry.id }
        persist(list)
    }

    func deleteAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    private func persist(_ list: [JournalEntry]) {
        if let data = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
