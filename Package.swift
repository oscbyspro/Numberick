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

let package = Package(
    name: "Numberick",
    platforms: [
        .iOS("16.4"),
        .macCatalyst("16.4"),
        .macOS("13.3"),
        .tvOS("16.4"),
        .watchOS("9.4"),
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
        //=--------------------------------------=
        // NBK x Flexible Width Kit
        //=--------------------------------------=
        .library(
        name: "NBKFlexibleWidthKit",
        targets: ["NBKFlexibleWidthKit"]),
        //=--------------------------------------=
        // NBK x Resizable Width Kit
        //=--------------------------------------=
        .library(
        name: "NBKResizableWidthKit",
        targets: ["NBKResizableWidthKit"]),
    ],
    targets: [
        //=--------------------------------------=
        // NBK
        //=--------------------------------------=
        .target(
        name: "Numberick",
        dependencies: ["NBKCoreKit", "NBKDoubleWidthKit", "NBKFlexibleWidthKit"]),
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
        //=--------------------------------------=
        // NBK x Flexible Width Kit
        //=--------------------------------------=
        .target(
        name: "NBKFlexibleWidthKit",
        dependencies: ["NBKCoreKit", "NBKResizableWidthKit"]),
        
        .testTarget(
        name: "NBKFlexibleWidthKitBenchmarks",
        dependencies: ["NBKFlexibleWidthKit"]),
        
        .testTarget(
        name: "NBKFlexibleWidthKitTests",
        dependencies: ["NBKFlexibleWidthKit"]),
        //=--------------------------------------=
        // NBK x Resizable Width Kit
        //=--------------------------------------=
        .target(
        name: "NBKResizableWidthKit",
        dependencies: ["NBKCoreKit"]),
        
        .testTarget(
        name: "NBKResizableWidthKitBenchmarks",
        dependencies: ["NBKResizableWidthKit"]),
        
        .testTarget(
        name: "NBKResizableWidthKitTests",
        dependencies: ["NBKResizableWidthKit"]),
    ]
)
