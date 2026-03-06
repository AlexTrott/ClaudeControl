import AppKit

enum MenuBarIcon {
    static func create(awaiting: Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        let image = NSImage(size: size, flipped: false) { rect in
            let color: NSColor = awaiting ? .orange : .controlTextColor

            // Head: rounded rectangle, centered
            let headRect = NSRect(x: 3, y: 3, width: 12, height: 12)
            let headPath = NSBezierPath(roundedRect: headRect, xRadius: 4, yRadius: 4)
            color.setFill()
            headPath.fill()

            // Eyes: two small circles
            let eyeColor: NSColor = awaiting ? .white : .windowBackgroundColor
            eyeColor.setFill()

            let leftEye = NSBezierPath(ovalIn: NSRect(x: 5.5, y: 7.5, width: 2.5, height: 2.5))
            leftEye.fill()

            let rightEye = NSBezierPath(ovalIn: NSRect(x: 10, y: 7.5, width: 2.5, height: 2.5))
            rightEye.fill()

            return true
        }

        image.isTemplate = !awaiting
        return image
    }
}
