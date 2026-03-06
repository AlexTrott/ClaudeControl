import Foundation

struct PreviousSession: Identifiable {
    let id: String
    let projectName: String
    let directory: String
    let firstPrompt: String?
    let gitBranch: String?
    let lastModified: Date

    var shortDirectory: String {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        if directory.hasPrefix(home) {
            return "~" + directory.dropFirst(home.count)
        }
        return directory
    }

    var timeAgo: String {
        let interval = Date().timeIntervalSince(lastModified)
        if interval < 60 { return "now" }
        if interval < 3600 { return "\(Int(interval / 60))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }

    var displayTitle: String {
        if let prompt = firstPrompt, !prompt.isEmpty {
            return prompt
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Session from \(formatter.string(from: lastModified))"
    }
}
