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
@testable import NBKFlexibleWidthKit
import XCTest

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Numbers
//*============================================================================*

final class UIntXLTestsOnNumbers: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testZero() {
        XCTAssertEqual(T(  0), T(words:[0]))
        XCTAssertEqual(T.zero, T(words:[0]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int
    //=------------------------------------------------------------------------=
    
    func testToInt() {
        NBKAssertNumbers(from: T(words:[ 1,  0,  0,  0] as [UInt]), default: Int( 1))
        NBKAssertNumbers(from: T(words:[~0,  0,  0,  0] as [UInt]), exactly: nil, clamping: Int.max, truncating: -1)
        NBKAssertNumbers(from: T(words:[ 1,  1,  1,  1] as [UInt]), exactly: nil, clamping: Int.max, truncating:  1)
        NBKAssertNumbers(from: T(words:[~0, ~0, ~0, ~0] as [UInt]), exactly: nil, clamping: Int.max, truncating: -1)
    }
    
    func testFromInt() {
        NBKAssertNumbers(from: Int.min, exactly: nil, clamping: 0, truncating: T(words: Int.min.words))
        NBKAssertNumbers(from: Int.max, default: /*-------------------------*/ T(words: Int.max.words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int32
    //=------------------------------------------------------------------------=
    
    func testToInt32() {
        NBKAssertNumbers(from: T(x32: [ 1,  0,  0,  0] as Y), default:  Int32( 1))
        NBKAssertNumbers(from: T(x32: [~0,  0,  0,  0] as Y), exactly:  nil, clamping: Int32.max, truncating: -1)
        NBKAssertNumbers(from: T(x32: [ 1,  1,  1,  1] as Y), exactly:  nil, clamping: Int32.max, truncating:  1)
        NBKAssertNumbers(from: T(x32: [~0, ~0, ~0, ~0] as Y), exactly:  nil, clamping: Int32.max, truncating: -1)
    }
    
    func testFromInt32() {
        NBKAssertNumbers(from: Int32.min, exactly: nil, clamping: 0, truncating: T(words: Int32.min.words))
        NBKAssertNumbers(from: Int32.max, default: /*-------------------------*/ T(words: Int32.max.words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int64
    //=------------------------------------------------------------------------=
    
    func testToInt64() {
        NBKAssertNumbers(from: T(x64: [ 1,  0,  0,  0] as X), default:  Int64( 1))
        NBKAssertNumbers(from: T(x64: [~0,  0,  0,  0] as X), exactly:  nil, clamping: Int64.max, truncating: -1)
        NBKAssertNumbers(from: T(x64: [ 1,  1,  1,  1] as X), exactly:  nil, clamping: Int64.max, truncating:  1)
        NBKAssertNumbers(from: T(x64: [~0, ~0, ~0, ~0] as X), exactly:  nil, clamping: Int64.max, truncating: -1)
    }
    
    func testFromInt64() {
        NBKAssertNumbers(from: Int64.min, exactly: nil, clamping: 0, truncating: T(words: Int64.min.words))
        NBKAssertNumbers(from: Int64.max, default: /*-------------------------*/ T(words: Int64.max.words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt
    //=------------------------------------------------------------------------=
    
    func testToUInt() {
        NBKAssertNumbers(from: T(words:[ 1,  0,  0,  0] as [UInt]), default:  UInt( 1))
        NBKAssertNumbers(from: T(words:[~0,  0,  0,  0] as [UInt]), default: ~UInt( 0))
        NBKAssertNumbers(from: T(words:[ 1,  1,  1,  1] as [UInt]), exactly:  nil, clamping: UInt.max, truncating:  1)
        NBKAssertNumbers(from: T(words:[~0, ~0, ~0, ~0] as [UInt]), exactly:  nil, clamping: UInt.max, truncating: ~0)
    }
    
    func testFromUInt() {
        NBKAssertNumbers(from: UInt.min, default: T(words: UInt.min.words))
        NBKAssertNumbers(from: UInt.max, default: T(words: UInt.max.words))
    }

    func testFromUIntAsDigit() {
        XCTAssertEqual(T(digit: UInt.min), T(words:[UInt.min]))
        XCTAssertEqual(T(digit: UInt.max), T(words:[UInt.max]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testToUInt32() {
        NBKAssertNumbers(from: T(x32: [ 1,  0,  0,  0] as Y), default:  UInt32( 1))
        NBKAssertNumbers(from: T(x32: [~0,  0,  0,  0] as Y), default: ~UInt32( 0))
        NBKAssertNumbers(from: T(x32: [ 1,  1,  1,  1] as Y), exactly:  nil, clamping: UInt32.max, truncating:  1)
        NBKAssertNumbers(from: T(x32: [~0, ~0, ~0, ~0] as Y), exactly:  nil, clamping: UInt32.max, truncating: ~0)
    }
    
    func testFromUInt32() {
        NBKAssertNumbers(from: UInt32.min, default: T(words: UInt32.min.words))
        NBKAssertNumbers(from: UInt32.max, default: T(words: UInt32.max.words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testFromUInt64() {
        NBKAssertNumbers(from: UInt64.min, default: T(words: UInt64.min.words))
        NBKAssertNumbers(from: UInt64.max, default: T(words: UInt64.max.words))
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
        XCTAssertEqual(T(Float32(  22.0)), 22)
        XCTAssertEqual(T(Float32(  22.5)), 22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 0 - 0))), T(x64:[1,       0, 0, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 1 - 1))), T(x64:[1 << 63, 0, 0, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float32(64 * 2 - 1))), T(x64:[0, 1 << 63, 0, 0] as X))
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
        XCTAssertEqual(T(Float64(  22.0)), 22)
        XCTAssertEqual(T(Float64(  22.5)), 22)
        
        XCTAssertEqual(T(exactly:  22.5), nil)
        XCTAssertEqual(T(exactly: -22.5), nil)
        
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 1))), nil)
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 0 - 0))), T(x64:[1,       0, 0, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 1 - 1))), T(x64:[1 << 63, 0, 0, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 2 - 1))), T(x64:[0, 1 << 63, 0, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 3 - 1))), T(x64:[0, 0, 1 << 63, 0] as X))
        XCTAssertEqual(T(exactly:  pow(2, Float64(64 * 4 - 1))), T(x64:[0, 0, 0, 1 << 63] as X))
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
        XCTAssertEqual(T.exactly (sign: .plus,  magnitude: M( 1)), T( 1))
        XCTAssertEqual(T.clamping(sign: .plus,  magnitude: M( 1)), T( 1))
        
        XCTAssertEqual(T.exactly (sign: .minus, magnitude: M( 1)),   nil)
        XCTAssertEqual(T.clamping(sign: .minus, magnitude: M( 1)), T(  ))
    }
    
    func testsFromSignAndMagnitudeAsPlusMinusZero() {
        XCTAssertEqual(T.exactly (sign: .plus,  magnitude: M(  )), T(  ))
        XCTAssertEqual(T.clamping(sign: .plus,  magnitude: M(  )), T(  ))
        
        XCTAssertEqual(T.exactly (sign: .minus, magnitude: M(  )), T(  ))
        XCTAssertEqual(T.clamping(sign: .minus, magnitude: M(  )), T(  ))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Literal
    //=------------------------------------------------------------------------=
    
    func testFromLiteral() {
        XCTAssertEqual(T(x64: [ 0,  0,  0,  0] as X), 0)
        XCTAssertEqual(T(x64: [~0,  0,  0,  0] as X), 18446744073709551615)
        XCTAssertEqual(T(x64: [~0, ~0,  0,  0] as X), 340282366920938463463374607431768211455)
        XCTAssertEqual(T(x64: [~0, ~0, ~0,  0] as X), 6277101735386680763835789423207666416102355444464034512895)
        XCTAssertEqual(T(x64: [~0, ~0, ~0, ~0] as X), 115792089237316195423570985008687907853269984665640564039457584007913129639935)
        
        XCTAssertNil(T(exactlyIntegerLiteral: -1))
    }
}

#endif
