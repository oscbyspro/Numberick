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

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * NBK x Int256 x Numbers
//*============================================================================*

final class Int256BenchmarksOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x [U]Int
    //=------------------------------------------------------------------------=
    
    func testInt() {
        var abc = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt() {
        var abc = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt8() {
        var abc = NBK.blackHoleIdentity(Int8.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt8() {
        var abc = NBK.blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt16() {
        var abc = NBK.blackHoleIdentity(Int16.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt16() {
        var abc = NBK.blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt32() {
        var abc = NBK.blackHoleIdentity(Int32.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt32() {
        var abc = NBK.blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt64() {
        var abc = NBK.blackHoleIdentity(Int64.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt64() {
        var abc = NBK.blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float
    //=------------------------------------------------------------------------=
    
    func testFloat32() {
        var abc = NBK.blackHoleIdentity(Float32(UInt32.max))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFloat64() {
        var abc = NBK.blackHoleIdentity(Float64(UInt64.max))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testDigit() {
        var abc = NBK.blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(digit: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testSignitude() {
        var abc = NBK.blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
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
            NBK.blackHole(NBK.exactly(sign: abc.sign, magnitude: abc.magnitude) as T?)
            NBK.blackHole(NBK.exactly(sign: xyz.sign, magnitude: xyz.magnitude) as T?)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Numbers
//*============================================================================*

final class UInt256BenchmarksOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInt() {
        var abc = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt() {
        var abc = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt8() {
        var abc = NBK.blackHoleIdentity(Int8.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt8() {
        var abc = NBK.blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt16() {
        var abc = NBK.blackHoleIdentity(Int16.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt16() {
        var abc = NBK.blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt32() {
        var abc = NBK.blackHoleIdentity(Int32.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt32() {
        var abc = NBK.blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt64() {
        var abc = NBK.blackHoleIdentity(Int64.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt64() {
        var abc = NBK.blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float
    //=------------------------------------------------------------------------=
    
    func testFloat32() {
        var abc = NBK.blackHoleIdentity(Float32(UInt32.max))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFloat64() {
        var abc = NBK.blackHoleIdentity(Float64(UInt64.max))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testDigit() {
        var abc = NBK.blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(digit: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testSignitude() {
        var abc = NBK.blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(abc))
            NBK.blackHole(T(exactly:  abc))
            NBK.blackHole(T(clamping: abc))
            NBK.blackHole(T(truncatingIfNeeded: abc))
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
            NBK.blackHole(NBK.exactly(sign: abc.sign, magnitude: abc.magnitude) as T?)
            NBK.blackHole(NBK.exactly(sign: xyz.sign, magnitude: xyz.magnitude) as T?)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
