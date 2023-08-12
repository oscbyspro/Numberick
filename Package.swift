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
// The poor man's feature flag:
// FIND...: /([*/])([*/])(flag)\*/
// REPLACE: /$2$1$3*/
//=----------------------------------------------------------------------------=

let package = Package(
    name: "Numberick",
    platforms: [
        //=--------------------------------------=
        // Static Big Int x Yay
        //=--------------------------------------=
        /*/SBI*/.iOS("16.4"),
        /*/SBI*/.macCatalyst("16.4"),
        /*/SBI*/.macOS("13.3"),
        /*/SBI*/.tvOS("16.4"),
        /*/SBI*/.watchOS("9.4"),
        //=--------------------------------------=
        // Static Big Int x Nay
        //=--------------------------------------=
        //*SBI*/.iOS(.v14),
        //*SBI*/.macCatalyst(.v14),
        //*SBI*/.macOS(.v11),
        //*SBI*/.tvOS(.v14),
        //*SBI*/.watchOS(.v7),
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
