//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Double Width
//*============================================================================*

final class NBKDoubleWidthTests: XCTestCase {
    
    typealias T = any NBKFixedWidthInteger.Type

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [T] = [ Int256.self,  Int512.self,  Int1024.self,  Int2048.self,  Int4096.self]
    static let unsigned: [T] = [UInt256.self, UInt512.self, UInt1024.self, UInt2048.self, UInt4096.self]
    static let types:    [T] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKDoubleWidthTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMemoryLayout() {
        func whereIs<T>(_ type: T.Type) where T: NBKFixedWidthInteger {
            XCTAssert(MemoryLayout<T>.size *  8 == T.bitWidth)
            XCTAssert(MemoryLayout<T>.size == MemoryLayout<T>.stride)
            XCTAssert(MemoryLayout<T>.size /  MemoryLayout<UInt>.stride >= 2)
            XCTAssert(MemoryLayout<T>.size %  MemoryLayout<UInt>.stride == 0)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Initializers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Tuples
    //=------------------------------------------------------------------------=
    
    init(x64: NBK128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
    
    init(x64: NBK256X64) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.3, x64.2, x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK256X32) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.7, x32.6, x32.5, x32.4, x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
}
