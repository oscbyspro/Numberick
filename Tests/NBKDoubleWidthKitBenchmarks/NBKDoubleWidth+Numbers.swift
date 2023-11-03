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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Numbers x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnNumbersAsInt256: XCTestCase {
    
    typealias S =  Int256
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.zero)
        }
    }
    
    func testOne() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.one)
        }
    }
    
    func testMin() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.min)
        }
    }
    
    func testMax() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.max)
        }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Tests x Integers
    //=------------------------------------------------------------------------=
    
    func testToInt() {
        var abc = NBK.blackHoleIdentity(T(Int.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int(abc))
            NBK.blackHole(Int(exactly:  abc))
            NBK.blackHole(Int(clamping: abc))
            NBK.blackHole(Int(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt() {
        var abc = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt() {
        var abc = NBK.blackHoleIdentity(T(UInt.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt(abc))
            NBK.blackHole(UInt(exactly:  abc))
            NBK.blackHole(UInt(clamping: abc))
            NBK.blackHole(UInt(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt() {
        var abc = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt8() {
        var abc = NBK.blackHoleIdentity(T(Int8.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int8(abc))
            NBK.blackHole(Int8(exactly:  abc))
            NBK.blackHole(Int8(clamping: abc))
            NBK.blackHole(Int8(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt8() {
        var abc = NBK.blackHoleIdentity(Int8.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt8() {
        var abc = NBK.blackHoleIdentity(T(UInt8.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt8(abc))
            NBK.blackHole(UInt8(exactly:  abc))
            NBK.blackHole(UInt8(clamping: abc))
            NBK.blackHole(UInt8(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt8() {
        var abc = NBK.blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt16() {
        var abc = NBK.blackHoleIdentity(T(Int16.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int16(abc))
            NBK.blackHole(Int16(exactly:  abc))
            NBK.blackHole(Int16(clamping: abc))
            NBK.blackHole(Int16(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt16() {
        var abc = NBK.blackHoleIdentity(Int16.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt16() {
        var abc = NBK.blackHoleIdentity(T(UInt16.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt16(abc))
            NBK.blackHole(UInt16(exactly:  abc))
            NBK.blackHole(UInt16(clamping: abc))
            NBK.blackHole(UInt16(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt16() {
        var abc = NBK.blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt32() {
        var abc = NBK.blackHoleIdentity(T(Int32.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int32(abc))
            NBK.blackHole(Int32(exactly:  abc))
            NBK.blackHole(Int32(clamping: abc))
            NBK.blackHole(Int32(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt32() {
        var abc = NBK.blackHoleIdentity(Int32.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt32() {
        var abc = NBK.blackHoleIdentity(T(UInt32.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt32(abc))
            NBK.blackHole(UInt32(exactly:  abc))
            NBK.blackHole(UInt32(clamping: abc))
            NBK.blackHole(UInt32(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt32() {
        var abc = NBK.blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt64() {
        var abc = NBK.blackHoleIdentity(T(Int64.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int64(abc))
            NBK.blackHole(Int64(exactly:  abc))
            NBK.blackHole(Int64(clamping: abc))
            NBK.blackHole(Int64(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt64() {
        var abc = NBK.blackHoleIdentity(Int64.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt64() {
        var abc = NBK.blackHoleIdentity(T(UInt64.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt64(abc))
            NBK.blackHole(UInt64(exactly:  abc))
            NBK.blackHole(UInt64(clamping: abc))
            NBK.blackHole(UInt64(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt64() {
        var abc = NBK.blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testToDigit() {
        var abc = NBK.blackHoleIdentity(T(T.Digit.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T.Digit(abc))
            NBK.blackHole(T.Digit(exactly:  abc))
            NBK.blackHole(T.Digit(clamping: abc))
            NBK.blackHole(T.Digit(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromDigit() {
        var abc = NBK.blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(digit: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToSignitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))

        for _ in 0 ..< 250_000 {
            NBK.blackHole(S(abc))
            NBK.blackHole(S(exactly:  abc))
            NBK.blackHole(S(clamping: abc))
            NBK.blackHole(S(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromSignitude() {
        var abc = NBK.blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToMagnitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(M(abc))
            NBK.blackHole(M(exactly:  abc))
            NBK.blackHole(M(clamping: abc))
            NBK.blackHole(M(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromMagnitude() {
        var abc = NBK.blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float (> 16 Bits)
    //=------------------------------------------------------------------------=
    
    // TODO: brrr
    func testToFloat32() {
        var abc = NBK.blackHoleIdentity(T.max)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(Float32(abc))
            NBK.blackHole(Float32(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromFloat32() {
        var abc = NBK.blackHoleIdentity(Float32(UInt32.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    // TODO: brrr
    func testToFloat64() {
        var abc = NBK.blackHoleIdentity(T.max)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(Float64(abc))
            NBK.blackHole(Float64(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromFloat64() {
        var abc = NBK.blackHoleIdentity(Float64(UInt64.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    func testSignAndMagnitude() {
        var abc = NBK.blackHoleIdentity((sign: FloatingPointSign.plus,  magnitude: M(x64: X(0, 1, 2, 3))))
        var xyz = NBK.blackHoleIdentity((sign: FloatingPointSign.minus, magnitude: M(x64: X(0, 1, 2, 3))))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(sign: abc.sign, magnitude: abc.magnitude))
            NBK.blackHoleInoutIdentity(&abc)
            
            NBK.blackHole(T(sign: xyz.sign, magnitude: xyz.magnitude))
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Numbers x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnNumbersAsUInt256: XCTestCase {
    
    typealias S =  Int256
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.zero)
        }
    }
    
    func testOne() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.one)
        }
    }
    
    func testMin() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.min)
        }
    }
    
    func testMax() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.max)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Integers
    //=------------------------------------------------------------------------=
    
    func testToInt() {
        var abc = NBK.blackHoleIdentity(T(Int.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int(abc))
            NBK.blackHole(Int(exactly:  abc))
            NBK.blackHole(Int(clamping: abc))
            NBK.blackHole(Int(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt() {
        var abc = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt() {
        var abc = NBK.blackHoleIdentity(T(UInt.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt(abc))
            NBK.blackHole(UInt(exactly:  abc))
            NBK.blackHole(UInt(clamping: abc))
            NBK.blackHole(UInt(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt() {
        var abc = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt8() {
        var abc = NBK.blackHoleIdentity(T(Int8.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int8(abc))
            NBK.blackHole(Int8(exactly:  abc))
            NBK.blackHole(Int8(clamping: abc))
            NBK.blackHole(Int8(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt8() {
        var abc = NBK.blackHoleIdentity(Int8.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt8() {
        var abc = NBK.blackHoleIdentity(T(UInt8.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt8(abc))
            NBK.blackHole(UInt8(exactly:  abc))
            NBK.blackHole(UInt8(clamping: abc))
            NBK.blackHole(UInt8(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt8() {
        var abc = NBK.blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt16() {
        var abc = NBK.blackHoleIdentity(T(Int16.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int16(abc))
            NBK.blackHole(Int16(exactly:  abc))
            NBK.blackHole(Int16(clamping: abc))
            NBK.blackHole(Int16(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt16() {
        var abc = NBK.blackHoleIdentity(Int16.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt16() {
        var abc = NBK.blackHoleIdentity(T(UInt16.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt16(abc))
            NBK.blackHole(UInt16(exactly:  abc))
            NBK.blackHole(UInt16(clamping: abc))
            NBK.blackHole(UInt16(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt16() {
        var abc = NBK.blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt32() {
        var abc = NBK.blackHoleIdentity(T(Int32.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int32(abc))
            NBK.blackHole(Int32(exactly:  abc))
            NBK.blackHole(Int32(clamping: abc))
            NBK.blackHole(Int32(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt32() {
        var abc = NBK.blackHoleIdentity(Int32.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt32() {
        var abc = NBK.blackHoleIdentity(T(UInt32.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt32(abc))
            NBK.blackHole(UInt32(exactly:  abc))
            NBK.blackHole(UInt32(clamping: abc))
            NBK.blackHole(UInt32(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt32() {
        var abc = NBK.blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToInt64() {
        var abc = NBK.blackHoleIdentity(T(Int64.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(Int64(abc))
            NBK.blackHole(Int64(exactly:  abc))
            NBK.blackHole(Int64(clamping: abc))
            NBK.blackHole(Int64(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromInt64() {
        var abc = NBK.blackHoleIdentity(Int64.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToUInt64() {
        var abc = NBK.blackHoleIdentity(T(UInt64.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(UInt64(abc))
            NBK.blackHole(UInt64(exactly:  abc))
            NBK.blackHole(UInt64(clamping: abc))
            NBK.blackHole(UInt64(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromUInt64() {
        var abc = NBK.blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testToDigit() {
        var abc = NBK.blackHoleIdentity(T(T.Digit.max))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T.Digit(abc))
            NBK.blackHole(T.Digit(exactly:  abc))
            NBK.blackHole(T.Digit(clamping: abc))
            NBK.blackHole(T.Digit(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromDigit() {
        var abc = NBK.blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(digit: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToSignitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))

        for _ in 0 ..< 250_000 {
            NBK.blackHole(S(abc))
            NBK.blackHole(S(exactly:  abc))
            NBK.blackHole(S(clamping: abc))
            NBK.blackHole(S(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromSignitude() {
        var abc = NBK.blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testToMagnitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(M(abc))
            NBK.blackHole(M(exactly:  abc))
            NBK.blackHole(M(clamping: abc))
            NBK.blackHole(M(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromMagnitude() {
        var abc = NBK.blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float (> 16 Bits)
    //=------------------------------------------------------------------------=
    
    // TODO: brrr
    func testToFloat32() {
        var abc = NBK.blackHoleIdentity(T.max)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(Float32(abc))
            NBK.blackHole(Float32(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromFloat32() {
        var abc = NBK.blackHoleIdentity(Float32(123))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    // TODO: brrr
    func testToFloat64() {
        var abc = NBK.blackHoleIdentity(T.max)
        
        for _ in 0 ..< 1_000 {
            NBK.blackHole(Float64(abc))
            NBK.blackHole(Float64(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFromFloat64() {
        var abc = NBK.blackHoleIdentity(Float64(123))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    func testSignAndMagnitude() {
        var abc = NBK.blackHoleIdentity((sign: FloatingPointSign.plus,  magnitude: M(x64: X(0, 1, 2, 3))))
        var xyz = NBK.blackHoleIdentity((sign: FloatingPointSign.minus, magnitude: M(x64: X(0, 1, 2, 3))))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(sign: abc.sign, magnitude: abc.magnitude))
            NBK.blackHoleInoutIdentity(&abc)
            
            NBK.blackHole(T(sign: xyz.sign, magnitude: xyz.magnitude))
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
