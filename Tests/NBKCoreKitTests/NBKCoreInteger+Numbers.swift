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
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T.zero, 000)
            
            for x in Int8.min ... Int8.max {
                let x = T(truncatingIfNeeded: x)
                
                XCTAssertEqual(x + T.zero, x)
                XCTAssertEqual(T.zero + x, x)
                
                XCTAssertEqual(x - x, T.zero)
                XCTAssertEqual(x - T.zero, x)
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testOne() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T.one, 0001)
            
            for x in Int8.min ... Int8.max {
                let x = T(truncatingIfNeeded: x)
                
                XCTAssertEqual(x * T.one, x)
                XCTAssertEqual(T.one * x, x)
                
                XCTAssertEqual(x / T.one, x)
                XCTAssertEqual(x % T.one, T.zero)
                
                if !x.isZero {
                    XCTAssertEqual(x / x, T.one )
                    XCTAssertEqual(x % x, T.zero)
                }
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testMin() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual( T.min, T.one << (T.bitWidth - 1))
            XCTAssertEqual(~T.max, T.one << (T.bitWidth - 1))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual( T.min, T(repeating: false))
            XCTAssertEqual(~T.max, T(repeating: false))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testMax() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual( T.max, ~(T.one << (T.bitWidth - 1)))
            XCTAssertEqual(~T.min, ~(T.one << (T.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual( T.max, T(repeating: true))
            XCTAssertEqual(~T.min, T(repeating: true))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Integers
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
    
    func testsFromMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(magnitude: T(  ).magnitude + 0), T(  ))
            XCTAssertEqual(T(magnitude: T(  ).magnitude + 1), T( 1))
            XCTAssertEqual(T(magnitude: T.max.magnitude + 0), T.max)
            XCTAssertEqual(T(magnitude: T.max.magnitude + 1),   nil)
            XCTAssertEqual(T(magnitude: T.min.magnitude - 1), T.max)
            XCTAssertEqual(T(magnitude: T.min.magnitude + 0),   nil)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(magnitude: T.min.magnitude + 0), T.min + 0)
            XCTAssertEqual(T(magnitude: T.min.magnitude + 1), T.min + 1)
            XCTAssertEqual(T(magnitude: T.max.magnitude - 1), T.max - 1)
            XCTAssertEqual(T(magnitude: T.max.magnitude - 0), T.max - 0)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testsFromSignAndMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
            XCTAssertEqual(T(sign: .minus, magnitude: M( 1)), T(-1))
            XCTAssertEqual(T(sign: .plus,  magnitude: M.max),   nil)
            XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
            XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude + 0), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude + 0), T.min)
            XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude + 1),   nil)
            XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude + 1),   nil)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(sign: .plus,  magnitude: M( 1)), T( 1))
            XCTAssertEqual(T(sign: .minus, magnitude: M( 1)),   nil)
            XCTAssertEqual(T(sign: .plus,  magnitude: M.max), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: M.max),   nil)
            XCTAssertEqual(T(sign: .plus,  magnitude: T.max.magnitude + 0), T.max)
            XCTAssertEqual(T(sign: .minus, magnitude: T.min.magnitude + 0), T.min)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
