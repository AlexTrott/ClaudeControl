import AppKit
import SwiftTerm

class TerminalPanelController: NSObject, NSWindowDelegate {
    let session: Session
    let panel: NSPanel
    let terminalView: ObservableTerminalView
    let inputDetector: InputDetector
    let resumeSessionId: String?

    private static let shellEnvironment: [String] = {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = ["-ilc", "env"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        try? task.run()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        var env = output.components(separatedBy: "\n").filter {
            $0.contains("=") && !$0.hasPrefix("CLAUDECODE=")
        }
        // Ensure proper terminal color support regardless of launch context
        env.removeAll { $0.hasPrefix("TERM=") || $0.hasPrefix("COLORTERM=") }
        env.append("TERM=xterm-256color")
        env.append("COLORTERM=truecolor")
        return env
    }()

    private static let autoDetectedClaudePath: String = {
        // Resolve claude path once using the user's login shell
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.arguments = ["-ilc", "which claude"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        try? task.run()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let resolved = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !resolved.isEmpty && FileManager.default.fileExists(atPath: resolved) {
            return resolved
        }
        // Fallback to common paths
        let fallbacks = [
            NSString("~/.local/bin/claude").expandingTildeInPath,
            "/usr/local/bin/claude",
            "/opt/homebrew/bin/claude",
        ]
        return fallbacks.first { FileManager.default.fileExists(atPath: $0) } ?? "claude"
    }()

    private static var claudePath: String {
        let custom = AppSettings.shared.customClaudePath
        if !custom.isEmpty && FileManager.default.fileExists(atPath: custom) {
            return custom
        }
        return autoDetectedClaudePath
    }

    init(session: Session, resumeSessionId: String? = nil) {
        self.session = session
        self.resumeSessionId = resumeSessionId
        self.inputDetector = InputDetector(session: session)

        let width = CGFloat(AppSettings.shared.terminalWidth)
        let height = CGFloat(AppSettings.shared.terminalHeight)

        self.terminalView = ObservableTerminalView(frame: NSRect(x: 0, y: 0, width: width, height: height))
        terminalView.session = session
        terminalView.inputDetector = inputDetector

        self.panel = NSPanel(
            contentRect: NSRect(x: 200, y: 200, width: width, height: height),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        super.init()

        panel.title = "Claude - \(session.name)"
        panel.level = .floating
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.contentView = terminalView
        panel.delegate = self
        panel.minSize = NSSize(width: 400, height: 300)
    }

    func startProcess() {
        var args: [String] = []
        if let resumeId = resumeSessionId {
            args = ["--resume", resumeId]
        }
        terminalView.startProcess(
            executable: Self.claudePath,
            args: args,
            environment: Self.shellEnvironment,
            execName: nil,
            currentDirectory: session.directory
        )
        session.isRunning = true
    }

    func stopProcess() {
        terminalView.terminate()
        session.isRunning = false
    }

    func showWindow() {
        panel.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func hideWindow() {
        panel.orderOut(nil)
    }

    // MARK: - NSWindowDelegate

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        hideWindow()
        return false
    }
}
