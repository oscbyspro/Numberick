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
// MARK: * NBK x Core Integer x Numbers
//*============================================================================*

final class NBKCoreIntegerTestsOnNumbers: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testFromDigit() {
        func whereIs<T: NBKCoreInteger>(_ type: T.Type) {
            XCTAssertEqual(T(digit: T.min ), T.min )
            XCTAssertEqual(T(digit: T.max ), T.max )
            XCTAssertEqual(T(digit: T.zero), T.zero)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    func testsFromSignMagnitude() {
        func whereIsSigned<T: NBKCoreInteger>(_ type: T.Type) {
            XCTAssertEqual(T(sign: false, magnitude:   T.Magnitude.zero), T.zero)
            XCTAssertEqual(T(sign: true,  magnitude:   T.Magnitude.zero), T.zero)
            
            XCTAssertEqual(T(sign: false, magnitude:  (T.Magnitude.max >> 1) + 0), T.max)
            XCTAssertEqual(T(sign: true,  magnitude: ~(T.Magnitude.max >> 1) - 0), T.min)
            
            XCTAssertEqual(T(sign: false, magnitude:  (T.Magnitude.max >> 1) + 1),   nil)
            XCTAssertEqual(T(sign: true,  magnitude: ~(T.Magnitude.max >> 1) + 1),   nil)
        }
        
        func whereIsUnsigned<T: NBKCoreInteger>(_ type: T.Type) {
            XCTAssertEqual(T(sign: false, magnitude: T.Magnitude.zero), T.zero)
            XCTAssertEqual(T(sign: true,  magnitude: T.Magnitude.zero), T.zero)
            
            XCTAssertEqual(T(sign: false, magnitude: T.Magnitude( 1)),  T( 1))
            XCTAssertEqual(T(sign: true,  magnitude: T.Magnitude( 1)),    nil)
            
            XCTAssertEqual(T(sign: false, magnitude: T.Magnitude.max),  T.max)
            XCTAssertEqual(T(sign: true,  magnitude: T.Magnitude.max),    nil)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
