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
// MARK: * NBK x Double Width x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low .zero, T.High.zero ))
        var xyz = NBK.blackHoleIdentity(HL( T.High.zero, T.Low .zero ))

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low .zero, T.High.zero ))
        var xyz = NBK.blackHoleIdentity(HL( T.High.zero, T.Low .zero ))

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Initializers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(x64: NBK.U128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK.U128X32) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
    
    init(x64: NBK.U256X64) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.3, x64.2, x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK.U256X32) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.7, x32.6, x32.5, x32.4, x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
}

#endif
