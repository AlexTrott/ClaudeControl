import SwiftUI

enum CCTheme {
    // MARK: - Spacing (8pt grid)
    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
    }

    // MARK: - Corner Radii
    enum Radius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
    }

    // MARK: - Popover Dimensions
    enum Popover {
        static let width: CGFloat = 352
        static let height: CGFloat = 420
        static let headerHeight: CGFloat = 48
        static let footerHeight: CGFloat = 40
        static let rowVerticalPadding: CGFloat = 10
        static let rowHorizontalPadding: CGFloat = 12
        static let listInset: CGFloat = 8
    }

    // MARK: - Status Colors
    enum Status {
        static let running = Color.green
        static let awaiting = Color.orange
        static let stopped = Color(.systemGray)

        static let awaitingTint = Color.orange.opacity(0.12)
    }

    // MARK: - Surface Colors
    enum Surface {
        static let hover = Color.primary.opacity(0.06)
        static let elevated = Color.primary.opacity(0.04)
    }

    // MARK: - Text
    enum Text {
        static let primary = Color.primary
        static let secondary = Color.secondary
        static let tertiary = Color(.tertiaryLabelColor)
    }

    // MARK: - Accent
    static let accent = Color.accentColor

    // MARK: - Fonts
    enum Fonts {
        static let headerTitle = Font.system(.headline, design: .default, weight: .semibold)
        static let sessionName = Font.system(.body, design: .default, weight: .medium)
        static let sessionPath = Font.system(.caption, design: .monospaced, weight: .regular)
        static let badge = Font.system(.caption2, design: .default, weight: .medium)
        static let footerText = Font.system(.caption, design: .default, weight: .regular)
        static let emptyTitle = Font.system(.title3, design: .default, weight: .medium)
        static let emptySubtitle = Font.system(.subheadline, design: .default, weight: .regular)
        static let sessionCount = Font.system(.caption2, design: .rounded, weight: .medium)
    }
}
