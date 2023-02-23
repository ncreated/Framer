// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Framer",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "Framer",
            targets: ["Framer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/ncreated/Framing.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Framer",
            dependencies: [
                .product(name: "Framing", package: "Framing"),
            ]
        ),
        .testTarget(
            name: "FramerTests",
            dependencies: [
                .target(name: "Framer"),
                .productItem(name: "Framing", package: "Framing")
            ]
        ),
    ]
)
