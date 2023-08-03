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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x IntXL x Bits
//*============================================================================*

final class IntXLTestsOnBits: XCTestCase {
    
    typealias T =  IntXL
    typealias M = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        XCTAssertEqual(T(bit: false), T( ))
        XCTAssertEqual(T(bit: true ), T(1))
    }
    
    func testBitWidth() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).bitWidth, UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).bitWidth, UInt.bitWidth * 1)
        
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).bitWidth, UInt.bitWidth * 4)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).bitWidth, UInt.bitWidth * 5)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).bitWidth, UInt.bitWidth * 5)

        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).bitWidth, UInt.bitWidth * 4)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).bitWidth, UInt.bitWidth * 4)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).bitWidth, UInt.bitWidth * 5)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(sign: .minus, magnitude:  0).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).nonzeroBitCount, 4)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).nonzeroBitCount, UInt.bitWidth * 1)
        
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).nonzeroBitCount, UInt.bitWidth * 4 - 1)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).nonzeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).nonzeroBitCount, UInt.bitWidth * 0 + 2)
        
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).nonzeroBitCount, UInt.bitWidth * 0 + 2)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).nonzeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).nonzeroBitCount, UInt.bitWidth * 5 - 1)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(sign: .minus, magnitude:  0).leadingZeroBitCount,  UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 1)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).leadingZeroBitCount,  UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).leadingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).leadingZeroBitCount, UInt.bitWidth * 1 + 0)
        XCTAssertEqual(T(sign: .plus,  magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).leadingZeroBitCount, UInt.bitWidth * 1 + 0)
        
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[~0, ~0, ~0, ~0/2 + 0] as W)).leadingZeroBitCount, UInt.bitWidth * 0 + 0)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 0,  0,  0, ~0/2 + 1] as W)).leadingZeroBitCount, UInt.bitWidth * 0 + 0)
        XCTAssertEqual(T(sign: .minus, magnitude: M(words:[ 1,  0,  0, ~0/2 + 1] as W)).leadingZeroBitCount, UInt.bitWidth * 0 + 0)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(sign: .minus, magnitude:  0).trailingZeroBitCount, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 1 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).trailingZeroBitCount, UInt.bitWidth * 2 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).trailingZeroBitCount, UInt.bitWidth * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(sign: .minus, magnitude:  0).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).mostSignificantBit,  false)
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
        XCTAssertEqual(T(sign: .minus, magnitude:  0).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).leastSignificantBit, false)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).leastSignificantBit, true )
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
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).bitWidth, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).bitWidth, UInt.bitWidth * 4)
    }
    
    func testNonzeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).nonzeroBitCount, 0)
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).nonzeroBitCount, 4)
    }
    
    func testLeadingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).leadingZeroBitCount,  UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).leadingZeroBitCount,  UInt.bitWidth * 1 - 2)
    }
    
    func testTrailingZeroBitCount() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).trailingZeroBitCount, UInt.bitWidth * 0)
        
        XCTAssertEqual(T(words:[ 2,  0,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 0 + 1)
        XCTAssertEqual(T(words:[ 0,  2,  0,  0] as W).trailingZeroBitCount, UInt.bitWidth * 1 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  2,  0] as W).trailingZeroBitCount, UInt.bitWidth * 2 + 1)
        XCTAssertEqual(T(words:[ 0,  0,  0,  2] as W).trailingZeroBitCount, UInt.bitWidth * 3 + 1)
    }
    
    func testMostSignificantBit() {
        XCTAssertEqual(T(words:[ 0,  0,  0,  0] as W).mostSignificantBit,  false)
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).mostSignificantBit,  true )

        XCTAssertEqual(T(words:[~0,  0,  0,  0] as W).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0, ~0,  0,  0] as W).mostSignificantBit,  true )
        XCTAssertEqual(T(words:[ 0,  0, ~0,  0] as W).mostSignificantBit,  true )
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
