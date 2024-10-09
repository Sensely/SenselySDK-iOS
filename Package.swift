// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

// Copyright 2023 Sensely Corporation
//
// Embedded Software Development Kit (SDK)
//
// License Agreement
// Sensely Corporation
//
// Sensely Corporation ("Sensely") has developed an avatar based clinical health care management platform that it makes available as a service (the "Service") to partners that distribute applications designed to operate on the platform.
// This software development kit together with documentation and any updates provided by Sensely ("SDK") is being provided to you as a distribution partner ("Partner") to develop one or more mobile and/or web applications for use with the Service.
// Partner and Sensely have entered into a separate written agreement regarding the distribution of Partner applications using the Service including applications that incorporate or are deployed using this SDK (the "Partner Agreement").
// All terms and conditions of the Partner Agreement and this SDK License Agreement ("License Agreement") apply.
// If you do not have an executed Partner Agreement in place, do not install or use the SDK.
// This License Agreement specifically governs Partner's use of the SDK. BY DOWNLOADING, INSTALLING, OR OTHERWISE ACCESSING OR USING THE SDK, PARTNER AGREES TO BE BOUND BY THE TERMS OF THIS LICENSE AGREEMENT. IF YOU DO NOT AGREE, YOU MAY NOT USE THE SDK.

import PackageDescription

let package = Package(
    name: "SenselySDK",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SenselySDK",
            targets: [ "SenselySDK-Dependencies", "SenselySDK-XCFramework" ]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SenselySDK-Dependencies",
            dependencies: ["Starscream", "Socket-IO"],
            path: "Sources"
        ),
        .binaryTarget(
            name: "Starscream",
            url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Starscream/4.0.5/Starscream.zip",
            checksum: "68c8ddaf30b553b536c5c238a30a8c21d0273d330f1f196e659ce38c3aa634f2"
        ),
        .binaryTarget(
            name: "Socket-IO",
            url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/SocketIO/16.1.1/SocketIO.zip",
            checksum: "52517cac9b4c15189d9e2bb2afcf42166c0b390b4b7577f25506c4fa91ccdbef"
        ),
        .binaryTarget(
            name: "SenselySDK-XCFramework",
            url: "https://nexus.sense.ly/repository/sensely-sdk-ios/com/sensely/SDK/3.14.3/SenselySDK.zip",
            checksum: "c8817eb314d125b3cc9501d577041a0386a7462df506b5c219d3ddcc410bb12b"
         )
    ]
)
