import AppKit
import SwiftUI
import Combine
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    let sessionManager = SessionManager()
    private var eventMonitor: Any?
    private var badgeCancellable: AnyCancellable?
    private var wasAwaiting = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem.button {
            button.image = MenuBarIcon.create(awaiting: false)
            button.action = #selector(togglePopover)
            button.target = self
        }

        popover = NSPopover()
        popover.contentSize = NSSize(width: CCTheme.Popover.width, height: CCTheme.Popover.height)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: SessionListView(sessionManager: sessionManager, dismissPopover: { [weak self] in
                self?.popover.performClose(nil)
            })
        )

        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            if let popover = self?.popover, popover.isShown {
                popover.performClose(nil)
            }
        }

        badgeCancellable = sessionManager.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    let awaiting = self.sessionManager.hasAnyAwaitingInput
                    self.updateBadge(awaiting: awaiting)

                    if awaiting && !self.wasAwaiting {
                        self.sendAwaitingNotification()
                    }
                    self.wasAwaiting = awaiting
                }
            }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func updateBadge(awaiting: Bool) {
        guard let button = statusItem.button else { return }
        let effectiveAwaiting = awaiting && AppSettings.shared.iconTintEnabled
        button.image = MenuBarIcon.create(awaiting: effectiveAwaiting)
    }

    private func sendAwaitingNotification() {
        guard AppSettings.shared.notificationsEnabled else { return }

        let waitingSessions = sessionManager.sessions.filter { $0.isAwaitingInput }
        guard !waitingSessions.isEmpty else { return }

        let content = UNMutableNotificationContent()
        if waitingSessions.count == 1, let session = waitingSessions.first {
            content.title = "Claude - \(session.name)"
            content.body = "Waiting for your input"
        } else {
            content.title = "ClaudeControl"
            content.body = "\(waitingSessions.count) sessions waiting for input"
        }
        content.sound = .default

        let request = UNNotificationRequest(identifier: "awaiting-input", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
    }
}
