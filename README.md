# Vanity

macOS menu bar app that shows a live camera feed when you click the notch.

## Requirements

- macOS 13+
- MacBook with notch (Pro 2021+, Air 2022+)
- Swift toolchain

## Build & Run

```bash
./build.sh
open VanityCamera.app
```

## Usage

- **Click the notch** to toggle the camera popup
- **Click the menu bar icon** to toggle it too
- Camera permission prompt appears on first launch

## How it works

A transparent `NSWindow` sits over the notch at menu bar level, capturing clicks there without needing Accessibility permissions. Clicking opens an `NSPanel` with a live `AVCaptureVideoPreviewLayer` using the built-in FaceTime camera.
