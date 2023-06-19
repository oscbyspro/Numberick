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
        var radix  = NBK.blackHoleIdentity(10)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testDecodingRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testEncodingRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    func testEncodingRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
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
        var radix  = NBK.blackHoleIdentity(10)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testDecodingRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testEncodingRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    func testEncodingRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var source = NBK.blackHoleIdentity(Self.source)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.stdlib(source, radix: radix)!)
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&source)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        var radix  = NBK.blackHoleIdentity(10)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        var radix  = NBK.blackHoleIdentity(16)
        var number = NBK.blackHoleIdentity(Self.number)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(String.stdlib(number, radix: radix))
            NBK.blackHoleInoutIdentity( &radix)
            NBK.blackHoleInoutIdentity(&number)
        }
    }
}

#endif
