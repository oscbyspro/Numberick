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
// MARK: * NBK x Allocation
//*============================================================================*

final class NBKTestsOnAllocation: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUnwrappingUnsafeBufferPointer() {
        Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 1) {
            XCTAssertNil(   NBK.unwrapping(UnsafeBufferPointer<UInt8>(start:      nil, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeBufferPointer(start: $0.baseAddress!, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeBufferPointer(start: $0.baseAddress!, count: 1)))
        }
    }
    
    func testUnwrappingUnsafeMutableBufferPointer() {
        Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 1) {
            XCTAssertNil(   NBK.unwrapping(UnsafeMutableBufferPointer<UInt8>(start:      nil, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeMutableBufferPointer(start: $0.baseAddress!, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeMutableBufferPointer(start: $0.baseAddress!, count: 1)))
        }
    }
}

#endif
