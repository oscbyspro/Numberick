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
// MARK: * NBK x Double Width x Endianness x Int256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthBenchmarksOnEndiannessAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBigEndian() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bigEndian)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testLittleEndian() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.littleEndian)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testByteSwapped() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.byteSwapped)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Endianness x UInt256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthBenchmarksOnEndiannessAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBigEndian() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bigEndian)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testLittleEndian() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.littleEndian)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testByteSwapped() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.byteSwapped)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
