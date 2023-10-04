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
// MARK: * NBK x Swift x Floating Point Sign
//*============================================================================*

final class SwiftTestsOnFloatingPointSign: XCTestCase {
    
    typealias T = FloatingPointSign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        XCTAssertEqual(T.plus .ascii, UInt8(ascii: "+"))
        XCTAssertEqual(T.minus.ascii, UInt8(ascii: "-"))
    }
    
    func testBit() {
        XCTAssertEqual(T.plus .bit, false)
        XCTAssertEqual(T.minus.bit, true )
        
        XCTAssertEqual(T(bit: false), T.plus )
        XCTAssertEqual(T(bit: true ), T.minus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testNot() {
        XCTAssertEqual(~T.plus,  T.minus)
        XCTAssertEqual(~T.minus, T.plus )
        
        XCTAssertEqual(T.plus .toggled(), T.minus)
        XCTAssertEqual(T.minus.toggled(), T.plus )
        
        XCTAssertEqual({ var x = T.plus;  x.toggle(); return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x.toggle(); return x }(), T.plus )
    }
    
    func testAnd() {
        XCTAssertEqual(T.plus  & T.plus,  T.plus )
        XCTAssertEqual(T.plus  & T.minus, T.plus )
        XCTAssertEqual(T.minus & T.plus,  T.plus )
        XCTAssertEqual(T.minus & T.minus, T.minus)
        
        XCTAssertEqual({ var x = T.plus;  x &= T.plus;  return x }(), T.plus )
        XCTAssertEqual({ var x = T.plus;  x &= T.minus; return x }(), T.plus )
        XCTAssertEqual({ var x = T.minus; x &= T.plus;  return x }(), T.plus )
        XCTAssertEqual({ var x = T.minus; x &= T.minus; return x }(), T.minus)
    }
    
    func testOr() {
        XCTAssertEqual(T.plus  | T.plus,  T.plus )
        XCTAssertEqual(T.plus  | T.minus, T.minus)
        XCTAssertEqual(T.minus | T.plus,  T.minus)
        XCTAssertEqual(T.minus | T.minus, T.minus)
        
        XCTAssertEqual({ var x = T.plus;  x |= T.plus;  return x }(), T.plus )
        XCTAssertEqual({ var x = T.plus;  x |= T.minus; return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x |= T.plus;  return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x |= T.minus; return x }(), T.minus)
    }
    
    func testXor() {
        XCTAssertEqual(T.plus  ^ T.plus,  T.plus )
        XCTAssertEqual(T.plus  ^ T.minus, T.minus)
        XCTAssertEqual(T.minus ^ T.plus,  T.minus)
        XCTAssertEqual(T.minus ^ T.minus, T.plus )
        
        XCTAssertEqual({ var x = T.plus;  x ^= T.plus;  return x }(), T.plus )
        XCTAssertEqual({ var x = T.plus;  x ^= T.minus; return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x ^= T.plus;  return x }(), T.minus)
        XCTAssertEqual({ var x = T.minus; x ^= T.minus; return x }(), T.plus )
    }
}

#endif
