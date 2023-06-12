//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Text
//*============================================================================*

final class Int256BenchmarksOnText: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static var number = NBK.blackHoleIdentity(T(source, radix: 16)!)
    static var source = NBK.blackHoleIdentity(String(repeating: "1", count: 64))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T(Self.source, radix: 10)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testDecodingRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T(Self.source, radix: 16)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testEncodingRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String(Self.number, radix: 10))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    func testEncodingRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String(Self.number, radix: 16))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(Self.source, radix: 10)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(Self.source, radix: 16)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(Self.number, radix: 10))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(Self.number, radix: 16))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Text
//*============================================================================*

final class UInt256BenchmarksOnText: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static var number = NBK.blackHoleIdentity(T(source, radix: 16)!)
    static var source = NBK.blackHoleIdentity(String(repeating: "1", count: 64))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T(Self.source, radix: 10)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testDecodingRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T(Self.source, radix: 16)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testEncodingRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String(Self.number, radix: 10))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    func testEncodingRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String(Self.number, radix: 16))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(Self.source, radix: 10)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(Self.source, radix: 16)!)
            NBK.blackHoleInoutIdentity(&Self.source)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(Self.number, radix: 10))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(Self.number, radix: 16))
            NBK.blackHoleInoutIdentity(&Self.number)
        }
    }
}

#endif
