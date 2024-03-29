//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Sign Magnitude x Comparisons x Sub Sequence
//*============================================================================*

final class NBKStrictSignMagnitudeTestsOnComparisonsAsSubSequence: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareToZero() {
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [          ] as X),  Int(0))
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [0, 0, 0, 0] as X),  Int(0))
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [1, 0, 0, 0] as X),  Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [0, 1, 0, 0] as X),  Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [0, 0, 1, 0] as X),  Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.plus,  [0, 0, 0, 1] as X),  Int(1))
        
        NBKAssertSubSequenceCompareToZero(SM(.minus, [          ] as X),  Int(0))
        NBKAssertSubSequenceCompareToZero(SM(.minus, [0, 0, 0, 0] as X),  Int(0))
        NBKAssertSubSequenceCompareToZero(SM(.minus, [1, 0, 0, 0] as X), -Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.minus, [0, 1, 0, 0] as X), -Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.minus, [0, 0, 1, 0] as X), -Int(1))
        NBKAssertSubSequenceCompareToZero(SM(.minus, [0, 0, 0, 1] as X), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Strict Sign Magnitude x Comparisons x Assertions
//*============================================================================*

private func NBKAssertSubSequenceCompareToZero<Magnitude: RandomAccessCollection>(
_ components: SM<Magnitude>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) where Magnitude.Element: NBKCoreInteger & NBKUnsignedInteger {
    //=------------------------------------------=
    XCTAssert(NBK.SSMSS.signum/*----*/(components) == signum,                file: file, line: line)
    XCTAssert(NBK.SSMSS.isLessThanZero(components) == signum.isLessThanZero, file: file, line: line)
    XCTAssert(NBK.SSMSS.isMoreThanZero(components) == signum.isMoreThanZero, file: file, line: line)
}
