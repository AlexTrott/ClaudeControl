import SwiftUI

struct PreviousSessionsView: View {
    @ObservedObject var sessionManager: SessionManager
    var onBack: () -> Void
    var onSessionSelected: () -> Void

    @State private var previousSessions: [PreviousSession] = []
    @State private var isLoading = true

    private var groupedSessions: [(projectName: String, sessions: [PreviousSession])] {
        let grouped = Dictionary(grouping: previousSessions, by: \.projectName)
        return grouped.map { (projectName: $0.key, sessions: $0.value) }
            .sorted { group1, group2 in
                let latest1 = group1.sessions.map(\.lastModified).max() ?? .distantPast
                let latest2 = group2.sessions.map(\.lastModified).max() ?? .distantPast
                return latest1 > latest2
            }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView

            Divider().opacity(0.5)

            if isLoading {
                Spacer()
                ProgressView()
                    .controlSize(.small)
                Spacer()
            } else if previousSessions.isEmpty {
                emptyStateView
            } else {
                sessionListView
            }
        }
        .frame(width: CCTheme.Popover.width, height: CCTheme.Popover.height)
        .task {
            let service = sessionManager.historyService
            let sessions = await Task.detached { service.loadPreviousSessions() }.value
            previousSessions = sessions
            isLoading = false
        }
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(spacing: CCTheme.Spacing.sm) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(CCTheme.Text.secondary)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: CCTheme.Radius.sm)
                            .fill(CCTheme.Surface.elevated)
                    )
            }
            .buttonStyle(.plain)

            Text("Previous Sessions")
                .font(CCTheme.Fonts.headerTitle)

            Spacer()
        }
        .padding(.horizontal, CCTheme.Spacing.lg)
        .frame(height: CCTheme.Popover.headerHeight)
    }

    // MARK: - Session List

    private var sessionListView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: CCTheme.Spacing.md) {
                ForEach(groupedSessions, id: \.projectName) { group in
                    VStack(alignment: .leading, spacing: CCTheme.Spacing.xs) {
                        Text(group.projectName)
                            .font(CCTheme.Fonts.sectionHeader)
                            .foregroundStyle(CCTheme.Text.tertiary)
                            .textCase(.uppercase)
                            .padding(.horizontal, CCTheme.Spacing.xs)

                        ForEach(group.sessions) { session in
                            PreviousSessionRowView(session: session) {
                                sessionManager.resumeSession(session)
                                onSessionSelected()
                            }
                        }
                    }
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

            Image(systemName: "clock")
                .font(.system(size: 32, weight: .light))
                .foregroundStyle(CCTheme.Text.tertiary)

            Text("No previous sessions found")
                .font(CCTheme.Fonts.emptySubtitle)
                .foregroundStyle(CCTheme.Text.secondary)

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Row View

private struct PreviousSessionRowView: View {
    let session: PreviousSession
    var onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: CCTheme.Spacing.xxs) {
            Text(session.displayTitle)
                .font(CCTheme.Fonts.promptPreview)
                .foregroundStyle(CCTheme.Text.primary)
                .lineLimit(2)

            HStack(spacing: CCTheme.Spacing.xs) {
                Text(session.shortDirectory)
                    .font(CCTheme.Fonts.sessionPath)
                    .foregroundStyle(CCTheme.Text.tertiary)
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer(minLength: 0)

                if let branch = session.gitBranch {
                    Text(branch)
                        .font(CCTheme.Fonts.sessionPath)
                        .foregroundStyle(CCTheme.Text.tertiary)
                        .lineLimit(1)
                }

                Text(session.timeAgo)
                    .font(CCTheme.Fonts.footerText)
                    .foregroundStyle(CCTheme.Text.tertiary)
            }
        }
        .padding(.horizontal, CCTheme.Popover.rowHorizontalPadding)
        .padding(.vertical, CCTheme.Popover.rowVerticalPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: CCTheme.Radius.md)
                .fill(isHovered ? CCTheme.Surface.hover : Color.clear)
                .animation(CCAnimation.hover, value: isHovered)
        )
        .contentShape(RoundedRectangle(cornerRadius: CCTheme.Radius.md))
        .onTapGesture(perform: onTap)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
