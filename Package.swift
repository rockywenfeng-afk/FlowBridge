// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DXManagerMac",
    platforms: [.macOS(.v12)],
    products: [.executable(name: "DXManagerMac", targets: ["DXManagerMac"])],
    targets: [
        .target(name: "DXManagerCore", swiftSettings: [.unsafeFlags(["-swift-version", "5"])]),
        .executableTarget(name: "DXManagerMac", dependencies: ["DXManagerCore"], swiftSettings: [.unsafeFlags(["-swift-version", "5"])]),
        .executableTarget(name: "DXManagerCoreTests", dependencies: ["DXManagerCore"], swiftSettings: [.unsafeFlags(["-swift-version", "5"])])
    ]
)
