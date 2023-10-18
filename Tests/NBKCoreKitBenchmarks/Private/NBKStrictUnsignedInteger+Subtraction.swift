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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerBenchmarksOnSubtractionAsSubSequence: XCTestCase {
 
    typealias T = NBK.SUISS
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testDecrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max, at: 0))
            }
        }
    }
    
    func testDecrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testDecrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: xyz, plus: true, at: 0))
            }
        }
    }
    
    func testDecrementByElementsTimesElementPlusElementPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3   ] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc, by: xyz, times: UInt.max, plus: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sub Sequence
    //=------------------------------------------------------------------------=
    
    func testSubSequenceDecrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testSubSequenceDecrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max, at: 0))
            }
        }
    }
    
    func testSubSequenceDecrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testSubSequenceDecrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: xyz, plus: true, at: 0))
            }
        }
    }
    
    func testSubSequenceDecrementByElementsTimesElementPlusElementPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3   ] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.decrement(&abc[0...], by: xyz, times: UInt.max, plus: UInt.max, plus: true, at: 0))
            }
        }
    }
}

#endif
