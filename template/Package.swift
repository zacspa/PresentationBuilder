// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Presentation",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "Presentation",
            path: "Sources/Presentation"
        ),
    ]
)
