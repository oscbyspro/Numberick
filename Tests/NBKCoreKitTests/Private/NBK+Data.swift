//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Data
//*============================================================================*

final class NBKTestsOnData: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWithUnsafeTemporaryAllocationWithCount() {
        for count in 0 ... 1_000 {
            NBK.withUnsafeTemporaryAllocation(of: UInt.self, count: count) {
                XCTAssertEqual ($0.count,count)
                XCTAssertNotNil($0.baseAddress)
            }
        }
    }
    
    func testUnwrappingUnsafeBufferPointer() {
        NBK.withUnsafeTemporaryAllocation(of: UInt8.self, count: 1) {
            XCTAssertNil   (NBK.unwrapping(UnsafeBufferPointer<UInt8>(start:      nil, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeBufferPointer(start: $0.baseAddress!, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeBufferPointer(start: $0.baseAddress!, count: 1)))
        }
    }
    
    func testUnwrappingUnsafeMutableBufferPointer() {
        NBK.withUnsafeTemporaryAllocation(of: UInt8.self, count: 1) {
            XCTAssertNil(   NBK.unwrapping(UnsafeMutableBufferPointer<UInt8>(start:      nil, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeMutableBufferPointer(start: $0.baseAddress!, count: 0)))
            XCTAssertNotNil(NBK.unwrapping(UnsafeMutableBufferPointer(start: $0.baseAddress!, count: 1)))
        }
    }
}
