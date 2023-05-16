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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Numbers
//*============================================================================*

final class Int256TestsOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int, Digit
    //=------------------------------------------------------------------------=
    
    func testFromInt() {
        XCTAssertEqual(T(Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
        
        XCTAssertEqual(T(exactly:  Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(exactly:  Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
        
        XCTAssertEqual(T(clamping: Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(clamping: Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(truncatingIfNeeded: Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
    }
    
    func testFromIntAsDigit() {
        XCTAssertEqual(T(digit: Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(digit: Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt
    //=------------------------------------------------------------------------=
    
    func testFromUInt() {
        XCTAssertEqual(T(UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(exactly:  UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(clamping: UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(truncatingIfNeeded: UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int8
    //=------------------------------------------------------------------------=
    
    func testFromInt8() {
        XCTAssertEqual(T(Int8.min), -128)
        XCTAssertEqual(T(Int8.max),  127)
        
        XCTAssertEqual(T(exactly:  Int8.min), -128)
        XCTAssertEqual(T(exactly:  Int8.max),  127)
        
        XCTAssertEqual(T(clamping: Int8.min), -128)
        XCTAssertEqual(T(clamping: Int8.max),  127)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int8.min), -128)
        XCTAssertEqual(T(truncatingIfNeeded: Int8.max),  127)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt8
    //=------------------------------------------------------------------------=
    
    func testFromUInt8() {
        XCTAssertEqual(T(UInt8.min), 0)
        XCTAssertEqual(T(UInt8.max), 255)
        
        XCTAssertEqual(T(exactly:  UInt8.min), 0)
        XCTAssertEqual(T(exactly:  UInt8.max), 255)
        
        XCTAssertEqual(T(clamping: UInt8.min), 0)
        XCTAssertEqual(T(clamping: UInt8.max), 255)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt8.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt8.max), 255)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int16
    //=------------------------------------------------------------------------=
    
    func testFromInt16() {
        XCTAssertEqual(T(Int16(  )), T())
        XCTAssertEqual(T(Int16.max), 32767)
        
        XCTAssertEqual(T(exactly:  Int16.min), -32768)
        XCTAssertEqual(T(exactly:  Int16.max),  32767)
        
        XCTAssertEqual(T(clamping: Int16.min), -32768)
        XCTAssertEqual(T(clamping: Int16.max),  32767)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int16.min), -32768)
        XCTAssertEqual(T(truncatingIfNeeded: Int16.max),  32767)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt16
    //=------------------------------------------------------------------------=
    
    func testFromUInt16() {
        XCTAssertEqual(T(UInt16.min), 0)
        XCTAssertEqual(T(UInt16.max), 65535)
        
        XCTAssertEqual(T(exactly:  UInt16.min), 0)
        XCTAssertEqual(T(exactly:  UInt16.max), 65535)
        
        XCTAssertEqual(T(clamping: UInt16.min), 0)
        XCTAssertEqual(T(clamping: UInt16.max), 65535)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt16.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt16.max), 65535)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int32
    //=------------------------------------------------------------------------=
    
    func testFromInt32() {
        XCTAssertEqual(T(Int32.min), -2147483648)
        XCTAssertEqual(T(Int32.max),  2147483647)
        
        XCTAssertEqual(T(exactly:  Int32.min), -2147483648)
        XCTAssertEqual(T(exactly:  Int32.max),  2147483647)
        
        XCTAssertEqual(T(clamping: Int32.min), -2147483648)
        XCTAssertEqual(T(clamping: Int32.max),  2147483647)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int32.min), -2147483648)
        XCTAssertEqual(T(truncatingIfNeeded: Int32.max),  2147483647)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testFromUInt32() {
        XCTAssertEqual(T(UInt32.min), 0)
        XCTAssertEqual(T(UInt32.max), 4294967295)
        
        XCTAssertEqual(T(exactly:  UInt32.min), 0)
        XCTAssertEqual(T(exactly:  UInt32.max), 4294967295)
        
        XCTAssertEqual(T(clamping: UInt32.min), 0)
        XCTAssertEqual(T(clamping: UInt32.max), 4294967295)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt32.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt32.max), 4294967295)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int64
    //=------------------------------------------------------------------------=
    
    func testToInt64() {
        XCTAssertEqual(Int64(T(x64: X(1, 0, 0, 0))), 1)
        XCTAssertEqual(Int64(T(x64: X(2, 0, 0, 0))), 2)
        
        XCTAssertEqual(Int64(exactly:  T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(Int64(exactly:  T(x64: X(~0,  0,  0,  0))), nil)
        XCTAssertEqual(Int64(exactly:  T(x64: X( 1,  1,  1,  1))), nil)
        XCTAssertEqual(Int64(exactly:  T(x64: X(~0, ~0, ~0, ~0))),  -1)

        XCTAssertEqual(Int64(clamping: T(x64: X( 1,  0,  0,  0))), Int64( 1))
        XCTAssertEqual(Int64(clamping: T(x64: X(~0,  0,  0,  0))), Int64.max)
        XCTAssertEqual(Int64(clamping: T(x64: X( 1,  1,  1,  1))), Int64.max)
        XCTAssertEqual(Int64(clamping: T(x64: X(~0, ~0, ~0, ~0))), Int64(-1))

        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), ~0)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))),  1)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), ~0)
    }
    
    func testFromInt64() {
        XCTAssertEqual(T(Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max),  0,  0,  0)))
        
        XCTAssertEqual(T(exactly:  Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(exactly:  Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max),  0,  0,  0)))
        
        XCTAssertEqual(T(clamping: Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(clamping: Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max),  0,  0,  0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(truncatingIfNeeded: Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max),  0,  0,  0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testToUInt64() {
        XCTAssertEqual(UInt64(T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(UInt64(T(x64: X(~0,  0,  0,  0))), ~0)
        
        XCTAssertEqual(UInt64(exactly:  T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(UInt64(exactly:  T(x64: X(~0,  0,  0,  0))),  ~0)
        XCTAssertEqual(UInt64(exactly:  T(x64: X( 1,  1,  1,  1))), nil)
        XCTAssertEqual(UInt64(exactly:  T(x64: X(~0, ~0, ~0, ~0))), nil)

        XCTAssertEqual(UInt64(clamping: T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(UInt64(clamping: T(x64: X(~0,  0,  0,  0))),  ~0)
        XCTAssertEqual(UInt64(clamping: T(x64: X( 1,  1,  1,  1))),  ~0)
        XCTAssertEqual(UInt64(clamping: T(x64: X(~0, ~0, ~0, ~0))),   0)

        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), ~0)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))),  1)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), ~0)
    }
    
    func testFromUInt64() {
        XCTAssertEqual(T(UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(exactly:  UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(clamping: UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(truncatingIfNeeded: UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signitude
    //=------------------------------------------------------------------------=
    
    func testFromSignitude() {
        XCTAssertEqual(T(S.min), T.min)
        XCTAssertEqual(T(S.max), T.max)
        
        XCTAssertEqual(T(exactly:  S.min), T.min)
        XCTAssertEqual(T(exactly:  S.max), T.max)

        XCTAssertEqual(T(clamping: S.min), T.min)
        XCTAssertEqual(T(clamping: S.max), T.max)

        XCTAssertEqual(T(truncatingIfNeeded: S.min), T.min)
        XCTAssertEqual(T(truncatingIfNeeded: S.max), T.max)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testFromMagnitude() {
        XCTAssertEqual(T(M.min), T(  ))
        XCTAssertEqual(T(M(44)), T(44))
        
        XCTAssertEqual(T(exactly:  M.min), T())
        XCTAssertEqual(T(exactly:  M.max), nil)

        XCTAssertEqual(T(clamping: M.min), T())
        XCTAssertEqual(T(clamping: M.max), T.max)

        XCTAssertEqual(T(truncatingIfNeeded: M.min), T(x64: X( 0,  0,  0,  0)))
        XCTAssertEqual(T(truncatingIfNeeded: M.max), T(x64: X(~0, ~0, ~0, ~0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Double Width
    //=------------------------------------------------------------------------=
    
    func testToDoubleWidth() {
        typealias U = T.DoubleWidth
        
        XCTAssertEqual(U(T(x64: X( 1,  0,  0,  0))), U(descending: HL( 0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(T(x64: X(~0,  0,  0,  0))), U(descending: HL( 0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(T(x64: X( 1,  1,  1,  1))), U(descending: HL( 0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(-1, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(exactly:  T(x64: X( 1,  0,  0,  0))), U(descending: HL( 0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(exactly:  T(x64: X(~0,  0,  0,  0))), U(descending: HL( 0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(exactly:  T(x64: X( 1,  1,  1,  1))), U(descending: HL( 0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(exactly:  T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(-1, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(clamping: T(x64: X( 1,  0,  0,  0))), U(descending: HL( 0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(clamping: T(x64: X(~0,  0,  0,  0))), U(descending: HL( 0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(clamping: T(x64: X( 1,  1,  1,  1))), U(descending: HL( 0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(clamping: T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(-1, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))), U(descending: HL( 0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), U(descending: HL( 0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))), U(descending: HL( 0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(-1, M(x64: X(~0, ~0, ~0, ~0)))))
    }
    
    func testFromDoubleWidth() {
        typealias U = T.DoubleWidth
        
        XCTAssertEqual(T(U(descending: HL(T(-1), M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(U(descending: HL(T( 0), M(bitPattern: T.max)))), T.max)
        
        XCTAssertEqual(T(exactly:  U(descending: HL(T.min, M(bitPattern: T.min)))),   nil)
        XCTAssertEqual(T(exactly:  U(descending: HL(T(-1), M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(exactly:  U(descending: HL(T( 0), M(bitPattern: T.max)))), T.max)
        XCTAssertEqual(T(exactly:  U(descending: HL(T.max, M(bitPattern: T.max)))),   nil)
        
        XCTAssertEqual(T(clamping: U(descending: HL(T.min, M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(clamping: U(descending: HL(T(-1), M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(clamping: U(descending: HL(T( 0), M(bitPattern: T.max)))), T.max)
        XCTAssertEqual(T(clamping: U(descending: HL(T.max, M(bitPattern: T.max)))), T.max)
        
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T.min, M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T(-1), M(bitPattern: T.min)))), T.min)
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T( 0), M(bitPattern: T.max)))), T.max)
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T.max, M(bitPattern: T.max)))), T.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float32
    //=------------------------------------------------------------------------=
    
    func testToFloat32() {
        XCTAssertEqual(Float32(T(-1)), Float32(-1))
        XCTAssertEqual(Float32(T( 0)), Float32( 0))
        XCTAssertEqual(Float32(T( 1)), Float32( 1))
        
        XCTAssertEqual(Float32(T( Int32.min)), Float32( Int32.min))
        XCTAssertEqual(Float32(T( Int32.max)), Float32( Int32.max))

        XCTAssertEqual(Float32(T(UInt32.min)), Float32(UInt32.min))
        XCTAssertEqual(Float32(T(UInt32.max)), Float32(UInt32.max))
    }
        
    func testFromFloat32() {
        XCTAssertEqual(T( Float32(22.0)),  22)
        XCTAssertEqual(T(-Float32(22.0)), -22)
        XCTAssertEqual(T( Float32(22.5)),  22)
        XCTAssertEqual(T(-Float32(22.5)), -22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float32(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 0))), 1 as T)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 0))), nil)
    }
    
    func testFromFloat32ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float32.nan))
        XCTAssertNil(T(exactly: Float32.infinity))
        XCTAssertNil(T(exactly: Float32.signalingNaN))
        XCTAssertNil(T(exactly: Float32.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float32.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float64
    //=------------------------------------------------------------------------=
    
    func testToFloat64() {
        XCTAssertEqual(Float64(T(-1)), Float64(-1))
        XCTAssertEqual(Float64(T( 0)), Float64( 0))
        XCTAssertEqual(Float64(T( 1)), Float64( 1))
        
        XCTAssertEqual(Float64(T( Int64.min)), Float64( Int64.min))
        XCTAssertEqual(Float64(T( Int64.max)), Float64( Int64.max))

        XCTAssertEqual(Float64(T(UInt64.min)), Float64(UInt64.min))
        XCTAssertEqual(Float64(T(UInt64.max)), Float64(UInt64.max))
    }
        
    func testFromFloat64() {
        XCTAssertEqual(T( Float64(22.0)),  22)
        XCTAssertEqual(T(-Float64(22.0)), -22)
        XCTAssertEqual(T( Float64(22.5)),  22)
        XCTAssertEqual(T(-Float64(22.5)), -22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float64(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 0))), 1 as T)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 3 - 1))), T(x64: X(0, 0, 1 << 63, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 2))), T(x64: X(0, 0, 0, 1 << 62)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 1))), nil)
    }
    
    func testFromFloat64ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float64.nan))
        XCTAssertNil(T(exactly: Float64.infinity))
        XCTAssertNil(T(exactly: Float64.signalingNaN))
        XCTAssertNil(T(exactly: Float64.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float64.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Literal
    //=------------------------------------------------------------------------=
    
    func testFromLiteral() {
        XCTAssertEqual(T(x64:( 0,  0,  0,  0)),  0)
        XCTAssertEqual(T(x64:(~0,  0,  0,  0)),  18446744073709551615)
        XCTAssertEqual(T(x64:(~0, ~0,  0,  0)),  340282366920938463463374607431768211455)
        XCTAssertEqual(T(x64:(~0, ~0, ~0,  0)),  6277101735386680763835789423207666416102355444464034512895)
        XCTAssertEqual(T(x64:(~0, ~0, ~0, ~0)), -1)
        
        XCTAssertEqual(T.min, -57896044618658097711785492504343953926634992332820282019728792003956564819968)
        XCTAssertEqual(T.max,  57896044618658097711785492504343953926634992332820282019728792003956564819967)
        
        XCTAssertNil(T(_exactlyIntegerLiteral: -57896044618658097711785492504343953926634992332820282019728792003956564819969))
        XCTAssertNil(T(_exactlyIntegerLiteral:  57896044618658097711785492504343953926634992332820282019728792003956564819968))
    }
}

//*============================================================================*
// MARK: * UInt256 x Numbers
//*============================================================================*

final class UInt256TestsOnNumbers: XCTestCase {
    
    typealias S =  Int256
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int
    //=------------------------------------------------------------------------=
    
    func testFromInt() {
        XCTAssertEqual(T(Int(  )), T())
        XCTAssertEqual(T(Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  Int.min), nil)
        XCTAssertEqual(T(exactly:  Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int(  )), 0, 0, 0)))
        XCTAssertEqual(T(clamping: Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: Int.min), T(x64: X(UInt64(truncatingIfNeeded: Int.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(truncatingIfNeeded: Int.max), T(x64: X(UInt64(truncatingIfNeeded: Int.max),  0,  0,  0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt, Digit
    //=------------------------------------------------------------------------=
    
    func testFromUInt() {
        XCTAssertEqual(T(UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(exactly:  UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(clamping: UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(truncatingIfNeeded: UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
    }
    
    func testFromUIntAsDigit() {
        XCTAssertEqual(T(digit: UInt.min), T(x64: X(UInt64(truncatingIfNeeded: UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(digit: UInt.max), T(x64: X(UInt64(truncatingIfNeeded: UInt.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int8
    //=------------------------------------------------------------------------=
    
    func testFromInt8() {
        XCTAssertEqual(T(Int8(  )), T())
        XCTAssertEqual(T(Int8.max), 127)
        
        XCTAssertEqual(T(exactly:  Int8.min), nil)
        XCTAssertEqual(T(exactly:  Int8.max), 127)
        
        XCTAssertEqual(T(clamping: Int8.min), T())
        XCTAssertEqual(T(clamping: Int8.max), 127)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int8.min), ~T(127))
        XCTAssertEqual(T(truncatingIfNeeded: Int8.max),  T(127))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt8
    //=------------------------------------------------------------------------=
    
    func testFromUInt8() {
        XCTAssertEqual(T(UInt8.min), 0)
        XCTAssertEqual(T(UInt8.max), 255)
        
        XCTAssertEqual(T(exactly:  UInt8.min), 0)
        XCTAssertEqual(T(exactly:  UInt8.max), 255)
        
        XCTAssertEqual(T(clamping: UInt8.min), 0)
        XCTAssertEqual(T(clamping: UInt8.max), 255)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt8.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt8.max), 255)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int16
    //=------------------------------------------------------------------------=
    
    func testFromInt16() {
        XCTAssertEqual(T(Int16(  )), T())
        XCTAssertEqual(T(Int16.max), 32767)
        
        XCTAssertEqual(T(exactly:  Int16.min), nil)
        XCTAssertEqual(T(exactly:  Int16.max), 32767)
        
        XCTAssertEqual(T(clamping: Int16.min), T())
        XCTAssertEqual(T(clamping: Int16.max), 32767)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int16.min), ~T(32767))
        XCTAssertEqual(T(truncatingIfNeeded: Int16.max),  T(32767))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt16
    //=------------------------------------------------------------------------=
    
    func testFromUInt16() {
        XCTAssertEqual(T(UInt16.min), 0)
        XCTAssertEqual(T(UInt16.max), 65535)
        
        XCTAssertEqual(T(exactly:  UInt16.min), 0)
        XCTAssertEqual(T(exactly:  UInt16.max), 65535)
        
        XCTAssertEqual(T(clamping: UInt16.min), 0)
        XCTAssertEqual(T(clamping: UInt16.max), 65535)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt16.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt16.max), 65535)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int32
    //=------------------------------------------------------------------------=
    
    func testFromInt32() {
        XCTAssertEqual(T(Int32(  )), T())
        XCTAssertEqual(T(Int32.max), 2147483647)
        
        XCTAssertEqual(T(exactly:  Int32.min), nil)
        XCTAssertEqual(T(exactly:  Int32.max), 2147483647)
        
        XCTAssertEqual(T(clamping: Int32.min), T())
        XCTAssertEqual(T(clamping: Int32.max), 2147483647)
        
        XCTAssertEqual(T(truncatingIfNeeded: Int32.min), ~T(2147483647))
        XCTAssertEqual(T(truncatingIfNeeded: Int32.max),  T(2147483647))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testFromUInt32() {
        XCTAssertEqual(T(UInt32.min), 0)
        XCTAssertEqual(T(UInt32.max), 4294967295)
        
        XCTAssertEqual(T(exactly:  UInt32.min), 0)
        XCTAssertEqual(T(exactly:  UInt32.max), 4294967295)
        
        XCTAssertEqual(T(clamping: UInt32.min), 0)
        XCTAssertEqual(T(clamping: UInt32.max), 4294967295)
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt32.min), 0)
        XCTAssertEqual(T(truncatingIfNeeded: UInt32.max), 4294967295)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int64
    //=------------------------------------------------------------------------=
    
    func testToInt64() {
        XCTAssertEqual(Int64(T(x64: X(1, 0, 0, 0))), 1)
        XCTAssertEqual(Int64(T(x64: X(2, 0, 0, 0))), 2)
        
        XCTAssertEqual(Int64(exactly:  T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(Int64(exactly:  T(x64: X(~0,  0,  0,  0))), nil)
        XCTAssertEqual(Int64(exactly:  T(x64: X( 1,  1,  1,  1))), nil)
        XCTAssertEqual(Int64(exactly:  T(x64: X(~0, ~0, ~0, ~0))), nil)
        
        XCTAssertEqual(Int64(clamping: T(x64: X( 1,  0,  0,  0))), Int64( 1))
        XCTAssertEqual(Int64(clamping: T(x64: X(~0,  0,  0,  0))), Int64.max)
        XCTAssertEqual(Int64(clamping: T(x64: X( 1,  1,  1,  1))), Int64.max)
        XCTAssertEqual(Int64(clamping: T(x64: X(~0, ~0, ~0, ~0))), Int64.max)
        
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), ~0)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))),  1)
        XCTAssertEqual(Int64(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), ~0)
    }
    
    func testFromInt64() {
        XCTAssertEqual(T(Int64(  )), T())
        XCTAssertEqual(T(Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  Int64.min), nil)
        XCTAssertEqual(T(exactly:  Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64(  )), 0, 0, 0)))
        XCTAssertEqual(T(clamping: Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: Int64.min), T(x64: X(UInt64(truncatingIfNeeded: Int64.min), ~0, ~0, ~0)))
        XCTAssertEqual(T(truncatingIfNeeded: Int64.max), T(x64: X(UInt64(truncatingIfNeeded: Int64.max),  0,  0,  0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testToUInt64() {
        XCTAssertEqual(UInt64(T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(UInt64(T(x64: X(~0,  0,  0,  0))), ~0)
        
        XCTAssertEqual(UInt64(exactly:  T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(UInt64(exactly:  T(x64: X(~0,  0,  0,  0))),  ~0)
        XCTAssertEqual(UInt64(exactly:  T(x64: X( 1,  1,  1,  1))), nil)
        XCTAssertEqual(UInt64(exactly:  T(x64: X(~0, ~0, ~0, ~0))), nil)
        
        XCTAssertEqual(UInt64(clamping: T(x64: X( 1,  0,  0,  0))),   1)
        XCTAssertEqual(UInt64(clamping: T(x64: X(~0,  0,  0,  0))),  ~0)
        XCTAssertEqual(UInt64(clamping: T(x64: X( 1,  1,  1,  1))),  ~0)
        XCTAssertEqual(UInt64(clamping: T(x64: X(~0, ~0, ~0, ~0))),  ~0)
        
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))),  1)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), ~0)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))),  1)
        XCTAssertEqual(UInt64(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), ~0)
    }
    
    func testFromUInt64() {
        XCTAssertEqual(T(UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(exactly:  UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(exactly:  UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(clamping: UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(clamping: UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
        
        XCTAssertEqual(T(truncatingIfNeeded: UInt64.min), T(x64: X(UInt64(truncatingIfNeeded: UInt64.min), 0, 0, 0)))
        XCTAssertEqual(T(truncatingIfNeeded: UInt64.max), T(x64: X(UInt64(truncatingIfNeeded: UInt64.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signitude
    //=------------------------------------------------------------------------=
    
    func testFromSignitude() {
        XCTAssertEqual(T(S(  )), T())
        XCTAssertEqual(T(S.max), T(x64: X(~0, ~0, ~0, UInt64(bitPattern: Int64.max))))
        
        XCTAssertEqual(T(exactly:  S.min), nil)
        XCTAssertEqual(T(exactly:  S.max), T(x64: X(~0, ~0, ~0, UInt64(bitPattern: Int64.max))))

        XCTAssertEqual(T(clamping: S.min), T(x64: X( 0,  0,  0, UInt64(bitPattern: Int64(  )))))
        XCTAssertEqual(T(clamping: S.max), T(x64: X(~0, ~0, ~0, UInt64(bitPattern: Int64.max))))

        XCTAssertEqual(T(truncatingIfNeeded: S.min), T(x64: X( 0,  0,  0, UInt64(bitPattern: Int64.min))))
        XCTAssertEqual(T(truncatingIfNeeded: S.max), T(x64: X(~0, ~0, ~0, UInt64(bitPattern: Int64.max))))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testFromMagnitude() {
        XCTAssertEqual(T(M.min), T.min)
        XCTAssertEqual(T(M.max), T.max)
        
        XCTAssertEqual(T(exactly:  M.min), T.min)
        XCTAssertEqual(T(exactly:  M.max), T.max)

        XCTAssertEqual(T(clamping: M.min), T.min)
        XCTAssertEqual(T(clamping: M.max), T.max)

        XCTAssertEqual(T(truncatingIfNeeded: M.min), T.min)
        XCTAssertEqual(T(truncatingIfNeeded: M.max), T.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Double Width
    //=------------------------------------------------------------------------=
    
    func testToDoubleWidth() {
        typealias U = T.DoubleWidth
        
        XCTAssertEqual(U(T(x64: X( 1,  0,  0,  0))), U(descending: HL(0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(T(x64: X(~0,  0,  0,  0))), U(descending: HL(0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(T(x64: X( 1,  1,  1,  1))), U(descending: HL(0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(0, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(exactly:  T(x64: X( 1,  0,  0,  0))), U(descending: HL(0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(exactly:  T(x64: X(~0,  0,  0,  0))), U(descending: HL(0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(exactly:  T(x64: X( 1,  1,  1,  1))), U(descending: HL(0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(exactly:  T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(0, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(clamping: T(x64: X( 1,  0,  0,  0))), U(descending: HL(0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(clamping: T(x64: X(~0,  0,  0,  0))), U(descending: HL(0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(clamping: T(x64: X( 1,  1,  1,  1))), U(descending: HL(0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(clamping: T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(0, M(x64: X(~0, ~0, ~0, ~0)))))
        
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X( 1,  0,  0,  0))), U(descending: HL(0, M(x64: X( 1,  0,  0,  0)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X(~0,  0,  0,  0))), U(descending: HL(0, M(x64: X(~0,  0,  0,  0)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X( 1,  1,  1,  1))), U(descending: HL(0, M(x64: X( 1,  1,  1,  1)))))
        XCTAssertEqual(U(truncatingIfNeeded: T(x64: X(~0, ~0, ~0, ~0))), U(descending: HL(0, M(x64: X(~0, ~0, ~0, ~0)))))
    }
    
    func testFromDoubleWidth() {
        typealias U = T.DoubleWidth
        
        XCTAssertEqual(T(U(descending: HL(T(  ), M.min))), T.min)
        XCTAssertEqual(T(U(descending: HL(T(  ), M.max))), T.max)
        
        XCTAssertEqual(T(exactly:  U(descending: HL(T.min, M.min))), T(  ))
        XCTAssertEqual(T(exactly:  U(descending: HL(T(  ), M.min))), T.min)
        XCTAssertEqual(T(exactly:  U(descending: HL(T(  ), M.max))), T.max)
        XCTAssertEqual(T(exactly:  U(descending: HL(T.max, M.max))),   nil)
        
        XCTAssertEqual(T(clamping: U(descending: HL(T.min, M.min))), T(  ))
        XCTAssertEqual(T(clamping: U(descending: HL(T(  ), M.min))), T.min)
        XCTAssertEqual(T(clamping: U(descending: HL(T(  ), M.max))), T.max)
        XCTAssertEqual(T(clamping: U(descending: HL(T.max, M.max))), T.max)
        
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T.min, M.min))), T(  ))
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T(  ), M.min))), T.min)
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T(  ), M.max))), T.max)
        XCTAssertEqual(T(truncatingIfNeeded: U(descending: HL(T.max, M.max))), T.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float32
    //=------------------------------------------------------------------------=
    
    func testToFloat32() {
        XCTAssertEqual(Float32(T(0)), Float32(0))
        XCTAssertEqual(Float32(T(1)), Float32(1))
        
        XCTAssertEqual(Float32(T(UInt32.min)), Float32(UInt32.min))
        XCTAssertEqual(Float32(T(UInt32.max)), Float32(UInt32.max))
    }
        
    func testFromFloat32() {
        XCTAssertEqual(T(Float32(22.0)),  22)
        XCTAssertEqual(T(Float32(22.5)),  22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float32(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 0))), 1 as T)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 0))), nil)
    }
    
    func testFromFloat32ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float32.nan))
        XCTAssertNil(T(exactly: Float32.infinity))
        XCTAssertNil(T(exactly: Float32.signalingNaN))
        XCTAssertNil(T(exactly: Float32.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float32.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float64
    //=------------------------------------------------------------------------=
    
    func testToFloat64() {
        XCTAssertEqual(Float64(T(0)), Float64(0))
        XCTAssertEqual(Float64(T(1)), Float64(1))
        
        XCTAssertEqual(Float64(T(UInt64.min)), Float64(UInt64.min))
        XCTAssertEqual(Float64(T(UInt64.max)), Float64(UInt64.max))
    }
        
    func testFromFloat64() {
        XCTAssertEqual(T(Float64(22.0)),  22)
        XCTAssertEqual(T(Float64(22.5)),  22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float64(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 0))), 1 as T)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 3 - 1))), T(x64: X(0, 0, 1 << 63, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 1))), T(x64: X(0, 0, 0, 1 << 63)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 0))), nil)
    }
    
    func testFromFloat64ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float64.nan))
        XCTAssertNil(T(exactly: Float64.infinity))
        XCTAssertNil(T(exactly: Float64.signalingNaN))
        XCTAssertNil(T(exactly: Float64.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float64.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Literal
    //=------------------------------------------------------------------------=
    
    func testFromLiteral() {
        XCTAssertEqual(T(x64:( 0,  0,  0,  0)), 0)
        XCTAssertEqual(T(x64:(~0,  0,  0,  0)), 18446744073709551615)
        XCTAssertEqual(T(x64:(~0, ~0,  0,  0)), 340282366920938463463374607431768211455)
        XCTAssertEqual(T(x64:(~0, ~0, ~0,  0)), 6277101735386680763835789423207666416102355444464034512895)
        XCTAssertEqual(T(x64:(~0, ~0, ~0, ~0)), 115792089237316195423570985008687907853269984665640564039457584007913129639935)
        
        XCTAssertNil(T(_exactlyIntegerLiteral: -1))
        XCTAssertNil(T(_exactlyIntegerLiteral:  115792089237316195423570985008687907853269984665640564039457584007913129639936))
    }
}

#endif
