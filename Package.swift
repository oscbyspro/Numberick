// swift-tools-version: 5.7
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

let package = Package(
    name: "Numberick",
    platforms: [
        .iOS("11.0"),
        .macCatalyst("13.0"),
        .macOS("11.0"),
        .tvOS("11.0"),
        .watchOS("6.0"),
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
