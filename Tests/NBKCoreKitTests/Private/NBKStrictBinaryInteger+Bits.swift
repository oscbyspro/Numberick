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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Bits x Sub Sequence
//*============================================================================*

final class NBKStrictBinaryIntegerTestsOnBitsAsSubSequence: XCTestCase {

    private typealias U64 = [UInt64]
    private typealias U32 = [UInt32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeadingZeroBitCount() {
        NBKAssertSubSequenceLeadingZeroBitCount ([              ] as U64, 000)
        NBKAssertSubSequenceLeadingZeroBitCount ([00            ] as U64, 064)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00        ] as U64, 128)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 00    ] as U64, 192)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 00, 00] as U64, 256)
        
        NBKAssertSubSequenceLeadingZeroBitCount ([02            ] as U64, 062)
        NBKAssertSubSequenceLeadingZeroBitCount ([02, 00        ] as U64, 126)
        NBKAssertSubSequenceLeadingZeroBitCount ([02, 00, 00    ] as U64, 190)
        NBKAssertSubSequenceLeadingZeroBitCount ([02, 00, 00, 00] as U64, 254)
        
        NBKAssertSubSequenceLeadingZeroBitCount ([02            ] as U64, 062)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 02        ] as U64, 062)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 02    ] as U64, 062)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 00, 02] as U64, 062)
        
        NBKAssertSubSequenceLeadingZeroBitCount ([02, 00, 00, 00] as U64, 254)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 02, 00, 00] as U64, 190)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 02, 00] as U64, 126)
        NBKAssertSubSequenceLeadingZeroBitCount ([00, 00, 00, 02] as U64, 062)
    }
    
    func testTrailingZeroBitCount() {
        NBKAssertSubSequenceTrailingZeroBitCount([              ] as U64, 000)
        NBKAssertSubSequenceTrailingZeroBitCount([00            ] as U64, 064)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00        ] as U64, 128)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 00    ] as U64, 192)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 00, 00] as U64, 256)
        
        NBKAssertSubSequenceTrailingZeroBitCount([02            ] as U64, 001)
        NBKAssertSubSequenceTrailingZeroBitCount([02, 00        ] as U64, 001)
        NBKAssertSubSequenceTrailingZeroBitCount([02, 00, 00    ] as U64, 001)
        NBKAssertSubSequenceTrailingZeroBitCount([02, 00, 00, 00] as U64, 001)
        
        NBKAssertSubSequenceTrailingZeroBitCount([02            ] as U64, 001)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 02        ] as U64, 065)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 02    ] as U64, 129)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 00, 02] as U64, 193)
        
        NBKAssertSubSequenceTrailingZeroBitCount([02, 00, 00, 00] as U64, 001)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 02, 00, 00] as U64, 065)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 02, 00] as U64, 129)
        NBKAssertSubSequenceTrailingZeroBitCount([00, 00, 00, 02] as U64, 193)
    }
    
    func testMostSignificantBitTwosComplementOf() {
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[00, 00, 00, 00] as U64, false)
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[~0, ~0, ~0, ~0] as U64, false)
        
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[01, 00, 00, 00] as U64, true )
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[~1, ~0, ~0, ~0] as U64, false)
        
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[ 0,  0,  0, ~0/2 + 1] as U64, true) // Int256.min
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[~0, ~0, ~0, ~0/2 + 0] as U64, true) // Int256.max
    }
    
    func testMostSignificantBitTwosComplementOfReturnsNilWhenLimbsIsEmpty() {
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[  ] as U64, nil  )
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[ 0] as U64, false)
        NBKAssertSubSequenceMostSignificantBit(twosComplementOf:[ 1] as U64, true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Nonzero Bit Count
    //=------------------------------------------------------------------------=
    
    func testNonzeroBitCountEquals() {
        NBKAssertSubSequenceNonzeroBitCount([              ] as U64, 00)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 00] as U64, 00)
        NBKAssertSubSequenceNonzeroBitCount([01, 00, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([01, 03, 00, 00] as U64, 03)
        NBKAssertSubSequenceNonzeroBitCount([01, 03, 07, 00] as U64, 06)
        NBKAssertSubSequenceNonzeroBitCount([01, 03, 07, 15] as U64, 10)
        NBKAssertSubSequenceNonzeroBitCount([00, 03, 07, 15] as U64, 09)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 07, 15] as U64, 07)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 15] as U64, 04)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 15, 07] as U64, 07)
        NBKAssertSubSequenceNonzeroBitCount([15, 07, 03, 01] as U64, 10)
        NBKAssertSubSequenceNonzeroBitCount([07, 03, 01, 00] as U64, 06)
        NBKAssertSubSequenceNonzeroBitCount([03, 01, 00, 00] as U64, 03)
        NBKAssertSubSequenceNonzeroBitCount([01, 00, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 00] as U64, 00)
        
        NBKAssertSubSequenceNonzeroBitCount([01, 00, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 02, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 04, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 08] as U64, 01)
        
        NBKAssertSubSequenceNonzeroBitCount([01, 00, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 01, 00, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 01, 00] as U64, 01)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 01] as U64, 01)
        
        NBKAssertSubSequenceNonzeroBitCount([01, 00, 00, 00] as U64, 00, false)
        NBKAssertSubSequenceNonzeroBitCount([00, 01, 00, 00] as U64, 00, false)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 01, 00] as U64, 00, false)
        NBKAssertSubSequenceNonzeroBitCount([00, 00, 00, 01] as U64, 00, false)
    }
    
    func testNonzeroBitCountTwosComplementOf() {
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[              ] as U64, 000)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 00, 00] as U64, 000)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[~0, ~0, ~0, ~0] as U64, 001)
        
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 00, 00] as U64, 000)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[01, 00, 00, 00] as U64, 256)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[01, 03, 00, 00] as U64, 254)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[01, 03, 07, 00] as U64, 251)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[01, 03, 07, 15] as U64, 247)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 03, 07, 15] as U64, 184)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 07, 15] as U64, 122)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 00, 15] as U64, 061)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 15, 07] as U64, 122)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[15, 07, 03, 01] as U64, 247)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[07, 03, 01, 00] as U64, 251)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[03, 01, 00, 00] as U64, 254)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[01, 00, 00, 00] as U64, 256)
        NBKAssertSubSequenceNonzeroBitCount(twosComplementOf:[00, 00, 00, 00] as U64, 000)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Bits x Sub Sequence x Assertions
//*============================================================================*

private func NBKAssertSubSequenceLeadingZeroBitCount(
_ lhs: [UInt64], _ rhs: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictBinaryInteger<[UInt64]>.SubSequence
    //=------------------------------------------=
    XCTAssertEqual(T.leadingZeroBitCount(of: lhs), rhs, file: file, line: line)
}

private func NBKAssertSubSequenceTrailingZeroBitCount(
_ lhs: [UInt64], _ rhs: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictBinaryInteger<[UInt64]>.SubSequence
    //=------------------------------------------=
    XCTAssertEqual(T.trailingZeroBitCount(of: lhs), rhs, file: file, line: line)
}

private func NBKAssertSubSequenceMostSignificantBit(
twosComplementOf lhs: [UInt64], _ rhs: Bool?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictBinaryInteger<[UInt64]>.SubSequence
    //=------------------------------------------=
    XCTAssertEqual(T.mostSignificantBit(twosComplementOf: lhs), rhs, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Nonzero Bit Count
//=----------------------------------------------------------------------------=

private func NBKAssertSubSequenceNonzeroBitCount(
_ lhs: [UInt64], _ rhs: Int, _ success: Bool = true,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictBinaryInteger<[UInt64]>.SubSequence
    //=------------------------------------------=
    if  success {
        XCTAssertEqual(T.nonzeroBitCount(of: lhs),         rhs + 0,  file: file, line: line)
        XCTAssertFalse(T.nonzeroBitCount(of: lhs,  equals: rhs + 1), file: file, line: line)
        XCTAssertFalse(T.nonzeroBitCount(of: lhs,  equals: rhs - 1), file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T.nonzeroBitCount(of: lhs, equals: rhs), success, file: file, line: line)
}

private func NBKAssertSubSequenceNonzeroBitCount(
twosComplementOf lhs: [UInt64], _ rhs: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictBinaryInteger<[UInt64]>.SubSequence
    //=------------------------------------------=
    XCTAssertEqual(T.nonzeroBitCount(twosComplementOf: lhs), rhs, file: file, line: line)
}
