// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MySyncApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Shared Library für alle Targets
        .library(
            name: "MySyncAppShared",
            targets: ["MySyncAppShared"]
        ),
        // CLI Executable
        .executable(
            name: "SyncCLI",
            targets: ["SyncCLI"]
        ),
    ],
    dependencies: [
        // Hier können externe Dependencies hinzugefügt werden
        // z.B. für ShellOut: .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.3.0")
    ],
    targets: [
        // Shared Library Target
        .target(
            name: "MySyncAppShared",
            dependencies: [],
            path: "Sources/Shared"
        ),
        // CLI Executable Target
        .executableTarget(
            name: "SyncCLI",
            dependencies: ["MySyncAppShared"],
            path: "Sources/CLI"
        ),
        // Test Targets
        .testTarget(
            name: "MySyncAppSharedTests",
            dependencies: ["MySyncAppShared"],
            path: "Tests/SharedTests",
            exclude: ["Mocks", "Fixtures"] // Exclude wird automatisch gefunden
        ),
        .testTarget(
            name: "SyncCLITests",
            dependencies: ["SyncCLI", "MySyncAppShared"],
            path: "Tests/CLITests"
        ),
    ]
)

