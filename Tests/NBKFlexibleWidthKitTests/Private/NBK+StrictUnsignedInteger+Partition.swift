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
// MARK: * NBK x Strict Unsigned Integer x Partition x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnPartitionAsSubSequence: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubSequencePartitionTrimmingRedundantZeros() {
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as W, 0 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as W, 1 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as W, 2 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as W, 3 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as W, 0 as Int, [          ] as W, [1         ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as W, 1 as Int, [1         ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as W, 2 as Int, [1         ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as W, 3 as Int, [1         ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as W, 0 as Int, [          ] as W, [1, 2      ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as W, 1 as Int, [1         ] as W, [   2      ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as W, 2 as Int, [1, 2      ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as W, 3 as Int, [1, 2      ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as W, 0 as Int, [          ] as W, [1, 2, 3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as W, 1 as Int, [1         ] as W, [   2, 3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as W, 2 as Int, [1, 2      ] as W, [      3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as W, 3 as Int, [1, 2, 3   ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as W, 0 as Int, [          ] as W, [1, 2, 3, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as W, 1 as Int, [1         ] as W, [   2, 3, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as W, 2 as Int, [1, 2      ] as W, [      3, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as W, 3 as Int, [1, 2, 3   ] as W, [         4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as W, 0 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as W, 1 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as W, 2 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as W, 3 as Int, [          ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as W, 0 as Int, [          ] as W, [1, 0, 3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as W, 1 as Int, [1         ] as W, [   0, 3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as W, 2 as Int, [1         ] as W, [      3   ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as W, 3 as Int, [1, 0, 3   ] as W, [          ] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as W, 0 as Int, [          ] as W, [0, 2, 0, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as W, 1 as Int, [          ] as W, [   2, 0, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as W, 2 as Int, [0, 2      ] as W, [      0, 4] as W)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as W, 3 as Int, [0, 2      ] as W, [         4] as W)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Partition x Assertions
//*============================================================================*

private func NBKAssertSubSequencePartitionTrimmingRedundantZeros(
_ base: [UInt], _ index: Int, _ low: [UInt], _ high: [UInt],
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    base.withUnsafeBufferPointer { base in
        let partition = T.partitionTrimmingRedundantZeros(base, at:  index)
        XCTAssertEqual([UInt](partition.low ), low, file: file, line: line)
        XCTAssertEqual([UInt](partition.high), high,file: file, line: line)
        XCTAssertNotEqual(partition.low .last, UInt.zero, file: file, line: line)
        XCTAssertNotEqual(partition.high.last, UInt.zero, file: file, line: line)
    }
}

#endif
