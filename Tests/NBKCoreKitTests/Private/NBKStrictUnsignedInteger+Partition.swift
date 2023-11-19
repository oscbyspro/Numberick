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
// MARK: * NBK x Strict Unsigned Integer x Partition x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnPartitionAsSubSequence: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubSequencePartitionTrimmingRedundantZeros() {
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as X, 0 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as X, 1 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as X, 2 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([          ] as X, 3 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as X, 0 as Int, [          ] as X, [1         ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as X, 1 as Int, [1         ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as X, 2 as Int, [1         ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1         ] as X, 3 as Int, [1         ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as X, 0 as Int, [          ] as X, [1, 2      ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as X, 1 as Int, [1         ] as X, [   2      ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as X, 2 as Int, [1, 2      ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2      ] as X, 3 as Int, [1, 2      ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as X, 0 as Int, [          ] as X, [1, 2, 3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as X, 1 as Int, [1         ] as X, [   2, 3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as X, 2 as Int, [1, 2      ] as X, [      3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3   ] as X, 3 as Int, [1, 2, 3   ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as X, 0 as Int, [          ] as X, [1, 2, 3, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as X, 1 as Int, [1         ] as X, [   2, 3, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as X, 2 as Int, [1, 2      ] as X, [      3, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 2, 3, 4] as X, 3 as Int, [1, 2, 3   ] as X, [         4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as X, 0 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as X, 1 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as X, 2 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 0, 0, 0] as X, 3 as Int, [          ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as X, 0 as Int, [          ] as X, [1, 0, 3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as X, 1 as Int, [1         ] as X, [   0, 3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as X, 2 as Int, [1         ] as X, [      3   ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([1, 0, 3, 0] as X, 3 as Int, [1, 0, 3   ] as X, [          ] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as X, 0 as Int, [          ] as X, [0, 2, 0, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as X, 1 as Int, [          ] as X, [   2, 0, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as X, 2 as Int, [0, 2      ] as X, [      0, 4] as X)
        NBKAssertSubSequencePartitionTrimmingRedundantZeros([0, 2, 0, 4] as X, 3 as Int, [0, 2      ] as X, [         4] as X)
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
