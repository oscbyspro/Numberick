//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Numbers x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnNumbersAsInt256: XCTestCase {
    
    typealias S  =  Int256
    typealias T  =  Int256
    typealias M  = UInt256
    
    typealias S2 = NBKDoubleWidth<S>
    typealias T2 = NBKDoubleWidth<T>
    typealias M2 = NBKDoubleWidth<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        NBKAssertNumbers(from: T(   ), default:  T(x64: X(0, 0, 0, 0)))
        NBKAssertNumbers(from: T.zero, default:  T(x64: X(0, 0, 0, 0)))
        
        for x in Int8.min ... Int8.max {
            let x = T(truncatingIfNeeded: x)
            
            XCTAssertEqual(x + T.zero, x)
            XCTAssertEqual(T.zero + x, x)
            
            XCTAssertEqual(x - x, T.zero)
            XCTAssertEqual(x - T.zero, x)
        }
    }
    
    func testOne() {
        NBKAssertNumbers(from: T( 1),  default:  T(x64: X(1, 0, 0, 0)))
        NBKAssertNumbers(from: T.one,  default:  T(x64: X(1, 0, 0, 0)))
        
        for x in Int8.min ... Int8.max {
            let x = T(truncatingIfNeeded: x)
            
            XCTAssertEqual(x * T.one, x)
            XCTAssertEqual(T.one * x, x)
            
            XCTAssertEqual(x / T.one, x)
            XCTAssertEqual(x % T.one, T.zero)
            
            if !x.isZero {
                XCTAssertEqual(x / x, T.one )
                XCTAssertEqual(x % x, T.zero)
            }
        }
    }

    func testMin() {
        NBKAssertNumbers(from:  T.min, default:  T(x64: X(0, 0, 0, 1 << 63)))
        NBKAssertNumbers(from: ~T.max, default:  T(x64: X(0, 0, 0, 1 << 63)))
    }
    
    func testMax() {
        NBKAssertNumbers(from:  T.max, default: ~T(x64: X(0, 0, 0, 1 << 63)))
        NBKAssertNumbers(from: ~T.min, default: ~T(x64: X(0, 0, 0, 1 << 63)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 64 Bits Or Less
    //=------------------------------------------------------------------------=
    
    func testToAtMost64BitSignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: I( 1))
            NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), exactly:   nil, clamping: I.max, truncating: ~0)
            NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), exactly:   nil, clamping: I.max, truncating:  1)
            NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), default: I(-1))
        }
        
        for type: any NBKFixedWidthInteger.Type in [Int.self, Int8.self, Int16.self, Int32.self, Int64.self] {
            whereIs(type)
        }
    }

    func testToAtMost64BitUnsignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: I( 1))
            NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: I.max, exactly:  I(exactly:   UInt64.max))
            NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), exactly:   nil, clamping: I.max, truncating: I( 1))
            NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), exactly:   nil, clamping: I.min, truncating: I.max)
        }
        
        for type: any NBKFixedWidthInteger.Type in [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self] {
            whereIs(type)
        }
    }
    
    func testFromAtMost64BitSignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: I.min, default: ~T(x64: X(UInt64(I.max), 0, 0, 0)))
            NBKAssertNumbers(from: I.max, default:  T(x64: X(UInt64(I.max), 0, 0, 0)))
        }
        
        for type: any NBKFixedWidthInteger.Type in [Int.self, Int8.self, Int16.self, Int32.self, Int64.self] {
            whereIs(type)
        }
    }
    
    func testFromAtMost64BitUnsignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: I.min, default:  T(x64: X(UInt64(I.min), 0, 0, 0)))
            NBKAssertNumbers(from: I.max, default:  T(x64: X(UInt64(I.max), 0, 0, 0)))
        }
        
        for type: any NBKFixedWidthInteger.Type in [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self] {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bits & Digit
    //=------------------------------------------------------------------------=
    
    func testFromUIntAsBits() {
        XCTAssertEqual(T(_truncatingBits: UInt.min), T(x64: X(UInt64(UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(_truncatingBits: UInt.max), T(x64: X(UInt64(UInt.max), 0, 0, 0)))
    }
    
    func testFromIntAsDigit() {
        XCTAssertEqual(T(digit: Int.min), ~T(x64: X(UInt64(Int.max), 0, 0, 0)))
        XCTAssertEqual(T(digit: Int.max),  T(x64: X(UInt64(Int.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signitude
    //=------------------------------------------------------------------------=
    
    func testToSignitude() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: S(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: S(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: S(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), default: S(x64: X(~0, ~0, ~0, ~0)))
    }
    
    func testFromSignitude() {
        NBKAssertNumbers(from: S.min, default: T.min)
        NBKAssertNumbers(from: S.max, default: T.max)
        
        NBKAssertNumbers(from: S(x64: X( 1,  0,  0,  0)), default: T(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: S(x64: X(~0,  0,  0,  0)), default: T(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: S(x64: X( 1,  1,  1,  1)), default: T(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: S(x64: X(~0, ~0, ~0, ~0)), default: T(x64: X(~0, ~0, ~0, ~0)))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testToMagnitude() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: M(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: M(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: M(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), exactly: nil, clamping: M.zero, truncating: M.max)
    }
    
    func testFromMagnitude() {
        NBKAssertNumbers(from: M.min, exactly: T(), clamping: 00000, truncating: T(bitPattern: M.min))
        NBKAssertNumbers(from: M.max, exactly: nil, clamping: T.max, truncating: T(bitPattern: M.max))
        
        NBKAssertNumbers(from: M(bitPattern: T.max) + 0,  default: T.max)
        NBKAssertNumbers(from: M(bitPattern: T.max) + 1,  exactly: nil, clamping: T.max, truncating: T.min)
        
        NBKAssertNumbers(from: M(x64: X( 1,  0,  0,  0)), default: T(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: M(x64: X(~0,  0,  0,  0)), default: T(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: M(x64: X( 1,  1,  1,  1)), default: T(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: M(x64: X(~0, ~0, ~0, ~0)), exactly: nil, clamping: T.max, truncating: T(-1))
        
        XCTAssertEqual(T(magnitude: T(  ).magnitude + 0), T(  ))
        XCTAssertEqual(T(magnitude: T(  ).magnitude + 1), T( 1))
        XCTAssertEqual(T(magnitude: T.max.magnitude + 0), T.max)
        XCTAssertEqual(T(magnitude: T.max.magnitude + 1),   nil)
        XCTAssertEqual(T(magnitude: T.min.magnitude - 1), T.max)
        XCTAssertEqual(T(magnitude: T.min.magnitude + 0),   nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Double Width
    //=------------------------------------------------------------------------=
    
    func testToDoubleWidth() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: T2(high:  0, low: M(x64: X( 1,  0,  0,  0))))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: T2(high:  0, low: M(x64: X(~0,  0,  0,  0))))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: T2(high:  0, low: M(x64: X( 1,  1,  1,  1))))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), default: T2(high: -1, low: M(x64: X(~0, ~0, ~0, ~0))))
    }
    
    func testFromDoubleWidth() {
        NBKAssertNumbers(from: T2(high: T.min, low: M(bitPattern: T.min)), default: T.min, exactly: nil)
        NBKAssertNumbers(from: T2(high: T(-1), low: M(bitPattern: T.min)), default: T.min)
        NBKAssertNumbers(from: T2(high: T( 0), low: M(bitPattern: T.max)), default: T.max)
        NBKAssertNumbers(from: T2(high: T.max, low: M(bitPattern: T.max)), default: T.max, exactly: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float (> 16 Bits)
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
    
    func testToFloat64() {
        XCTAssertEqual(Float64(T(-1)), Float64(-1))
        XCTAssertEqual(Float64(T( 0)), Float64( 0))
        XCTAssertEqual(Float64(T( 1)), Float64( 1))
        
        XCTAssertEqual(Float64(T( Int64.min)), Float64( Int64.min))
        XCTAssertEqual(Float64(T( Int64.max)), Float64( Int64.max))

        XCTAssertEqual(Float64(T(UInt64.min)), Float64(UInt64.min))
        XCTAssertEqual(Float64(T(UInt64.max)), Float64(UInt64.max))
    }
        
    func testFromFloat32() {
        XCTAssertEqual(T(Float32(  22.0)),  22)
        XCTAssertEqual(T(Float32( -22.0)), -22)
        XCTAssertEqual(T(Float32(  22.5)),  22)
        XCTAssertEqual(T(Float32( -22.5)), -22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float32(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 0))), T(x64: X(1,       0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 0))), nil)
    }
    
    func testFromFloat64() {
        XCTAssertEqual(T(Float64(  22.0)),  22)
        XCTAssertEqual(T(Float64( -22.0)), -22)
        XCTAssertEqual(T(Float64(  22.5)),  22)
        XCTAssertEqual(T(Float64( -22.5)), -22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float64(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 0))), T(x64: X(1,       0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 3 - 1))), T(x64: X(0, 0, 1 << 63, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 2))), T(x64: X(0, 0, 0, 1 << 62)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 1))), nil)
    }
    
    func testFromFloat32ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float32.nan))
        XCTAssertNil(T(exactly: Float32.infinity))
        XCTAssertNil(T(exactly: Float32.signalingNaN))
        XCTAssertNil(T(exactly: Float32.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float32.leastNonzeroMagnitude))
    }
    
    func testFromFloat64ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float64.nan))
        XCTAssertNil(T(exactly: Float64.infinity))
        XCTAssertNil(T(exactly: Float64.signalingNaN))
        XCTAssertNil(T(exactly: Float64.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float64.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    func testsFromSignAndMagnitude() {
        XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
        XCTAssertEqual(T(sign: .minus, magnitude: M( 1)), T(-1))
        XCTAssertEqual(T(sign: .plus,  magnitude: M.max),   nil)
        XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
        XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude), T.max)
        XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude), T.min)
    }
    
    func testsFromSignAndMagnitudeAsPlusMinusZero() {
        XCTAssertEqual(T(sign: .plus,  magnitude: M(  )), T(  ))
        XCTAssertEqual(T(sign: .minus, magnitude: M(  )), T(  ))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Numbers x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnNumbersAsUInt256: XCTestCase {
    
    typealias S  =  Int256
    typealias T  = UInt256
    typealias M  = UInt256
    
    typealias S2 = NBKDoubleWidth<S>
    typealias T2 = NBKDoubleWidth<T>
    typealias M2 = NBKDoubleWidth<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        NBKAssertNumbers(from: T(   ), default:  T(x64: X(0, 0, 0, 0)))
        NBKAssertNumbers(from: T.zero, default:  T(x64: X(0, 0, 0, 0)))
        
        for x in Int8.min ... Int8.max {
            let x = T(truncatingIfNeeded: x)
            
            XCTAssertEqual(x + T.zero, x)
            XCTAssertEqual(T.zero + x, x)
            
            XCTAssertEqual(x - x, T.zero)
            XCTAssertEqual(x - T.zero, x)
        }
    }
    
    func testOne() {
        NBKAssertNumbers(from: T( 1), default:  T(x64: X(1, 0, 0, 0)))
        NBKAssertNumbers(from: T.one, default:  T(x64: X(1, 0, 0, 0)))
        
        for x in Int8.min ... Int8.max {
            let x = T(truncatingIfNeeded: x)
            
            XCTAssertEqual(x * T.one, x)
            XCTAssertEqual(T.one * x, x)
            
            XCTAssertEqual(x / T.one, x)
            XCTAssertEqual(x % T.one, T.zero)
            
            if !x.isZero {
                XCTAssertEqual(x / x, T.one )
                XCTAssertEqual(x % x, T.zero)
            }
        }
    }
    
    func testMin() {
        NBKAssertNumbers(from:  T.min, default:  T(x64: X(0, 0, 0, 0)))
        NBKAssertNumbers(from: ~T.max, default:  T(x64: X(0, 0, 0, 0)))
    }
    
    func testMax() {
        NBKAssertNumbers(from:  T.max, default: ~T(x64: X(0, 0, 0, 0)))
        NBKAssertNumbers(from: ~T.min, default: ~T(x64: X(0, 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x 64 Bits Or Less
    //=------------------------------------------------------------------------=
    
    func testToAtMost64BitSignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: 1 as I)
            NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), exactly: nil, clamping: I.max, truncating: ~0)
            NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), exactly: nil, clamping: I.max, truncating:  1)
            NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), exactly: nil, clamping: I.max, truncating: ~0)
        }
        
        for type: any NBKFixedWidthInteger.Type in [Int.self, Int8.self, Int16.self, Int32.self, Int64.self] {
            whereIs(type)
        }
    }

    func testToAtMost64BitUnsignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: I( 1))
            NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: I.max, exactly:  I(exactly:   UInt64.max))
            NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), exactly:   nil, clamping: I.max, truncating: I( 1))
            NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), exactly:   nil, clamping: I.max, truncating: I.max)
        }
        
        for type: any NBKFixedWidthInteger.Type in [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self] {
            whereIs(type)
        }
    }
    
    func testFromAtMost64BitSignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: I.min, exactly: nil, clamping: 0, truncating: ~T(x64: X(UInt64(I.max), 0, 0, 0)))
            NBKAssertNumbers(from: I.max, default: /*-------------------------*/  T(x64: X(UInt64(I.max), 0, 0, 0)))
        }
        
        for type: any NBKFixedWidthInteger.Type in [Int.self, Int8.self, Int16.self, Int32.self, Int64.self] {
            whereIs(type)
        }
    }
    
    func testFromAtMost64BitUnsignedInteger() {
        func whereIs<I: NBKFixedWidthInteger>(_ type: I.Type) {
            NBKAssertNumbers(from: I.min, default: T(x64: X(UInt64(I.min), 0, 0, 0)))
            NBKAssertNumbers(from: I.max, default: T(x64: X(UInt64(I.max), 0, 0, 0)))
        }
        
        for type: any NBKFixedWidthInteger.Type in [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self] {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bits & Digit
    //=------------------------------------------------------------------------=
    
    func testFromUIntAsBits() {
        XCTAssertEqual(T(_truncatingBits: UInt.min), T(x64: X(UInt64(UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(_truncatingBits: UInt.max), T(x64: X(UInt64(UInt.max), 0, 0, 0)))
    }
    
    func testFromUIntAsDigit() {
        XCTAssertEqual(T(digit: UInt.min), T(x64: X(UInt64(UInt.min), 0, 0, 0)))
        XCTAssertEqual(T(digit: UInt.max), T(x64: X(UInt64(UInt.max), 0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signitude
    //=------------------------------------------------------------------------=
    
    func testToSignitude() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: S(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: S(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: S(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), exactly: nil, clamping: S.max, truncating: S(-1))
    }
    
    func testFromSignitude() {
        NBKAssertNumbers(from: S.min, exactly: nil, clamping: T.min, truncating: T(bitPattern: S.min))
        NBKAssertNumbers(from: S.max, default: /*-----------------------------*/ T(bitPattern: S.max))
        
        NBKAssertNumbers(from: S(x64: X( 1,  0,  0,  0)), default: T(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: S(x64: X(~0,  0,  0,  0)), default: T(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: S(x64: X( 1,  1,  1,  1)), default: T(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: S(x64: X(~0, ~0, ~0, ~0)), exactly: nil, clamping: T.min, truncating: T(bitPattern: S(-1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testToMagnitude() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: M(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: M(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: M(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), default: M(x64: X(~0, ~0, ~0, ~0)))
    }
    
    func testFromMagnitude() {
        NBKAssertNumbers(from: M.min, default: T.min)
        NBKAssertNumbers(from: M.max, default: T.max)
        
        NBKAssertNumbers(from: M(x64: X( 1,  0,  0,  0)), default: T(x64: X( 1,  0,  0,  0)))
        NBKAssertNumbers(from: M(x64: X(~0,  0,  0,  0)), default: T(x64: X(~0,  0,  0,  0)))
        NBKAssertNumbers(from: M(x64: X( 1,  1,  1,  1)), default: T(x64: X( 1,  1,  1,  1)))
        NBKAssertNumbers(from: M(x64: X(~0, ~0, ~0, ~0)), default: T(x64: X(~0, ~0, ~0, ~0)))
        
        XCTAssertEqual(T(magnitude: T.min.magnitude + 0), T.min + 0)
        XCTAssertEqual(T(magnitude: T.min.magnitude + 1), T.min + 1)
        XCTAssertEqual(T(magnitude: T.max.magnitude - 1), T.max - 1)
        XCTAssertEqual(T(magnitude: T.max.magnitude - 0), T.max - 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Double Width
    //=------------------------------------------------------------------------=
    
    func testToDoubleWidth() {
        NBKAssertNumbers(from: T(x64: X( 1,  0,  0,  0)), default: T2(low: M(x64: X( 1,  0,  0,  0))))
        NBKAssertNumbers(from: T(x64: X(~0,  0,  0,  0)), default: T2(low: M(x64: X(~0,  0,  0,  0))))
        NBKAssertNumbers(from: T(x64: X( 1,  1,  1,  1)), default: T2(low: M(x64: X( 1,  1,  1,  1))))
        NBKAssertNumbers(from: T(x64: X(~0, ~0, ~0, ~0)), default: T2(low: M(x64: X(~0, ~0, ~0, ~0))))
    }
    
    func testFromDoubleWidth() {
        NBKAssertNumbers(from: T2(high: T.min, low: M.min), default: T(  ))
        NBKAssertNumbers(from: T2(high: T(  ), low: M.min), default: T.min)
        NBKAssertNumbers(from: T2(high: T(  ), low: M.max), default: T.max)
        NBKAssertNumbers(from: T2(high: T.max, low: M.max), default: T.max, exactly: nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Float (> 16 Bits)
    //=------------------------------------------------------------------------=
    
    func testToFloat32() {
        XCTAssertEqual(Float32(T(0)), Float32(0))
        XCTAssertEqual(Float32(T(1)), Float32(1))
        
        XCTAssertEqual(Float32(T(UInt32.min)), Float32(UInt32.min))
        XCTAssertEqual(Float32(T(UInt32.max)), Float32(UInt32.max))
    }
    
    func testToFloat64() {
        XCTAssertEqual(Float64(T(0)), Float64(0))
        XCTAssertEqual(Float64(T(1)), Float64(1))
        
        XCTAssertEqual(Float64(T(UInt64.min)), Float64(UInt64.min))
        XCTAssertEqual(Float64(T(UInt64.max)), Float64(UInt64.max))
    }
    
    func testFromFloat32() {
        XCTAssertEqual(T(Float32(  22.0)), 22)
        XCTAssertEqual(T(Float32(  22.5)), 22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float32(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 0))), T(x64: X(1,       0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 0))), nil)
    }
    
    func testFromFloat64() {
        XCTAssertEqual(T(Float64(  22.0)), 22)
        XCTAssertEqual(T(Float64(  22.5)), 22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(T.bitWidth))), nil)
        XCTAssertEqual(T(exactly: -pow(2, Float64(T.bitWidth))), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 0))), T(x64: X(1,       0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 1 - 1))), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 2 - 1))), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 3 - 1))), T(x64: X(0, 0, 1 << 63, 0)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 1))), T(x64: X(0, 0, 0, 1 << 63)))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 0))), nil)
    }
    
    func testFromFloat32ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float32.nan))
        XCTAssertNil(T(exactly: Float32.infinity))
        XCTAssertNil(T(exactly: Float32.signalingNaN))
        XCTAssertNil(T(exactly: Float32.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float32.leastNonzeroMagnitude))
    }
    
    func testFromFloat64ValuesThatAreSpecial() {
        XCTAssertNil(T(exactly: Float64.nan))
        XCTAssertNil(T(exactly: Float64.infinity))
        XCTAssertNil(T(exactly: Float64.signalingNaN))
        XCTAssertNil(T(exactly: Float64.leastNormalMagnitude))
        XCTAssertNil(T(exactly: Float64.leastNonzeroMagnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    func testsFromSignAndMagnitude() {
        XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
        XCTAssertEqual(T(sign: .minus, magnitude: M( 1)),   nil)
        XCTAssertEqual(T(sign: .plus,  magnitude: M.max), T.max)
        XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
        XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude), T.max)
        XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude), T.min)
    }
    
    func testsFromSignAndMagnitudeAsPlusMinusZero() {
        XCTAssertEqual(T(sign: .plus,  magnitude: M(  )), T(  ))
        XCTAssertEqual(T(sign: .minus, magnitude: M(  )), T(  ))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Numbers x Assertions
//*============================================================================*

private func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: `default`, truncating: `default`, file: file, line: line)
}

private func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, exactly: O?,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: exactly, clamping: `default`, truncating: `default`, file: file, line: line)
}

private func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, clamping: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: clamping, truncating: `default`, file: file, line: line)
}

private func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: `default`, truncating: truncating, file: file, line: line)
}

private func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, exactly: O?, clamping: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  let exactly {
        XCTAssertEqual(O(value), exactly, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(O(exactly:            value), exactly,    file: file, line: line)
    XCTAssertEqual(O(clamping:           value), clamping,   file: file, line: line)
    XCTAssertEqual(O(truncatingIfNeeded: value), truncating, file: file, line: line)
}
