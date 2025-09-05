// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "MultiModuleTemplate",
    dependencies: [
      .package(url: "http://github.com/pointfreeco/swift-composable-architecture", exact: "1.18.0"),
      .package(url: "https://github.com/Roy-wonji/DiContainer.git", from: "1.1.4"),
      .package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.2.2"),
      .package(url: "https://github.com/layoutBox/PinLayout", from: "1.10.6"),
      .package(url: "https://github.com/Roy-wonji/Then", from: "2.7.0"),
      .package(url: "https://github.com/Roy-wonji/LogMacro.git", from: "1.1.0")
    ]
)
