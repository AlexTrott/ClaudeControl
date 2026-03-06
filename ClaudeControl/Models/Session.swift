import Foundation
import Combine

class Session: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    let directory: String
    @Published var isAwaitingInput: Bool = false
    @Published var isRunning: Bool = false
    let createdAt: Date

    var panelController: TerminalPanelController?

    init(name: String, directory: String) {
        self.name = name
        self.directory = directory
        self.createdAt = Date()
    }

    var shortDirectory: String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if directory.hasPrefix(home) {
            return "~" + directory.dropFirst(home.count)
        }
        return directory
    }

    var timeAgo: String {
        let interval = Date().timeIntervalSince(createdAt)
        if interval < 60 { return "now" }
        if interval < 3600 { return "\(Int(interval / 60))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }
}
