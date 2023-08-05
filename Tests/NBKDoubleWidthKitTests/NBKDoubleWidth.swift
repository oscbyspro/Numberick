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
// MARK: * NBK x Double Width
//*============================================================================*

final class NBKDoubleWidthTests: XCTestCase {
    
    typealias T = any NBKFixedWidthInteger.Type

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [T] = [ Int256.self,  Int512.self,  Int1024.self,  Int2048.self,  Int4096.self]
    static let unsigned: [T] = [UInt256.self, UInt512.self, UInt1024.self, UInt2048.self, UInt4096.self]
    static let types:    [T] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKDoubleWidthTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMemoryLayout() {
        func whereIs<T>(_ type: T.Type) where T: NBKFixedWidthInteger {
            XCTAssert(MemoryLayout<T>.size *  8 == T.bitWidth)
            XCTAssert(MemoryLayout<T>.size == MemoryLayout<T>.stride)
            XCTAssert(MemoryLayout<T>.size /  MemoryLayout<UInt>.stride >= 2)
            XCTAssert(MemoryLayout<T>.size %  MemoryLayout<UInt>.stride == 0)
            XCTAssert(MemoryLayout<T>.alignment == MemoryLayout<UInt>.alignment)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Int256
//*============================================================================*

final class NBKDoubleWidthTestsAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
    
    func testFromX32() {
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0)), T(1) <<  32)
        XCTAssertEqual(T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0)), T(1) <<  96)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0)), T(1) << 128)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0)), T(1) << 160)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0)), T(1) << 192)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1)), T(1) << 224)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Halves
    //=------------------------------------------------------------------------=
    
    func testHalvesGetSetInit() {
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 0, 0)), T.Low(x64:(0, 0)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 0, 0)), T.Low(x64:(1, 2)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 3, 4)), T.Low(x64:(0, 0)), T.High(x64:(3, 4)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 3, 4)), T.Low(x64:(1, 2)), T.High(x64:(3, 4)))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Int256
//*============================================================================*

final class NBKDoubleWidthTestsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
    
    func testFromX32() {
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0)), T(1) <<  32)
        XCTAssertEqual(T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0)), T(1) <<  96)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0)), T(1) << 128)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0)), T(1) << 160)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0)), T(1) << 192)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1)), T(1) << 224)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Halves
    //=------------------------------------------------------------------------=
    
    func testHalvesGetSetInit() {
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 0, 0)), T.Low(x64:(0, 0)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 0, 0)), T.Low(x64:(1, 2)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 3, 4)), T.Low(x64:(0, 0)), T.High(x64:(3, 4)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 3, 4)), T.Low(x64:(1, 2)), T.High(x64:(3, 4)))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Assertions
//*============================================================================*

private func NBKAssertHalvesGetSetInit<H: NBKFixedWidthInteger>(
_ value: NBKDoubleWidth<H>, _ low: H.Magnitude, _ high: H,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  high.isZero {
        XCTAssertEqual(value, T(low:  low ), file: file, line: line)
    }
    
    if  low.isZero {
        XCTAssertEqual(value, T(high: high), file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(value, T(low:  low,  high: high), file: file, line: line)
    XCTAssertEqual(value, T(high: high, low:  low ), file: file, line: line)
    
    XCTAssertEqual(value, T(ascending:  LH(low, high)), file: file, line: line)
    XCTAssertEqual(value, T(descending: HL(high, low)), file: file, line: line)
    
    XCTAssertEqual(value.low,  low,  file: file, line: line)
    XCTAssertEqual(value.high, high, file: file, line: line)
    
    XCTAssertEqual(value.ascending.low,   low,  file: file, line: line)
    XCTAssertEqual(value.ascending.high,  high, file: file, line: line)
    
    XCTAssertEqual(value.descending.low,  low,  file: file, line: line)
    XCTAssertEqual(value.descending.high, high, file: file, line: line)
    
    XCTAssertEqual(value, { var x = T(); x.low = low; x.high =  high;  return x }(), file: file, line: line)
    XCTAssertEqual(value, { var x = T(); x.ascending  = LH(low, high); return x }(), file: file, line: line)
    XCTAssertEqual(value, { var x = T(); x.descending = HL(high, low); return x }(), file: file, line: line)
}

//*============================================================================*
// MARK: * NBK x Double Width x Initializers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Tuples
    //=------------------------------------------------------------------------=
    
    init(x64: NBK.U128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK.U128X32) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
    
    init(x64: NBK.U256X64) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.3, x64.2, x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK.U256X32) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.7, x32.6, x32.5, x32.4, x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
}
