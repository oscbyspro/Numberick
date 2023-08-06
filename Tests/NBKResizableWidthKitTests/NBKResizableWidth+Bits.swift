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
import NBKResizableWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Resizable Width x Bits x UIntXR
//*============================================================================*

final class NBKResizableWidthTestsOnBitsAsUIntXR: XCTestCase {
    
    typealias T = UIntXR
    typealias M = UIntXR

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bit: false), T( ))
        XCTAssertEqual(T(bit: true ), T(1))
    }
    
    func testBitWidth() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).bitWidth, UInt.bitWidth * 4)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).bitWidth, UInt.bitWidth * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 4)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).leadingZeroBitCount,  UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 4 - 2)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 3 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 2 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 4)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 1 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).trailingZeroBitCount, UInt.bitWidth * 2 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).trailingZeroBitCount, UInt.bitWidth * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).mostSignificantBit,  true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as W).mostSignificantBit,  true )
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as W).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).leastSignificantBit, true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as W).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as W).leastSignificantBit, false)
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as W).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as W).leastSignificantBit, true )
    }
}

#endif
