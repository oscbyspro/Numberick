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
// MARK: * NBK x Strict Unsigned Integer x Addition x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerBenchmarksOnAdditionAsSubSequence: XCTestCase {
 
    typealias T = NBK.SUISS
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIncrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc, by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testIncrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc, by: UInt.max, at: 0))
            }
        }
    }
    
    func testIncrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc, by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testIncrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc, by: xyz, plus: true, at: 0))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sub Sequence
    //=------------------------------------------------------------------------=
    
    func testSubSequenceIncrementByBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc[0...], by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testSubSequenceIncrementByDigit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc[0...], by: UInt.max, at: 0))
            }
        }
    }
    
    func testSubSequenceIncrementByDigitPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc[0...], by: UInt.max, plus: true, at: 0))
            }
        }
    }
    
    func testSubSequenceIncrementByElementsPlusBit() {
        var abc = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        let xyz = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHoleInoutIdentity(&abc)
            abc.withUnsafeMutableBufferPointer { abc in
                NBK.blackHole(T.increment(&abc[0...], by: xyz, plus: true, at: 0))
            }
        }
    }
}

#endif
