import AppKit

enum MenuBarIcon {
    static func create(awaiting: Bool) -> NSImage {
        let size = NSSize(width: 18, height: 18)
        guard let original = NSImage(named: "ClaudeIcon") else {
            return NSImage(size: size)
        }

        if !awaiting {
            original.size = size
            original.isTemplate = true
            return original
        }

        let tinted = NSImage(size: size, flipped: false) { rect in
            original.draw(in: rect)
            NSColor.orange.set()
            rect.fill(using: .sourceAtop)
            return true
        }
        tinted.isTemplate = false
        return tinted
    }
}
