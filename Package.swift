// swift-tools-version: 6.0
import PackageDescription
import class Foundation.ProcessInfo

// swift-docc-plugin is a build-tool plugin used only to generate the DocC API
// reference. A top-level package dependency is resolved into EVERY consumer's
// graph (SwiftPM doesn't prune the resolution closure), so gate it behind an env
// var — set LOVELETTER_BUILD_DOCS=1 in the docs-generation step — to keep it out
// of adopters' checkouts. The docs site's regen script
// (loveletter-docs/scripts/regen-api-refs.sh) sets this when generating DocC.
let buildingDocs = ProcessInfo.processInfo.environment["LOVELETTER_BUILD_DOCS"] != nil
let doccPluginDependencies: [Package.Dependency] = buildingDocs
    ? [.package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0")]
    : []

let package = Package(
    name: "LoveLetterSDK",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "LoveLetterCore", targets: ["LoveLetterCore"]),
        .library(name: "LoveLetterUI", targets: ["LoveLetterUI"]),
    ],
    dependencies: doccPluginDependencies,
    targets: [
        .target(name: "LoveLetterCore"),
        .target(
            name: "LoveLetterUI",
            dependencies: ["LoveLetterCore"]
        ),
        .testTarget(
            name: "LoveLetterCoreTests",
            dependencies: ["LoveLetterCore"],
            resources: [.copy("Fixtures")]
        ),
        .testTarget(
            name: "LoveLetterUITests",
            dependencies: ["LoveLetterUI"]
        ),
    ]
)
