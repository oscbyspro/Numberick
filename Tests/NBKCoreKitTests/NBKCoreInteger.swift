//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer
//*============================================================================*

final class NBKCoreIntegerTests: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let signed:   [T] = [ Int.self,  Int8.self,  Int16.self,  Int32.self,  Int64.self]
    static let unsigned: [T] = [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self]
    static let types:    [T] = signed + unsigned
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNBKBinaryInteger() {
        XCTAssertEqual(10, types.compactMap({ $0 as  any NBKBinaryInteger.Type }).count)
    }
    
    func testNBKBitPatternConvertible() {
        XCTAssertEqual(10, types.compactMap({ $0 as  any NBKBitPatternConvertible.Type }).count)
    }
    
    func testNBKCoreInteger() {
        XCTAssertEqual(10, types.compactMap({ $0 as  any NBKCoreInteger.Type }).count)
    }
    
    func testNBKFixedWidthInteger() {
        XCTAssertEqual(10, types.compactMap({ $0 as  any NBKFixedWidthInteger.Type }).count)
    }
    
    func testNBKSignedInteger() {
        XCTAssertEqual(05, types.compactMap({ $0 as? any NBKSignedInteger.Type }).count)
    }
    
    func testNBKUnsignedInteger() {
        XCTAssertEqual(05, types.compactMap({ $0 as? any NBKUnsignedInteger.Type }).count)
    }
}

#endif
