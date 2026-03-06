import SwiftUI
import AppKit

struct SessionListView: View {
    @ObservedObject var sessionManager: SessionManager
    var dismissPopover: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("ClaudeControl")
                    .font(.headline)
                Spacer()
                Button(action: pickDirectoryAndCreateSession) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Divider()

            if sessionManager.sessions.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "terminal")
                        .font(.system(size: 32))
                        .foregroundStyle(.secondary)
                    Text("No sessions")
                        .foregroundStyle(.secondary)
                    Text("Click + to start a new Claude session")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(sessionManager.sessions) { session in
                            SessionRowView(session: session,
                                           onTap: {
                                sessionManager.showSession(session)
                                dismissPopover()
                            },
                                           onRemove: {
                                sessionManager.removeSession(session)
                            })
                            Divider()
                        }
                    }
                }
            }

            Divider()

            HStack {
                Button("Quit") {
                    NSApp.terminate(nil)
                }
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
                .font(.caption)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
        .frame(width: 320, height: 400)
    }

    private func pickDirectoryAndCreateSession() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Choose a directory for the Claude session"

        if panel.runModal() == .OK, let url = panel.url {
            sessionManager.createSession(directory: url.path)
            dismissPopover()
        }
    }
}
