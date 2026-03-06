import AppKit
import SwiftTerm

class TerminalPanelController: NSObject, NSWindowDelegate {
    let session: Session
    let panel: NSPanel
    let terminalView: ObservableTerminalView
    let inputDetector: InputDetector

    private static let claudePath: String = {
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

    init(session: Session) {
        self.session = session
        self.inputDetector = InputDetector(session: session)

        self.terminalView = ObservableTerminalView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
        terminalView.session = session
        terminalView.inputDetector = inputDetector

        self.panel = NSPanel(
            contentRect: NSRect(x: 200, y: 200, width: 800, height: 600),
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
        terminalView.startProcess(
            executable: Self.claudePath,
            args: [],
            environment: nil,
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
