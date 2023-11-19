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

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Bits x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnBitsAsInt256: XCTestCase {
    
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
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).bitWidth, 64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).bitWidth, 64 * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).nonzeroBitCount, 0)
        XCTAssertEqual(T(x64: X64( 1,  1,  1,  1)).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X64( 2,  0,  0,  0)).leadingZeroBitCount,  64 * 4 - 2)
        XCTAssertEqual(T(x64: X64( 0,  2,  0,  0)).leadingZeroBitCount,  64 * 3 - 2)
        XCTAssertEqual(T(x64: X64( 0,  0,  2,  0)).leadingZeroBitCount,  64 * 2 - 2)
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  2)).leadingZeroBitCount,  64 * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).trailingZeroBitCount, 64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).trailingZeroBitCount, 64 * 0)
        
        XCTAssertEqual(T(x64: X64( 2,  0,  0,  0)).trailingZeroBitCount, 64 * 0 + 1)
        XCTAssertEqual(T(x64: X64( 0,  2,  0,  0)).trailingZeroBitCount, 64 * 1 + 1)
        XCTAssertEqual(T(x64: X64( 0,  0,  2,  0)).trailingZeroBitCount, 64 * 2 + 1)
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  2)).trailingZeroBitCount, 64 * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).mostSignificantBit,  true )

        XCTAssertEqual(T(x64: X64(~0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0, ~0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0,  0, ~0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0,  0,  0, ~0)).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).leastSignificantBit, true )

        XCTAssertEqual(T(x64: X64(~0,  0,  0,  0)).leastSignificantBit, true )
        XCTAssertEqual(T(x64: X64( 0, ~0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64( 0,  0, ~0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64( 0,  0,  0, ~0)).leastSignificantBit, false)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Bits x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnBitsAsUInt256: XCTestCase {
    
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
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).bitWidth, 64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).bitWidth, 64 * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).nonzeroBitCount, 0)
        XCTAssertEqual(T(x64: X64( 1,  1,  1,  1)).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X64( 2,  0,  0,  0)).leadingZeroBitCount,  64 * 4 - 2)
        XCTAssertEqual(T(x64: X64( 0,  2,  0,  0)).leadingZeroBitCount,  64 * 3 - 2)
        XCTAssertEqual(T(x64: X64( 0,  0,  2,  0)).leadingZeroBitCount,  64 * 2 - 2)
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  2)).leadingZeroBitCount,  64 * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).leadingZeroBitCount,  64 * 4)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).leadingZeroBitCount,  64 * 0)
        
        XCTAssertEqual(T(x64: X64( 2,  0,  0,  0)).trailingZeroBitCount, 64 * 0 + 1)
        XCTAssertEqual(T(x64: X64( 0,  2,  0,  0)).trailingZeroBitCount, 64 * 1 + 1)
        XCTAssertEqual(T(x64: X64( 0,  0,  2,  0)).trailingZeroBitCount, 64 * 2 + 1)
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  2)).trailingZeroBitCount, 64 * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).mostSignificantBit,  true )

        XCTAssertEqual(T(x64: X64(~0,  0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0, ~0,  0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0,  0, ~0,  0)).mostSignificantBit,  false)
        XCTAssertEqual(T(x64: X64( 0,  0,  0, ~0)).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(x64: X64( 0,  0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64(~0, ~0, ~0, ~0)).leastSignificantBit, true )

        XCTAssertEqual(T(x64: X64(~0,  0,  0,  0)).leastSignificantBit, true )
        XCTAssertEqual(T(x64: X64( 0, ~0,  0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64( 0,  0, ~0,  0)).leastSignificantBit, false)
        XCTAssertEqual(T(x64: X64( 0,  0,  0, ~0)).leastSignificantBit, false)
    }
}
