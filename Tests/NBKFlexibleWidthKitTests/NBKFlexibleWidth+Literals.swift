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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Literals x IntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnLiteralsAsIntXL: XCTestCase {

    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        #if SBI && swift(>=5.8)
        XCTAssertEqual(T(x64:[ 0,  0,  0,  0] as X),  0x0000000000000000000000000000000000000000000000000000000000000000)
        XCTAssertEqual(T(x64:[~0,  0,  0,  0] as X),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0,  0,  0] as X),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0, ~0,  0] as X),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0, ~0, ~0] as X), -0x0000000000000000000000000000000000000000000000000000000000000001)
        XCTAssertEqual(T(x64:[ 0, ~0, ~0, ~0] as X), -0x0000000000000000000000000000000000000000000000010000000000000000)
        XCTAssertEqual(T(x64:[ 0,  0, ~0, ~0] as X), -0x0000000000000000000000000000000100000000000000000000000000000000)
        XCTAssertEqual(T(x64:[ 0,  0,  0, ~0] as X), -0x0000000000000001000000000000000000000000000000000000000000000000)
        #else
        XCTAssertEqual(T(integerLiteral: Int.max),  T(x64: [UInt64(Int.max), 0, 0, 0] as X))
        XCTAssertEqual(T(integerLiteral: Int.min), ~T(x64: [UInt64(Int.max), 0, 0, 0] as X))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64:[ 0,  0,  0,  0] as X),  "0x0000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64:[~0,  0,  0,  0] as X),  "0x000000000000000000000000000000000000000000000000ffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0,  0,  0] as X),  "0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0, ~0,  0] as X),  "0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0, ~0, ~0] as X), "-0x0000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertEqual(T(x64:[ 0, ~0, ~0, ~0] as X), "-0x0000000000000000000000000000000000000000000000010000000000000000")
        XCTAssertEqual(T(x64:[ 0,  0, ~0, ~0] as X), "-0x0000000000000000000000000000000100000000000000000000000000000000")
        XCTAssertEqual(T(x64:[ 0,  0,  0, ~0] as X), "-0x0000000000000001000000000000000000000000000000000000000000000000")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Literals x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnLiteralsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        #if SBI && swift(>=5.8)
        XCTAssertEqual(T(x64:[ 0,  0,  0,  0] as X),  0x0000000000000000000000000000000000000000000000000000000000000000)
        XCTAssertEqual(T(x64:[~0,  0,  0,  0] as X),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0,  0,  0] as X),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0, ~0,  0] as X),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64:[~0, ~0, ~0, ~0] as X),  0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64:[ 0, ~0, ~0, ~0] as X),  0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000)
        XCTAssertEqual(T(x64:[ 0,  0, ~0, ~0] as X),  0xffffffffffffffffffffffffffffffff00000000000000000000000000000000)
        XCTAssertEqual(T(x64:[ 0,  0,  0, ~0] as X),  0xffffffffffffffff000000000000000000000000000000000000000000000000)
        
        XCTAssertNil(T(exactlyIntegerLiteral:  -1))
        #else
        XCTAssertEqual(T(integerLiteral: UInt.max), T(x64: [UInt64(UInt.max), 0, 0, 0] as X))
        XCTAssertEqual(T(integerLiteral: UInt.min), T(x64: [UInt64(UInt.min), 0, 0, 0] as X))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64:[ 0,  0,  0,  0] as X),  "0x0000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64:[~0,  0,  0,  0] as X),  "0x000000000000000000000000000000000000000000000000ffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0,  0,  0] as X),  "0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0, ~0,  0] as X),  "0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[~0, ~0, ~0, ~0] as X),  "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[ 0, ~0, ~0, ~0] as X),  "0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000")
        XCTAssertEqual(T(x64:[ 0,  0, ~0, ~0] as X),  "0xffffffffffffffffffffffffffffffff00000000000000000000000000000000")
        XCTAssertEqual(T(x64:[ 0,  0,  0, ~0] as X),  "0xffffffffffffffff000000000000000000000000000000000000000000000000")
        
        XCTAssertNil(T(exactlyStringLiteral: "-1"))
    }
}

#endif
