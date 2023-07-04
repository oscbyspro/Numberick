//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Bits
//*============================================================================*

final class Int256TestsOnBits: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bit: false), T( ))
        XCTAssertEqual(T(bit: true ), T(1))
    }
    
    func testInitRepeatingBit() {
        XCTAssertEqual(T(repeating: false),  T( ))
        XCTAssertEqual(T(repeating: true ), ~T( ))
    }
    
    func testBitWidth() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).bitWidth, 64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).bitWidth, 64 * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).nonzeroBitCount, 0)
        XCTAssertEqual(T(x64: X( 1,  1,  1,  1)).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X( 2,  0,  0,  0)).leadingZeroBitCount,  64 * 4 - 2)
        XCTAssertEqual(T(x64: X( 0,  2,  0,  0)).leadingZeroBitCount,  64 * 3 - 2)
        XCTAssertEqual(T(x64: X( 0,  0,  2,  0)).leadingZeroBitCount,  64 * 2 - 2)
        XCTAssertEqual(T(x64: X( 0,  0,  0,  2)).leadingZeroBitCount,  64 * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X( 2,  0,  0,  0)).trailingZeroBitCount, 64 * 0 + 1)
        XCTAssertEqual(T(x64: X( 0,  2,  0,  0)).trailingZeroBitCount, 64 * 1 + 1)
        XCTAssertEqual(T(x64: X( 0,  0,  2,  0)).trailingZeroBitCount, 64 * 2 + 1)
        XCTAssertEqual(T(x64: X( 0,  0,  0,  2)).trailingZeroBitCount, 64 * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).mostSignificantBit,  true )

        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leastSignificantBit, true )

        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)).leastSignificantBit, true )
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)).leastSignificantBit, false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Get, Set
    //=------------------------------------------------------------------------=
    
    func testGetBitAtIndex() {
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 0 + 0 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 0 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 0 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 1 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 1 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 1 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 2 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 2 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 2 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 3 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 3 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 5 + 3 * 64, false)
    }
    
    func testSetBitAtIndex() {
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 1 + 0 * 64, true,  T(x64: X(2, 0, 0,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 2 + 1 * 64, true,  T(x64: X(0, 4, 0,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 3 + 2 * 64, true,  T(x64: X(0, 0, 8,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 4 + 3 * 64, true,  T(x64: X(0, 0, 0, 16)))
        
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 0 * 64, false, T(x64: X(0, 4, 8, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 1 * 64, false, T(x64: X(2, 0, 8, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 2 * 64, false, T(x64: X(2, 4, 0, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 3 * 64, false, T(x64: X(2, 4, 8,  0)))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Bits
//*============================================================================*

final class UInt256TestsOnBits: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bit: false), T( ))
        XCTAssertEqual(T(bit: true ), T(1))
    }
    
    func testInitRepeatingBit() {
        XCTAssertEqual(T(repeating: false),  T( ))
        XCTAssertEqual(T(repeating: true ), ~T( ))
    }
    
    func testBitWidth() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).bitWidth, 64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).bitWidth, 64 * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).nonzeroBitCount, 0)
        XCTAssertEqual(T(x64: X( 1,  1,  1,  1)).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X( 2,  0,  0,  0)).leadingZeroBitCount,  64 * 4 - 2)
        XCTAssertEqual(T(x64: X( 0,  2,  0,  0)).leadingZeroBitCount,  64 * 3 - 2)
        XCTAssertEqual(T(x64: X( 0,  0,  2,  0)).leadingZeroBitCount,  64 * 2 - 2)
        XCTAssertEqual(T(x64: X( 0,  0,  0,  2)).leadingZeroBitCount,  64 * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X( 2,  0,  0,  0)).trailingZeroBitCount, 64 * 0 + 1)
        XCTAssertEqual(T(x64: X( 0,  2,  0,  0)).trailingZeroBitCount, 64 * 1 + 1)
        XCTAssertEqual(T(x64: X( 0,  0,  2,  0)).trailingZeroBitCount, 64 * 2 + 1)
        XCTAssertEqual(T(x64: X( 0,  0,  0,  2)).trailingZeroBitCount, 64 * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).mostSignificantBit,  true )

        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)).leastSignificantBit, true )

        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)).leastSignificantBit, true )
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)).leastSignificantBit, false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Get, Set
    //=------------------------------------------------------------------------=
    
    func testGetBitAtIndex() {
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 0 + 0 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 0 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 0 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 1 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 1 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 1 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 2 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 2 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 2 * 64, false)
        
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 3 * 64, false)
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 3 * 64, true )
        NBKAssertGetBitAtIndex(T(x64: X(2, 4, 8, 16)), 5 + 3 * 64, false)
    }
    
    func testSetBitAtIndex() {
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 1 + 0 * 64, true,  T(x64: X(2, 0, 0,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 2 + 1 * 64, true,  T(x64: X(0, 4, 0,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 3 + 2 * 64, true,  T(x64: X(0, 0, 8,  0)))
        NBKAssertSetBitAtIndex(T(x64: X(0, 0, 0,  0)), 4 + 3 * 64, true,  T(x64: X(0, 0, 0, 16)))
        
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 1 + 0 * 64, false, T(x64: X(0, 4, 8, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 2 + 1 * 64, false, T(x64: X(2, 0, 8, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 3 + 2 * 64, false, T(x64: X(2, 4, 0, 16)))
        NBKAssertSetBitAtIndex(T(x64: X(2, 4, 8, 16)), 4 + 3 * 64, false, T(x64: X(2, 4, 8,  0)))
    }
}

#endif
