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
import XCTest

//*============================================================================*
// MARK: * NBK x Bit Cast x Integers
//*============================================================================*

final class BitCastTestsOnIntegers: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let uint32_top = UInt32.max >> 01
    let uint64_top = UInt64.max >> 01
    
    let uint32_msb = UInt32( 1) << 31
    let uint64_msb = UInt64( 1) << 63
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int as Int
    //=------------------------------------------------------------------------=
    
    func testInitOrBitCastInt32AsInt32() {
        NBKAssertInitOrBitCast(Int32.min, exactly: Int32.min >> 00, clamping: Int32.min >> 00, truncating: Int32.min >> 00)
        NBKAssertInitOrBitCast(Int32(-1), exactly: Int32(-1) >> 00, clamping: Int32(-1) >> 00, truncating: Int32(-1) >> 00)
        NBKAssertInitOrBitCast(Int32(  ), exactly: Int32(  ) >> 00, clamping: Int32(  ) >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(Int32.max, exactly: Int32.max >> 00, clamping: Int32.max >> 00, truncating: Int32.max >> 00)
    }
    
    func testInitOrBitCastInt32AsInt64() {
        NBKAssertInitOrBitCast(Int32.min, exactly: Int64.min >> 32, clamping: Int64.min >> 32, truncating: Int64.min >> 32)
        NBKAssertInitOrBitCast(Int32(-1), exactly: Int64(-1) >> 00, clamping: Int64(-1) >> 00, truncating: Int64(-1) >> 00)
        NBKAssertInitOrBitCast(Int32(  ), exactly: Int64(  ) >> 00, clamping: Int64(  ) >> 00, truncating: Int64(  ) >> 00)
        NBKAssertInitOrBitCast(Int32.max, exactly: Int64.max >> 32, clamping: Int64.max >> 32, truncating: Int64.max >> 32)
    }
    
    func testInitOrBitCastInt64AsInt32() {
        NBKAssertInitOrBitCast(Int64.min, exactly: nil,             clamping: Int32.min >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(Int64(-1), exactly: Int32(-1) >> 00, clamping: Int32(-1) >> 00, truncating: Int32(-1) >> 00)
        NBKAssertInitOrBitCast(Int64(  ), exactly: Int32(  ) >> 00, clamping: Int32(  ) >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(Int64.max, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32(-1) >> 00)
    }
    
    func testInitOrBitCastInt64AsInt64() {
        NBKAssertInitOrBitCast(Int64.min, exactly: Int64.min >> 00, clamping: Int64.min >> 00, truncating: Int64.min >> 00)
        NBKAssertInitOrBitCast(Int64(-1), exactly: Int64(-1) >> 00, clamping: Int64(-1) >> 00, truncating: Int64(-1) >> 00)
        NBKAssertInitOrBitCast(Int64(  ), exactly: Int64(  ) >> 00, clamping: Int64(  ) >> 00, truncating: Int64(  ) >> 00)
        NBKAssertInitOrBitCast(Int64.max, exactly: Int64.max >> 00, clamping: Int64.max >> 00, truncating: Int64.max >> 00)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt as UInt
    //=------------------------------------------------------------------------=
    
    func testInitOrBitCastUInt32AsUInt32() {
        NBKAssertInitOrBitCast(UInt32.min, exactly: UInt32(  ) >> 00, clamping: UInt32(  ) >> 00, truncating: UInt32(  ) >> 00)
        NBKAssertInitOrBitCast(uint32_top, exactly: UInt32.max >> 01, clamping: UInt32.max >> 01, truncating: UInt32.max >> 01)
        NBKAssertInitOrBitCast(uint32_msb, exactly: UInt32( 1) << 31, clamping: UInt32( 1) << 31, truncating: UInt32( 1) << 31)
        NBKAssertInitOrBitCast(UInt32.max, exactly: UInt32.max >> 00, clamping: UInt32.max >> 00, truncating: UInt32.max >> 00)
    }
    
    func testInitOrBitCastUInt32AsUInt64() {
        NBKAssertInitOrBitCast(UInt32.min, exactly: UInt64(  ) >> 32, clamping: UInt64(  ) >> 32, truncating: UInt64(  ) >> 32)
        NBKAssertInitOrBitCast(uint32_top, exactly: UInt64.max >> 33, clamping: UInt64.max >> 33, truncating: UInt64.max >> 33)
        NBKAssertInitOrBitCast(uint32_msb, exactly: UInt64( 1) << 31, clamping: UInt64( 1) << 31, truncating: UInt64( 1) << 31)
        NBKAssertInitOrBitCast(UInt32.max, exactly: UInt64.max >> 32, clamping: UInt64.max >> 32, truncating: UInt64.max >> 32)
    }
    
    func testInitOrBitCastUInt64AsUInt32() {
        NBKAssertInitOrBitCast(UInt64.min, exactly: UInt32(  ) >> 00, clamping: UInt32(  ) >> 00, truncating: UInt32(  ) >> 00)
        NBKAssertInitOrBitCast(uint64_top, exactly: nil,              clamping: UInt32.max >> 00, truncating: UInt32.max >> 00)
        NBKAssertInitOrBitCast(uint64_msb, exactly: nil,              clamping: UInt32.max >> 00, truncating: UInt32(  ) << 00)
        NBKAssertInitOrBitCast(UInt64.max, exactly: nil,              clamping: UInt32.max >> 00, truncating: UInt32.max >> 00)
    }
    
    func testInitOrBitCastUInt64AsUInt64() {
        NBKAssertInitOrBitCast(UInt64.min, exactly: UInt64(  ) >> 00, clamping: UInt64(  ) >> 00, truncating: UInt64(  ) >> 00)
        NBKAssertInitOrBitCast(uint64_top, exactly: UInt64.max >> 01, clamping: UInt64.max >> 01, truncating: UInt64.max >> 01)
        NBKAssertInitOrBitCast(uint64_msb, exactly: UInt64( 1) << 63, clamping: UInt64( 1) << 63, truncating: UInt64( 1) << 63)
        NBKAssertInitOrBitCast(UInt64.max, exactly: UInt64.max >> 00, clamping: UInt64.max >> 00, truncating: UInt64.max >> 00)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int as UInt
    //=------------------------------------------------------------------------=
    
    func testInitOrBitCastInt32AsUInt32() {
        NBKAssertInitOrBitCast(Int32.min, exactly: nil,              clamping: UInt32(  ) >> 00, truncating: UInt32( 1) << 31)
        NBKAssertInitOrBitCast(Int32(-1), exactly: nil,              clamping: UInt32(  ) >> 00, truncating: UInt32.max >> 00)
        NBKAssertInitOrBitCast(Int32(  ), exactly: UInt32(  ) >> 00, clamping: UInt32(  ) >> 00, truncating: UInt32(  ) >> 00)
        NBKAssertInitOrBitCast(Int32.max, exactly: UInt32.max >> 01, clamping: UInt32.max >> 01, truncating: UInt32.max >> 01)
    }
    
    func testInitOrBitCastInt32AsUInt64() {
        NBKAssertInitOrBitCast(Int32.min, exactly: nil,              clamping: UInt64(  ) >> 00, truncating: UInt64.max << 31)
        NBKAssertInitOrBitCast(Int32(-1), exactly: nil,              clamping: UInt64(  ) >> 00, truncating: UInt64.max >> 00)
        NBKAssertInitOrBitCast(Int32(  ), exactly: UInt64(  ) >> 00, clamping: UInt64(  ) >> 00, truncating: UInt64(  ) >> 00)
        NBKAssertInitOrBitCast(Int32.max, exactly: UInt64.max >> 33, clamping: UInt64.max >> 33, truncating: UInt64.max >> 33)
    }
    
    func testInitOrBitCastInt64AsUInt32() {
        NBKAssertInitOrBitCast(Int64.min, exactly: nil,              clamping: UInt32(  ) >> 00, truncating: UInt32(  ) >> 00)
        NBKAssertInitOrBitCast(Int64(-1), exactly: nil,              clamping: UInt32(  ) >> 00, truncating: UInt32.max >> 00)
        NBKAssertInitOrBitCast(Int64(  ), exactly: UInt32(  ) >> 00, clamping: UInt32(  ) >> 00, truncating: UInt32(  ) >> 00)
        NBKAssertInitOrBitCast(Int64.max, exactly: nil,              clamping: UInt32.max >> 00, truncating: UInt32.max >> 00)
    }
    
    func testInitOrBitCastInt64AsUInt64() {
        NBKAssertInitOrBitCast(Int64.min, exactly: nil,              clamping: UInt64(  ) >> 00, truncating: UInt64( 1) << 63)
        NBKAssertInitOrBitCast(Int64(-1), exactly: nil,              clamping: UInt64(  ) >> 00, truncating: UInt64.max >> 00)
        NBKAssertInitOrBitCast(Int64(  ), exactly: UInt64(  ) >> 00, clamping: UInt64(  ) >> 00, truncating: UInt64(  ) >> 00)
        NBKAssertInitOrBitCast(Int64.max, exactly: UInt64.max >> 01, clamping: UInt64.max >> 01, truncating: UInt64.max >> 01)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt as Int
    //=------------------------------------------------------------------------=
    
    func testInitOrBitCastUInt32AsInt32() {
        NBKAssertInitOrBitCast(UInt32.min, exactly: Int32(  ) >> 00, clamping: Int32(  ) >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(uint32_top, exactly: Int32.max >> 00, clamping: Int32.max >> 00, truncating: Int32.max >> 00)
        NBKAssertInitOrBitCast(uint32_msb, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32.min >> 00)
        NBKAssertInitOrBitCast(UInt32.max, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32(-1) >> 00)
    }
    
    func testInitOrBitCastUInt32AsInt64() {
        NBKAssertInitOrBitCast(UInt32.min, exactly: Int64(  ) >> 00, clamping: Int64(  ) >> 00, truncating: Int64(  ) >> 00)
        NBKAssertInitOrBitCast(uint32_top, exactly: Int64.max >> 32, clamping: Int64.max >> 32, truncating: Int64.max >> 32)
        NBKAssertInitOrBitCast(uint32_msb, exactly: Int64( 1) << 31, clamping: Int64( 1) << 31, truncating: Int64( 1) << 31)
        NBKAssertInitOrBitCast(UInt32.max, exactly: Int64.max >> 31, clamping: Int64.max >> 31, truncating: Int64.max >> 31)
    }
    
    func testInitOrBitCastUInt64AsInt32() {
        NBKAssertInitOrBitCast(UInt64.min, exactly: Int32(  ) >> 00, clamping: Int32(  ) >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(uint64_top, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32(-1) >> 00)
        NBKAssertInitOrBitCast(uint64_msb, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32(  ) >> 00)
        NBKAssertInitOrBitCast(UInt64.max, exactly: nil,             clamping: Int32.max >> 00, truncating: Int32(-1) >> 00)
    }
    
    func testInitOrBitCastUInt64AsInt64() {
        NBKAssertInitOrBitCast(UInt64.min, exactly: Int64(  ) >> 00, clamping: Int64(  ) >> 00, truncating: Int64(  ) >> 00)
        NBKAssertInitOrBitCast(uint64_top, exactly: Int64.max >> 00, clamping: Int64.max >> 00, truncating: Int64.max >> 00)
        NBKAssertInitOrBitCast(uint64_msb, exactly: nil,             clamping: Int64.max >> 00, truncating: Int64.min >> 00)
        NBKAssertInitOrBitCast(UInt64.max, exactly: nil,             clamping: Int64.max >> 00, truncating: Int64(-1) >> 00)
    }
}

//=----------------------------------------------------------------------------=
// MARK: Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertInitOrBitCast<I: NBKFixedWidthInteger, O: NBKFixedWidthInteger>(
_ source: I, exactly: O?, clamping: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  let exactly {
        XCTAssertEqual(NBK.initOrBitCast(source), exactly, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(NBK.initOrBitCast(exactly:    source), exactly,    file: file, line: line)
    XCTAssertEqual(NBK.initOrBitCast(clamping:   source), clamping,   file: file, line: line)
    XCTAssertEqual(NBK.initOrBitCast(truncating: source), truncating, file: file, line: line)
    //=------------------------------------------=
    // some BinaryInteger
    //=------------------------------------------=
    NBKAssertInitOrBitCastAsBinaryInteger(source, exactly: exactly, clamping: clamping, truncating: truncating, file: file, line: line)
}

private func NBKAssertInitOrBitCastAsBinaryInteger<I: BinaryInteger, O: BinaryInteger>(
_ source: I, exactly: O?, clamping: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  let exactly {
        XCTAssertEqual(NBK.initOrBitCast(source), exactly, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(NBK.initOrBitCast(exactly:    source), exactly,    file: file, line: line)
    XCTAssertEqual(NBK.initOrBitCast(clamping:   source), clamping,   file: file, line: line)
    XCTAssertEqual(NBK.initOrBitCast(truncating: source), truncating, file: file, line: line)
}

#endif
