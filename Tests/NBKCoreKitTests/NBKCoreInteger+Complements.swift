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
// MARK: * NBK x Core Integer x Complements
//*============================================================================*

final class NBKCoreIntegerTestsOnComplements: XCTestCase {
    
    typealias T = any (NBKCoreInteger).Type
    typealias S = any (NBKCoreInteger & NBKSignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            NBKAssertBitPattern(T( 0),  (M.min))
            NBKAssertBitPattern(T(-1),  (M.max))
            
            NBKAssertBitPattern(T.min,  (M(1) << (M.bitWidth - 1)))
            NBKAssertBitPattern(T.max, ~(M(1) << (M.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            NBKAssertBitPattern(T.min,  (M.min))
            NBKAssertBitPattern(T.max,  (M.max))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testFromBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(M(bitPattern: T( 0)), M.min)
            XCTAssertEqual(M(bitPattern: T(-1)), M.max)
            
            XCTAssertEqual(T(bitPattern: M.min), T( 0))
            XCTAssertEqual(T(bitPattern: M.max), T(-1))
            
            XCTAssertEqual(T(bitPattern:  (M(1) << (T.bitWidth - 1))), T.min)
            XCTAssertEqual(T(bitPattern: ~(M(1) << (T.bitWidth - 1))), T.max)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: M.min), T.min)
            XCTAssertEqual(T(bitPattern: M.max), T.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(-1).magnitude, M(1))
            XCTAssertEqual(T( 0).magnitude, M(0))
            XCTAssertEqual(T( 1).magnitude, M(1))
            
            XCTAssertEqual(T.min.magnitude,  (M(1) << (M.bitWidth - 1)))
            XCTAssertEqual(T.max.magnitude, ~(M(1) << (M.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T( 0).magnitude, M( 0))
            XCTAssertEqual(T( 1).magnitude, M( 1))
            
            XCTAssertEqual(T.min.magnitude, M.min)
            XCTAssertEqual(T.max.magnitude, M.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOnesComplement() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertOnesComplement(T(-1), T( 0))
            NBKAssertOnesComplement(T(-0), T(-1))
            NBKAssertOnesComplement(T( 0), T(-1))
            NBKAssertOnesComplement(T( 1), T(-2))
            
            NBKAssertOnesComplement(T.min, T.max)
            NBKAssertOnesComplement(T.max, T.min)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertOnesComplement(T( 0), T.max - 0)
            NBKAssertOnesComplement(T( 1), T.max - 1)
            NBKAssertOnesComplement(T( 2), T.max - 2)
            NBKAssertOnesComplement(T( 3), T.max - 3)
            
            NBKAssertOnesComplement(T.min, T.max - 0)
            NBKAssertOnesComplement(T.max, T.min - 0)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertTwosComplement(T(-1), T( 1))
            NBKAssertTwosComplement(T( 0), T( 0))
            NBKAssertTwosComplement(T( 1), T(-1))
            
            NBKAssertTwosComplement(T.min, T.min,  true)
            NBKAssertTwosComplement(T.max, T.min + 1)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertTwosComplement(T( 1), T.max - 0)
            NBKAssertTwosComplement(T( 2), T.max - 1)
            NBKAssertTwosComplement(T( 3), T.max - 2)
            
            NBKAssertTwosComplement(T.min, T.min,  true)
            NBKAssertTwosComplement(T.max, T.min + 1)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Additive Inverse
    //=------------------------------------------------------------------------=
    
    func testAdditiveInverse() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger & NBKSignedInteger {
            NBKAssertAdditiveInverse( T(1), -T(1))
            NBKAssertAdditiveInverse( T( ),  T( ))
            NBKAssertAdditiveInverse(-T(1),  T(1))
        }
        
        for case let type as S in types {
            whereIsSigned(type)
        }
    }
    
    func testAdditiveInverseReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger & NBKSignedInteger {
            NBKAssertAdditiveInverse(T.max - T( ), T.min + T(1))
            NBKAssertAdditiveInverse(T.max - T(1), T.min + T(2))
            NBKAssertAdditiveInverse(T.min + T(1), T.max - T( ))
            NBKAssertAdditiveInverse(T.min + T( ), T.min,  true)
        }
        
        for case let type as S in types {
            whereIsSigned(type)
        }
    }
}

#endif
