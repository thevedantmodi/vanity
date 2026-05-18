import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var notchWindow: NotchWindow?
    private var cameraPopup: CameraPopup?

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupStatusItem()
        setupNotchWindow()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "camera.fill", accessibilityDescription: "VanityCamera")
            button.action = #selector(statusItemClicked)
            button.target = self
        }
    }

    private func setupNotchWindow() {
        guard let screen = NSScreen.main else { return }
        let notchRect = screen.notchRect
        guard notchRect != .zero else { return }

        notchWindow = NotchWindow(frame: notchRect) { [weak self] in
            self?.togglePopup()
        }
    }

    @objc private func statusItemClicked() {
        togglePopup()
    }

    private func togglePopup() {
        if let popup = cameraPopup, popup.isVisible {
            popup.close()
            cameraPopup = nil
            return
        }
        guard let screen = NSScreen.main else { return }
        let notchRect = screen.notchRect
        let popupOrigin = CGPoint(
            x: notchRect.midX - CameraPopup.popupWidth / 2,
            y: screen.frame.height - notchRect.height - CameraPopup.popupHeight - 4
        )
        cameraPopup = CameraPopup(origin: popupOrigin)
        cameraPopup?.makeKeyAndOrderFront(nil)
    }
}

extension NSScreen {
    var notchRect: CGRect {
        guard let leftArea = auxiliaryTopLeftArea,
              let rightArea = auxiliaryTopRightArea else {
            return .zero
        }
        let notchWidth = frame.width - leftArea.width - rightArea.width
        guard notchWidth > 0 else { return .zero }
        let notchX = leftArea.width
        let notchY = frame.height - safeAreaInsets.top
        return CGRect(x: notchX, y: notchY, width: notchWidth, height: safeAreaInsets.top)
    }
}
