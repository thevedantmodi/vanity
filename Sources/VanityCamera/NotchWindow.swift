import AppKit

// Transparent window sitting exactly over the notch — captures clicks there
// without requiring Accessibility permissions
class NotchWindow: NSWindow {
    private let onClick: () -> Void

    init(frame: CGRect, onClick: @escaping () -> Void) {
        self.onClick = onClick
        super.init(
            contentRect: frame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        backgroundColor = .clear
        isOpaque = false
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)) + 1)
        ignoresMouseEvents = false
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        isReleasedWhenClosed = false

        let view = NotchClickView(frame: CGRect(origin: .zero, size: frame.size))
        view.onClick = onClick
        contentView = view
        orderFrontRegardless()
    }
}

private class NotchClickView: NSView {
    var onClick: (() -> Void)?

    override func mouseDown(with event: NSEvent) {
        onClick?()
    }

    // Transparent but still hits mouse events
    override func hitTest(_ point: NSPoint) -> NSView? {
        return self
    }
}
