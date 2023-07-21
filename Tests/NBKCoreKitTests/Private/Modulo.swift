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
// MARK: * NBK x Modulo x Binary Integer
//*============================================================================*

final class ModuloTestsOnBinaryInteger: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Modulo
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
}

#endif
