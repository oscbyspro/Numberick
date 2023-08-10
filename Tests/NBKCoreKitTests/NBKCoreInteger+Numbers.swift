//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
#else
import Numberick
#endif

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
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
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
    
    func testsFromSignAndMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
            XCTAssertEqual(T(sign: .minus, magnitude: M( 1)), T(-1))
            XCTAssertEqual(T(sign: .plus,  magnitude: M.max),   nil)
            XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
            XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude), T.min)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
            
            XCTAssertEqual(T(sign: .minus, magnitude: M( 1)),   nil)
            XCTAssertEqual(T(sign: .plus,  magnitude: M.max), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
            
            XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude), T.min)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
