//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerBenchmarksOnSubtractionAsSubSequence: XCTestCase {
 
    typealias T = NBK.SUISS
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max, plus: true))
            }
        }
    }
    
    func testDecrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max))
            }
        }
    }
    
    func testDecrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max, plus: true))
            }
        }
    }
    
    func testDecrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: xyz, plus: true))
            }
        }
    }
    
    func testDecrementByElementsTimesElementPlusElement() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        let xyz = NBK.blackHoleIdentity([1, 2, 3   ] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: xyz, times: UInt.max, plus: UInt.max))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sub Sequence
    //=------------------------------------------------------------------------=
    
    func testSubSequenceDecrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max, plus: true))
            }
        }
    }
    
    func testSubSequenceDecrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max))
            }
        }
    }
    
    func testSubSequenceDecrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max, plus: true))
            }
        }
    }
    
    func testSubSequenceDecrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: xyz, plus: true))
            }
        }
    }
    
    func testSubSequenceDecrementByElementsTimesElementPlusElement() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as X)
        let xyz = NBK.blackHoleIdentity([1, 2, 3   ] as X)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: xyz, times: UInt.max, plus: UInt.max))
            }
        }
    }
}

#endif
