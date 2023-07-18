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
import NBKFlexibleWidthKit
import XCTest

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Bits
//*============================================================================*

final class UIntXLTestsOnBits: XCTestCase {
    
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
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).bitWidth, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).bitWidth, UInt.bitWidth * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as [UInt]).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as [UInt]).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 1 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 2 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as [UInt]).trailingZeroBitCount, UInt.bitWidth * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).mostSignificantBit,  true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as [UInt]).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as [UInt]).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as [UInt]).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as [UInt]).mostSignificantBit,  true )
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as [UInt]).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as [UInt]).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as [UInt]).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as [UInt]).mostSignificantBit,  true )
    }
    
    func testLeastSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as [UInt]).leastSignificantBit, false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).leastSignificantBit, true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as [UInt]).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as [UInt]).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as [UInt]).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0,  0, ~0] as [UInt]).leastSignificantBit, false)
        
        XCTAssertEqual(T(words:[~0,  1,  0,  0] as [UInt]).leastSignificantBit, true )
        XCTAssertEqual(T(words:[ 0, ~0,  1,  0] as [UInt]).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0, ~0,  1] as [UInt]).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 1,  0,  0, ~0] as [UInt]).leastSignificantBit, true )
    }
}

#endif
