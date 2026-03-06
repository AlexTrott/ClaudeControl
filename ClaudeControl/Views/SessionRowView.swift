import SwiftUI

struct SessionRowView: View {
    @ObservedObject var session: Session
    var onTap: () -> Void
    var onRemove: () -> Void

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: CCTheme.Spacing.md) {
            // Left accent bar
            RoundedRectangle(cornerRadius: 1.5)
                .fill(statusColor)
                .frame(width: 3, height: 28)
                .opacity(session.isRunning ? 1.0 : 0.4)
                .pulsing(when: session.isAwaitingInput)

            VStack(alignment: .leading, spacing: CCTheme.Spacing.xxs) {
                HStack(spacing: CCTheme.Spacing.sm) {
                    Text(session.name)
                        .font(CCTheme.Fonts.sessionName)
                        .foregroundStyle(CCTheme.Text.primary)
                        .lineLimit(1)

                    Spacer(minLength: 0)

                    if session.isAwaitingInput {
                        awaitingBadge
                    }

                    Button(action: onRemove) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(CCTheme.Text.tertiary)
                            .frame(width: 22, height: 22)
                            .background(
                                Circle().fill(CCTheme.Surface.hover)
                            )
                    }
                    .buttonStyle(.plain)
                    .opacity(isHovered ? 1.0 : 0.0)
                    .animation(CCAnimation.hover, value: isHovered)
                }

                HStack(spacing: CCTheme.Spacing.xs) {
                    Text(session.shortDirectory)
                        .font(CCTheme.Fonts.sessionPath)
                        .foregroundStyle(CCTheme.Text.tertiary)
                        .lineLimit(1)
                        .truncationMode(.middle)

                    Spacer(minLength: 0)

                    Text(session.timeAgo)
                        .font(CCTheme.Fonts.footerText)
                        .foregroundStyle(CCTheme.Text.tertiary)
                }
            }
        }
        .padding(.horizontal, CCTheme.Popover.rowHorizontalPadding)
        .padding(.vertical, CCTheme.Popover.rowVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: CCTheme.Radius.md)
                .fill(rowBackground)
                .animation(CCAnimation.hover, value: isHovered)
        )
        .contentShape(RoundedRectangle(cornerRadius: CCTheme.Radius.md))
        .onTapGesture(perform: onTap)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    // MARK: - Awaiting Badge

    private var awaitingBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(CCTheme.Status.awaiting)
                .frame(width: 5, height: 5)
                .pulsing(when: true)

            Text("Input needed")
                .font(CCTheme.Fonts.badge)
                .foregroundStyle(CCTheme.Status.awaiting)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(
            Capsule().fill(CCTheme.Status.awaitingTint)
        )
        .transition(.scale(scale: 0.8).combined(with: .opacity))
    }

    // MARK: - Computed

    private var statusColor: Color {
        if !session.isRunning {
            return CCTheme.Status.stopped
        } else if session.isAwaitingInput {
            return CCTheme.Status.awaiting
        } else {
            return CCTheme.Status.running
        }
    }

    private var rowBackground: Color {
        if session.isAwaitingInput {
            return isHovered
                ? CCTheme.Status.awaitingTint.opacity(1.5)
                : CCTheme.Status.awaitingTint
        }
        return isHovered ? CCTheme.Surface.hover : Color.clear
    }
}
