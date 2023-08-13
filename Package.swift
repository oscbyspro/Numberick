// swift-tools-version: 5.8
//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import PackageDescription

//*============================================================================*
// MARK: * Numberick
//*============================================================================*

let withStaticBigInt = true

//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

var package = Package(
    name: "Numberick",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7),
    ],
    products: [
        //=--------------------------------------=
        // NBK
        //=--------------------------------------=
        .library(
        name: "Numberick",
        targets: ["Numberick"]),
        //=--------------------------------------=
        // NBK x Core Kit
        //=--------------------------------------=
        .library(
        name: "NBKCoreKit",
        targets: ["NBKCoreKit"]),
        //=--------------------------------------=
        // NBK x Double Width Kit
        //=--------------------------------------=
        .library(
        name: "NBKDoubleWidthKit",
        targets: ["NBKDoubleWidthKit"]),
    ],
    targets: [
        //=--------------------------------------=
        // NBK
        //=--------------------------------------=
        .target(
        name: "Numberick",
        dependencies: ["NBKCoreKit", "NBKDoubleWidthKit"]),
        //=--------------------------------------=
        // NBK x Core Kit
        //=--------------------------------------=
        .target(
        name: "NBKCoreKit",
        dependencies: []),
        
        .testTarget(
        name: "NBKCoreKitBenchmarks",
        dependencies: ["NBKCoreKit"]),
        
        .testTarget(
        name: "NBKCoreKitTests",
        dependencies: ["NBKCoreKit"]),
        //=--------------------------------------=
        // NBK x Double Width Kit
        //=--------------------------------------=
        .target(
        name: "NBKDoubleWidthKit",
        dependencies: ["NBKCoreKit"]),
        
        .testTarget(
        name: "NBKDoubleWidthKitBenchmarks",
        dependencies: ["NBKDoubleWidthKit"]),
        
        .testTarget(
        name: "NBKDoubleWidthKitTests",
        dependencies: ["NBKDoubleWidthKit"]),
    ]
)

//=----------------------------------------------------------------------------=
// MARK: + Version ≥ iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

if  withStaticBigInt  {
    package.platforms = [
        .iOS("16.4"),
        .macCatalyst("16.4"),
        .macOS("13.3"),
        .tvOS("16.4"),
        .watchOS("9.4")
    ]
    
    let flag = SwiftSetting.define("SBI")
    for target in package.targets where target.name.hasPrefix("NBKDoubleWidthKit") {
        target.swiftSettings?.append(flag) ?? (target.swiftSettings = [flag])
    }
}
