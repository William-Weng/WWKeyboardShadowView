// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWKeyboardShadowView",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "WWKeyboardShadowView", targets: ["WWKeyboardShadowView"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWKeyboardShadowView", resources: [.process("Xib"), .copy("Privacy")]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
