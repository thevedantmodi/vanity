import AppKit
import AVFoundation

class CameraPopup: NSPanel {
    static let popupWidth: CGFloat = 280
    static let popupHeight: CGFloat = 210

    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    init(origin: CGPoint) {
        let frame = CGRect(origin: origin, size: CGSize(width: Self.popupWidth, height: Self.popupHeight))
        super.init(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        backgroundColor = .clear
        isOpaque = false
        hasShadow = true
        level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)) + 1)
        isReleasedWhenClosed = false
        collectionBehavior = [.canJoinAllSpaces, .stationary]

        setupContentView()
        setupCamera()
    }

    private func setupContentView() {
        let container = NSView(frame: CGRect(origin: .zero, size: CGSize(width: Self.popupWidth, height: Self.popupHeight)))
        container.wantsLayer = true
        container.layer?.cornerRadius = 16
        container.layer?.cornerCurve = .continuous
        container.layer?.masksToBounds = true
        contentView = container
    }

    private func setupCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.startCapture()
                } else {
                    self?.showPermissionDenied()
                }
            }
        }
    }

    private func builtInCamera() -> AVCaptureDevice? {
        // Prefer built-in FaceTime camera; Continuity Camera shows up as external
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        )
        return discovery.devices.first ?? AVCaptureDevice.default(for: .video)
    }

    private func startCapture() {
        guard let device = builtInCamera(),
              let input = try? AVCaptureDeviceInput(device: device),
              let view = contentView else { return }

        let session = AVCaptureSession()
        session.sessionPreset = .medium

        guard session.canAddInput(input) else { return }
        session.addInput(input)

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer?.addSublayer(layer)

        captureSession = session
        previewLayer = layer

        session.startRunning()
    }

    private func showPermissionDenied() {
        let label = NSTextField(labelWithString: "Camera access denied.\nEnable in System Settings → Privacy.")
        label.alignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 13)
        label.isEditable = false
        label.isBordered = false
        label.backgroundColor = .clear
        label.frame = CGRect(x: 20, y: Self.popupHeight / 2 - 30, width: Self.popupWidth - 40, height: 60)
        contentView?.addSubview(label)
    }

    override func close() {
        captureSession?.stopRunning()
        captureSession = nil
        previewLayer?.removeFromSuperlayer()
        super.close()
    }
}
