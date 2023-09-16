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
import NBKFlexibleWidthKit
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Text x UIntXL
//*============================================================================*

final class NBKSignedBenchmarksOnTextAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    
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
}

#endif