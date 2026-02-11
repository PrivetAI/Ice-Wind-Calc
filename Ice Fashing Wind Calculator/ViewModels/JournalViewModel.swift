import Foundation
import SwiftUI

final class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    private let service = JournalService.shared

    init() { reload() }

    func reload() {
        entries = service.fetchAll()
    }

    func save(_ entry: JournalEntry) {
        service.save(entry)
        reload()
    }

    func delete(_ entry: JournalEntry) {
        service.delete(entry)
        reload()
    }

    func deleteAll() {
        service.deleteAll()
        reload()
    }
}
