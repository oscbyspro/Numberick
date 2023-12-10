//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Bits x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnBitsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bit: false), T( ))
        XCTAssertEqual(T(bit: true ), T(1))
    }
    
    func testBitWidth() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).bitWidth, UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as X).bitWidth, UInt.bitWidth * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as X).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).leadingZeroBitCount,  UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as X).leadingZeroBitCount,  UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as X).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as X).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as X).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as X).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).trailingZeroBitCount, UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as X).trailingZeroBitCount, UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as X).trailingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as X).trailingZeroBitCount, UInt.bitWidth * 1 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as X).trailingZeroBitCount, UInt.bitWidth * 2 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as X).trailingZeroBitCount, UInt.bitWidth * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as X).mostSignificantBit,  true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as X).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as X).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as X).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as X).mostSignificantBit,  true )
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as X).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as X).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as X).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as X).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as X).leastSignificantBit, false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as X).leastSignificantBit, true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as X).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as X).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as X).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as X).leastSignificantBit, false)
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as X).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as X).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as X).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as X).leastSignificantBit, true )
    }
}
