import Foundation

class InputDetector: @unchecked Sendable {
    weak var session: Session?

    private var idleWorkItem: DispatchWorkItem?
    private var recentOutputBuffer: String = ""
    private let bufferMaxLength = 2000
    private let lock = NSLock()

    private let promptPatterns: [String] = [
        "\u{276F}",
        "> ",
        "Allow? (y/n)",
        "Do you want to proceed",
        "(y)es, (n)o",
        "Press Enter",
        "? (y/n)",
    ]

    private let idleThreshold: TimeInterval = 2.0

    init(session: Session) {
        self.session = session
    }

    func processOutput(_ data: ArraySlice<UInt8>) {
        let text = String(bytes: data, encoding: .utf8) ?? ""
        let cleaned = stripANSI(text)

        lock.lock()
        recentOutputBuffer += cleaned
        if recentOutputBuffer.count > bufferMaxLength {
            recentOutputBuffer = String(recentOutputBuffer.suffix(bufferMaxLength))
        }
        let bufferSnapshot = recentOutputBuffer
        lock.unlock()

        markAwaitingInput(false)
        resetIdleTimer(bufferSnapshot: bufferSnapshot)
        checkForPromptPatterns(in: bufferSnapshot)
    }

    private func checkForPromptPatterns(in buffer: String) {
        let lastChunk = String(buffer.suffix(500))

        for pattern in promptPatterns {
            if lastChunk.contains(pattern) {
                markAwaitingInput(true)
                return
            }
        }
    }

    private func resetIdleTimer(bufferSnapshot: String) {
        idleWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.handleIdleTimeout(bufferSnapshot: bufferSnapshot)
        }
        idleWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + idleThreshold, execute: workItem)
    }

    private func handleIdleTimeout(bufferSnapshot: String) {
        lock.lock()
        let currentBuffer = recentOutputBuffer
        lock.unlock()

        let lines = currentBuffer.components(separatedBy: "\n")
        guard let lastLine = lines.last(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) else { return }

        let trimmed = lastLine.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.hasSuffix(">") || trimmed.hasSuffix("\u{276F}") ||
           trimmed.contains("(y/n)") || trimmed.contains("?") {
            markAwaitingInput(true)
        }
    }

    private func markAwaitingInput(_ awaiting: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.session?.isAwaitingInput = awaiting
        }
    }

    private func stripANSI(_ text: String) -> String {
        let pattern = "\u{1B}\\[[0-9;]*[a-zA-Z]"
        return text.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
    }
}
