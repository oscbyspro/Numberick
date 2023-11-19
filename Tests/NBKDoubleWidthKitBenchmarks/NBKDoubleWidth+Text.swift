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

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Text x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnTextAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let decoded = NBK.blackHoleIdentity(T(encoded, radix: 16)!)
    static let encoded = NBK.blackHoleIdentity(String(repeating: "1", count: 64))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testDecodingRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testEncodingRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(decoded, radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    func testEncodingRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(decoded, radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        let type    = type(of: NBK.someSwiftFixedWidthInteger(T.zero)) // Swift 5.7
        var radix   = NBK.blackHoleIdentity(10)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(type.init(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        let type    = type(of: NBK.someSwiftFixedWidthInteger(T.zero)) // Swift 5.7
        var radix   = NBK.blackHoleIdentity(16)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(type.init(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(String(NBK.someSwiftBinaryInteger(decoded), radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(String(NBK.someSwiftBinaryInteger(decoded), radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnTextAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let decoded = NBK.blackHoleIdentity(T(encoded, radix: 16)!)
    static let encoded = NBK.blackHoleIdentity(String(repeating: "1", count: 64))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testDecodingRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testEncodingRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(decoded, radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    func testEncodingRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(String(decoded, radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Swift Standard Library Methods
    //=------------------------------------------------------------------------=
    
    func testDecodingUsingSwiftStdlibRadix10() {
        let type    = type(of: NBK.someSwiftFixedWidthInteger(T.zero)) // Swift 5.7
        var radix   = NBK.blackHoleIdentity(10)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(type.init(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testDecodingUsingSwiftStdlibRadix16() {
        let type    = type(of: NBK.someSwiftFixedWidthInteger(T.zero)) // Swift 5.7
        var radix   = NBK.blackHoleIdentity(16)
        var encoded = NBK.blackHoleIdentity(Self.encoded)
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(type.init(encoded, radix: radix)!)
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&encoded)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix10() {
        var radix   = NBK.blackHoleIdentity(10)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(String(NBK.someSwiftBinaryInteger(decoded), radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
    
    func testEncodingUsingSwiftStdlibRadix16() {
        var radix   = NBK.blackHoleIdentity(16)
        var decoded = NBK.blackHoleIdentity(Self.decoded)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(String(NBK.someSwiftBinaryInteger(decoded), radix: radix))
            NBK.blackHoleInoutIdentity(&radix)
            NBK.blackHoleInoutIdentity(&decoded)
        }
    }
}

#endif
