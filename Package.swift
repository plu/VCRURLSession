// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "VCRURLSession",
    platforms: [.iOS(.v11)],
    products: [
        .library(
            name: "VCRURLSession",
            targets: ["VCRURLSession"]
        )
    ],
    targets: [
        .target(
            name: "VCRURLSession",
            path: "VCRURLSession",
            publicHeadersPath: "./",
            cSettings: [
                .define("NS_BLOCK_ASSERTIONS", to: "1")
            ]
        )
    ]
)
