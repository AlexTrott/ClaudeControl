import SwiftUI

struct SessionRowView: View {
    @ObservedObject var session: Session
    var onTap: () -> Void
    var onRemove: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(session.name)
                    .font(.system(.body, weight: .medium))
                    .lineLimit(1)
                Text(session.directory)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .truncationMode(.head)
            }

            Spacer()

            if session.isAwaitingInput {
                Text("Waiting")
                    .font(.caption2)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(.yellow.opacity(0.2))
                    .foregroundStyle(.yellow)
                    .clipShape(Capsule())
            }

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    private var statusColor: Color {
        if !session.isRunning {
            return .gray
        } else if session.isAwaitingInput {
            return .yellow
        } else {
            return .green
        }
    }
}
