//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG
#if SBI && swift(>=5.8)

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Static Big Int
//*============================================================================*

final class NBKStaticBigIntTests: XCTestCase {
    
    typealias T = NBKStaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testToFromSwiftStaticBigInt() {
        XCTAssertEqual(T(Swift.StaticBigInt(123))[0], 123)
        XCTAssertEqual(Swift.StaticBigInt(T(123))[0], 123)
    }
    
    func testBitWidth() {
        XCTAssertEqual(T( 1).bitWidth, 2)
        XCTAssertEqual(T( 0).bitWidth, 1)
        XCTAssertEqual(T(-1).bitWidth, 1)
        XCTAssertEqual(T(-2).bitWidth, 2)
        
        XCTAssertEqual(T( 2147483648).bitWidth, 33)
        XCTAssertEqual(T( 2147483647).bitWidth, 32)
        XCTAssertEqual(T(-2147483648).bitWidth, 32)
        XCTAssertEqual(T(-2147483649).bitWidth, 33)

        XCTAssertEqual(T( 9223372036854775808).bitWidth, 65)
        XCTAssertEqual(T( 9223372036854775807).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775808).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775809).bitWidth, 65)
    }
    
    func testSignum() {
        XCTAssertEqual(T( 1).signum(),  1)
        XCTAssertEqual(T( 0).signum(),  0)
        XCTAssertEqual(T(-1).signum(), -1)
        XCTAssertEqual(T(-2).signum(), -1)
        
        XCTAssertEqual(T( 2147483648).signum(),  1)
        XCTAssertEqual(T( 2147483647).signum(),  1)
        XCTAssertEqual(T(-2147483648).signum(), -1)
        XCTAssertEqual(T(-2147483649).signum(), -1)

        XCTAssertEqual(T( 9223372036854775808).signum(),  1)
        XCTAssertEqual(T( 9223372036854775807).signum(),  1)
        XCTAssertEqual(T(-9223372036854775808).signum(), -1)
        XCTAssertEqual(T(-9223372036854775809).signum(), -1)
    }
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T( 0)[Int.max],  0 as UInt)
        XCTAssertEqual(T(-1)[Int.max], ~0 as UInt)
    }
}

#endif
#endif
