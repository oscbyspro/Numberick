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

private typealias X = [UInt64]
private typealias Y = [UInt64]

//*============================================================================*
// MARK: * NBK x Double Width x Strides x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnStridesAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdvancedBy() {
        XCTAssertEqual(T.min.advanced(by:  Int.max), T.min + T(Int.max))
        XCTAssertEqual(T(  ).advanced(by:  Int.max), T(  ) + T(Int.max))
        XCTAssertEqual(T(  ).advanced(by: -Int.max), T(  ) - T(Int.max))
        XCTAssertEqual(T.max.advanced(by: -Int.max), T.max - T(Int.max))
        XCTAssertEqual(T(  ).advanced(by:  Int.min), T(  ) - T(Int.max) - T(1))
        XCTAssertEqual(T.max.advanced(by:  Int.min), T.max - T(Int.max) - T(1))
    }
    
    func testDistanceTo() {
        XCTAssertEqual(T.min.distance(to:  T.min.advanced(by:  Int.max)),  Int.max)
        XCTAssertEqual(T(  ).distance(to:  T(  ).advanced(by:  Int.max)),  Int.max)
        XCTAssertEqual(T(  ).distance(to:  T(  ).advanced(by: -Int.max)), -Int.max)
        XCTAssertEqual(T.max.distance(to:  T.max.advanced(by: -Int.max)), -Int.max)
        XCTAssertEqual(T(  ).distance(to:  T(  ).advanced(by:  Int.min)),  Int.min)
        XCTAssertEqual(T.max.distance(to:  T.max.advanced(by:  Int.min)),  Int.min)
    }
    
    func testDistanceToExpectingCrashBecauseStrideCannotRepresentDistance() {
        //XCTAssertNotNil(T.min.distance(to:  T.min.advanced(by:  Int.max).advanced(by:  1)))
        //XCTAssertNotNil(T(  ).distance(to:  T(  ).advanced(by:  Int.max).advanced(by:  1)))
        //XCTAssertNotNil(T(  ).distance(to:  T(  ).advanced(by:  Int.min).advanced(by: -1)))
        //XCTAssertNotNil(T.max.distance(to:  T.max.advanced(by:  Int.min).advanced(by: -1)))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Strides x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnStridesAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdvancedBy() {
        XCTAssertEqual(T(  ).advanced(by:  Int.max), T(  ) + T(Int.max))
        XCTAssertEqual(T.max.advanced(by: -Int.max), T.max - T(Int.max))
        XCTAssertEqual(T.max.advanced(by:  Int.min), T.max - T(Int.max) - T(1))
    }
    
    func testDistanceTo() {
        XCTAssertEqual(T(  ).distance(to:  T(  ).advanced(by:  Int.max)),  Int.max)
        XCTAssertEqual(T.max.distance(to:  T.max.advanced(by: -Int.max)), -Int.max)
        XCTAssertEqual(T.max.distance(to:  T.max.advanced(by:  Int.min)),  Int.min)
    }
    
    func testDistanceToExpectingCrashBecauseStrideCannotRepresentDistance() {
        //XCTAssertNotNil(T(  ).distance(to:  T(  ).advanced(by:  Int.max).advanced(by:  1)))
        //XCTAssertNotNil(T.max.distance(to:  T.max.advanced(by:  Int.min).advanced(by: -1)))
    }
}

#endif
