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
        dependencies: ["Starscream", "Socket-IO", "GoogleSignIn", "GTMAppAuth", "GTMSessionFetcher", "AppAuth"],
        path: "Sources"
    ),
    .binaryTarget(
        name: "GoogleSignIn",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Firebase-10.14.0/GoogleSignIn/GoogleSignIn.zip",
        checksum: "686a3473e74878497c52472a49c809bae1b0c9a85cc7ea63118069c2e277148d"
    ),
    .binaryTarget(
        name: "GTMAppAuth",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Firebase-10.14.0/GoogleSignIn/GTMAppAuth.zip",
        checksum: "c095ad26ef733c25e00c738c0683bc07bb6ff96e018496e6dfe07fb15551cadb"
    ),
    .binaryTarget(
        name: "GTMSessionFetcher",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Firebase-10.14.0/GoogleSignIn/GTMSessionFetcher.zip",
        checksum: "5b0d28fc60eeaaefa9aa6a8cd9a782bda12e3bfc38be963b71fd5220feadb585"
    ),
    .binaryTarget(
        name: "AppAuth",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Firebase-10.14.0/GoogleSignIn/AppAuth.zip",
        checksum: "e4af190c10010bcfb4454b7b909471e34abcb2c4a5fdcdc3d251ce038eb952b5"
    ),
    .binaryTarget(
        name: "Starscream",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/Starscream/4.0.4/Starscream.zip",
        checksum: "cfaea87092ca07a534b5a7614ef8a01b766f40478f14bf57c99acaf9dc0ab0bd"
    ),
    .binaryTarget(
        name: "Socket-IO",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios-dependencies/SocketIO/16.1.0/SocketIO.zip",
        checksum: "789078112529d31092d924d27e551f1dd619bf244d4200a98317491852a8e60d"
    ),
    .binaryTarget(
        name: "SenselySDK-XCFramework",
        url: "https://nexus.sense.ly/repository/sensely-sdk-ios/com/sensely/SDK/3.14.2/SenselySDK.zip",
        checksum: "3e5e26e9627c51eb4bebe7191bba8baf63444c4270480b57bfb1463b056dcc17"
     )
  ]
)
