import Foundation

class SessionHistoryService {

    private static let claudeProjectsPath: String = {
        let home = FileManager.default.homeDirectoryForCurrentUser.path
        return "\(home)/.claude/projects"
    }()

    nonisolated func loadPreviousSessions() -> [PreviousSession] {
        let fm = FileManager.default
        let projectsPath = Self.claudeProjectsPath

        guard let projectDirs = try? fm.contentsOfDirectory(atPath: projectsPath) else {
            return []
        }

        var sessions: [PreviousSession] = []

        for dir in projectDirs {
            // Skip the root "-" directory (no real project sessions)
            guard dir != "-" else { continue }

            let projectPath = (projectsPath as NSString).appendingPathComponent(dir)
            var isDirectory: ObjCBool = false
            guard fm.fileExists(atPath: projectPath, isDirectory: &isDirectory),
                  isDirectory.boolValue else { continue }

            guard let files = try? fm.contentsOfDirectory(atPath: projectPath) else { continue }

            for file in files where file.hasSuffix(".jsonl") {
                let filePath = (projectPath as NSString).appendingPathComponent(file)
                let sessionId = String(file.dropLast(6)) // remove ".jsonl"

                guard let attrs = try? fm.attributesOfItem(atPath: filePath),
                      let modDate = attrs[.modificationDate] as? Date else { continue }

                if let session = parseSessionMetadata(
                    filePath: filePath,
                    sessionId: sessionId,
                    lastModified: modDate
                ) {
                    sessions.append(session)
                }
            }
        }

        return sessions.sorted { $0.lastModified > $1.lastModified }
    }

    private nonisolated func parseSessionMetadata(
        filePath: String,
        sessionId: String,
        lastModified: Date
    ) -> PreviousSession? {
        guard let handle = FileHandle(forReadingAtPath: filePath) else { return nil }
        let data = handle.readData(ofLength: 8192)
        handle.closeFile()

        guard let text = String(data: data, encoding: .utf8) else { return nil }

        var cwd: String?
        var gitBranch: String?
        var firstPrompt: String?

        for line in text.components(separatedBy: "\n") {
            guard !line.isEmpty else { continue }
            guard let lineData = line.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: lineData) as? [String: Any] else {
                continue
            }

            let type = json["type"] as? String ?? ""

            // Extract cwd and gitBranch from any entry that has them
            if cwd == nil, let c = json["cwd"] as? String, !c.isEmpty {
                cwd = c
            }
            if gitBranch == nil, let b = json["gitBranch"] as? String, !b.isEmpty {
                gitBranch = b
            }

            // Extract first real user prompt
            if firstPrompt == nil, type == "user" {
                let isMeta = json["isMeta"] as? Bool ?? false
                guard !isMeta else { continue }

                if let message = json["message"] as? [String: Any],
                   let content = message["content"] {
                    let promptText: String?
                    if let str = content as? String {
                        promptText = str
                    } else if let arr = content as? [[String: Any]] {
                        promptText = arr.first(where: { $0["type"] as? String == "text" })?["text"] as? String
                    } else {
                        promptText = nil
                    }

                    if let text = promptText {
                        // Skip system-injected content
                        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !trimmed.hasPrefix("<") {
                            let collapsed = trimmed.components(separatedBy: .whitespacesAndNewlines)
                                .filter { !$0.isEmpty }
                                .joined(separator: " ")
                            firstPrompt = String(collapsed.prefix(100))
                        }
                    }
                }
            }

            // Stop early once we have everything
            if cwd != nil && firstPrompt != nil {
                break
            }
        }

        guard let directory = cwd else { return nil }

        let projectName = (directory as NSString).lastPathComponent

        return PreviousSession(
            id: sessionId,
            projectName: projectName,
            directory: directory,
            firstPrompt: firstPrompt,
            gitBranch: gitBranch,
            lastModified: lastModified
        )
    }
}
