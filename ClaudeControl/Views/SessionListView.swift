import SwiftUI
import AppKit

struct SessionListView: View {
    @ObservedObject var sessionManager: SessionManager
    var dismissPopover: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            headerView

            Divider().opacity(0.5)

            if sessionManager.sessions.isEmpty {
                emptyStateView
            } else {
                sessionListView
            }

            Divider().opacity(0.5)

            footerView
        }
        .frame(width: CCTheme.Popover.width, height: CCTheme.Popover.height)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: CCTheme.Spacing.sm) {
            // Inline Claude face icon
            Image(nsImage: MenuBarIcon.create(awaiting: false))
                .resizable()
                .frame(width: 16, height: 16)

            Text("ClaudeControl")
                .font(CCTheme.Fonts.headerTitle)

            Spacer()

            if !sessionManager.sessions.isEmpty {
                Text("\(sessionManager.sessions.count)")
                    .font(CCTheme.Fonts.sessionCount)
                    .foregroundStyle(CCTheme.Text.tertiary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule().fill(CCTheme.Surface.elevated)
                    )
            }

            Button(action: pickDirectoryAndCreateSession) {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(CCTheme.accent)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: CCTheme.Radius.sm)
                            .fill(CCTheme.Surface.elevated)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, CCTheme.Spacing.lg)
        .frame(height: CCTheme.Popover.headerHeight)
    }

    // MARK: - Session List

    private var sessionListView: some View {
        ScrollView {
            LazyVStack(spacing: CCTheme.Spacing.xs) {
                ForEach(sessionManager.sessions) { session in
                    SessionRowView(
                        session: session,
                        onTap: {
                            sessionManager.showSession(session)
                            dismissPopover()
                        },
                        onRemove: {
                            withAnimation(CCAnimation.spring) {
                                sessionManager.removeSession(session)
                            }
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.95).combined(with: .opacity),
                        removal: .scale(scale: 0.95).combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal, CCTheme.Popover.listInset)
            .padding(.vertical, CCTheme.Spacing.sm)
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: CCTheme.Spacing.md) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                CCTheme.accent.opacity(0.15),
                                CCTheme.accent.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)

                Image(systemName: "terminal")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(CCTheme.accent.opacity(0.8))
            }

            VStack(spacing: CCTheme.Spacing.xs) {
                Text("No Active Sessions")
                    .font(CCTheme.Fonts.emptyTitle)
                    .foregroundStyle(CCTheme.Text.primary)

                Text("Start a Claude session in any project directory")
                    .font(CCTheme.Fonts.emptySubtitle)
                    .foregroundStyle(CCTheme.Text.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: pickDirectoryAndCreateSession) {
                HStack(spacing: CCTheme.Spacing.xs) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                    Text("New Session")
                        .font(.system(.subheadline, weight: .medium))
                }
                .foregroundStyle(.white)
                .padding(.horizontal, CCTheme.Spacing.lg)
                .padding(.vertical, CCTheme.Spacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: CCTheme.Radius.md)
                        .fill(CCTheme.accent)
                )
            }
            .buttonStyle(.plain)
            .padding(.top, CCTheme.Spacing.xs)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Footer

    private var footerView: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "gearshape")
                    .font(.system(size: 12))
                    .foregroundStyle(CCTheme.Text.tertiary)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("v1.0")
                .font(CCTheme.Fonts.footerText)
                .foregroundStyle(CCTheme.Text.tertiary)

            Spacer()

            Button(action: { NSApp.terminate(nil) }) {
                Text("Quit")
                    .font(CCTheme.Fonts.footerText)
                    .foregroundStyle(CCTheme.Text.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, CCTheme.Spacing.lg)
        .frame(height: CCTheme.Popover.footerHeight)
    }

    // MARK: - Actions

    private func pickDirectoryAndCreateSession() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Choose a directory for the Claude session"

        if panel.runModal() == .OK, let url = panel.url {
            withAnimation(CCAnimation.listInsert) {
                sessionManager.createSession(directory: url.path)
            }
            dismissPopover()
        }
    }
}
