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
// MARK: * NBK x Modulo
//*============================================================================*

final class NBKTestsOnModulo: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testModuloPowerOf2AsInt8() {
        XCTAssertEqual(NBK.residue(of:  Int8.min, modulo: UInt(8)), UInt(0))
        XCTAssertEqual(NBK.residue(of:  Int8.max, modulo: UInt(8)), UInt(7))
        
        XCTAssertEqual(NBK.residue(of:  Int8(-4), modulo: UInt(4)), UInt(0))
        XCTAssertEqual(NBK.residue(of:  Int8(-3), modulo: UInt(4)), UInt(1))
        XCTAssertEqual(NBK.residue(of:  Int8(-2), modulo: UInt(4)), UInt(2))
        XCTAssertEqual(NBK.residue(of:  Int8(-1), modulo: UInt(4)), UInt(3))
        XCTAssertEqual(NBK.residue(of:  Int8( 0), modulo: UInt(4)), UInt(0))
        XCTAssertEqual(NBK.residue(of:  Int8( 1), modulo: UInt(4)), UInt(1))
        XCTAssertEqual(NBK.residue(of:  Int8( 2), modulo: UInt(4)), UInt(2))
        XCTAssertEqual(NBK.residue(of:  Int8( 3), modulo: UInt(4)), UInt(3))
        XCTAssertEqual(NBK.residue(of:  Int8( 4), modulo: UInt(4)), UInt(0))
    }
    
    func testModuloPowerOf2AsUInt8() {
        XCTAssertEqual(NBK.residue(of: UInt8.min, modulo: UInt(8)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8.max, modulo: UInt(8)), UInt(7))
        
        XCTAssertEqual(NBK.residue(of: UInt8( 0), modulo: UInt(4)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8( 1), modulo: UInt(4)), UInt(1))
        XCTAssertEqual(NBK.residue(of: UInt8( 2), modulo: UInt(4)), UInt(2))
        XCTAssertEqual(NBK.residue(of: UInt8( 3), modulo: UInt(4)), UInt(3))
        XCTAssertEqual(NBK.residue(of: UInt8( 4), modulo: UInt(4)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8( 5), modulo: UInt(4)), UInt(1))
        XCTAssertEqual(NBK.residue(of: UInt8( 6), modulo: UInt(4)), UInt(2))
        XCTAssertEqual(NBK.residue(of: UInt8( 7), modulo: UInt(4)), UInt(3))
        XCTAssertEqual(NBK.residue(of: UInt8( 8), modulo: UInt(4)), UInt(0))
    }
    
    func testModuloNonPowerOf2Int8() {
        XCTAssertEqual(NBK.residue(of:  Int8.min, modulo: UInt(7)), UInt(5))
        XCTAssertEqual(NBK.residue(of:  Int8.max, modulo: UInt(7)), UInt(1))
        
        XCTAssertEqual(NBK.residue(of:  Int8(-3), modulo: UInt(3)), UInt(0))
        XCTAssertEqual(NBK.residue(of:  Int8(-2), modulo: UInt(3)), UInt(1))
        XCTAssertEqual(NBK.residue(of:  Int8(-1), modulo: UInt(3)), UInt(2))
        XCTAssertEqual(NBK.residue(of:  Int8( 0), modulo: UInt(3)), UInt(0))
        XCTAssertEqual(NBK.residue(of:  Int8( 1), modulo: UInt(3)), UInt(1))
        XCTAssertEqual(NBK.residue(of:  Int8( 2), modulo: UInt(3)), UInt(2))
        XCTAssertEqual(NBK.residue(of:  Int8( 3), modulo: UInt(3)), UInt(0))
    }
    
    func testModuloNonPowerOf2AsUInt8() {
        XCTAssertEqual(NBK.residue(of: UInt8.min, modulo: UInt(7)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8.max, modulo: UInt(7)), UInt(3))
        
        XCTAssertEqual(NBK.residue(of: UInt8( 0), modulo: UInt(3)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8( 1), modulo: UInt(3)), UInt(1))
        XCTAssertEqual(NBK.residue(of: UInt8( 2), modulo: UInt(3)), UInt(2))
        XCTAssertEqual(NBK.residue(of: UInt8( 3), modulo: UInt(3)), UInt(0))
        XCTAssertEqual(NBK.residue(of: UInt8( 4), modulo: UInt(3)), UInt(1))
        XCTAssertEqual(NBK.residue(of: UInt8( 5), modulo: UInt(3)), UInt(2))
        XCTAssertEqual(NBK.residue(of: UInt8( 6), modulo: UInt(3)), UInt(0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Modulo Bit Width Of
    //=------------------------------------------------------------------------=
    
    func testModuloBitWidthOf() {
        NBKAssertModuloBitWidthOf(Int8.max,  Int8 .self, 07)
        NBKAssertModuloBitWidthOf(Int8.max,  Int16.self, 15)
        NBKAssertModuloBitWidthOf(Int8.max,  Int32.self, 31)
        NBKAssertModuloBitWidthOf(Int8.max,  Int64.self, 63)
        
        NBKAssertModuloBitWidthOf(Int8( 21), Int8 .self, 05)
        NBKAssertModuloBitWidthOf(Int8( 21), Int16.self, 05)
        NBKAssertModuloBitWidthOf(Int8( 21), Int32.self, 21)
        NBKAssertModuloBitWidthOf(Int8( 21), Int64.self, 21)
        
        NBKAssertModuloBitWidthOf(Int8(-21), Int8 .self, 03)
        NBKAssertModuloBitWidthOf(Int8(-21), Int16.self, 11)
        NBKAssertModuloBitWidthOf(Int8(-21), Int32.self, 11)
        NBKAssertModuloBitWidthOf(Int8(-21), Int64.self, 43)
    }
}

//*============================================================================*
// MARK: * NBK x Modulo x Assertions
//*============================================================================*

private func NBKAssertModuloBitWidthOf(
_ value: some BinaryInteger, _ source: (some NBKFixedWidthInteger).Type, _ result: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(NBK.residue(of: value, moduloBitWidthOf: source),                result, file: file, line: line)
    XCTAssertEqual(NBK.residue(of: value, moduloBitWidthOf: source.Magnitude.self), result, file: file, line: line)
}

#endif
