// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "VanityCamera",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "VanityCamera",
            path: "Sources/VanityCamera"
        )
    ]
)
