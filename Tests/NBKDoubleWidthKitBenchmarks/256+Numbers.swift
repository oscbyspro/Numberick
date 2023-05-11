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
// MARK: * Int256 x Numbers
//*============================================================================*

final class Int256BenchmarksOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x [U]Int
    //=------------------------------------------------------------------------=
    
    func testInt() {
        var abc = _blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt() {
        var abc = _blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt8() {
        var abc = _blackHoleIdentity(Int8.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt8() {
        var abc = _blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt16() {
        var abc = _blackHoleIdentity(Int16.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt16() {
        var abc = _blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt32() {
        var abc = _blackHoleIdentity(Int32.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt32() {
        var abc = _blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt64() {
        var abc = _blackHoleIdentity(Int64.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt64() {
        var abc = _blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float
    //=------------------------------------------------------------------------=
    
    func testFloat32() {
        var abc = _blackHoleIdentity(Float32(UInt32.max))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFloat64() {
        var abc = _blackHoleIdentity(Float64(UInt64.max))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDigit() {
        var abc = _blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(digit: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testSignitude() {
        var abc = _blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testMagnitude() {
        var abc = _blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Numbers
//*============================================================================*

final class UInt256BenchmarksOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x [U]Int
    //=------------------------------------------------------------------------=
    
    func testInt() {
        var abc = _blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt() {
        var abc = _blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt8() {
        var abc = _blackHoleIdentity(Int8.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt8() {
        var abc = _blackHoleIdentity(UInt8.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt16() {
        var abc = _blackHoleIdentity(Int16.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt16() {
        var abc = _blackHoleIdentity(UInt16.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt32() {
        var abc = _blackHoleIdentity(Int32.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt32() {
        var abc = _blackHoleIdentity(UInt32.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testInt64() {
        var abc = _blackHoleIdentity(Int64.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt64() {
        var abc = _blackHoleIdentity(UInt64.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float
    //=------------------------------------------------------------------------=
    
    func testFloat32() {
        var abc = _blackHoleIdentity(Float32(UInt32.max))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testFloat64() {
        var abc = _blackHoleIdentity(Float64(UInt64.max))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDigit() {
        var abc = _blackHoleIdentity(T.Digit.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(T(digit: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testSignitude() {
        var abc = _blackHoleIdentity(S(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
    
    func testMagnitude() {
        var abc = _blackHoleIdentity(M(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(abc))
            _blackHole(T(exactly:  abc))
            _blackHole(T(clamping: abc))
            _blackHole(T(truncatingIfNeeded: abc))
            _blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
