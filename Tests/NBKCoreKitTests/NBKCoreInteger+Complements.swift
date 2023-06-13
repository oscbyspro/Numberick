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
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testToBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T( 0).bitPattern, M.min)
            XCTAssertEqual(T(-1).bitPattern, M.max)
            
            XCTAssertEqual(T.min.bitPattern,  (M(1) << (T.bitWidth - 1)))
            XCTAssertEqual(T.max.bitPattern, ~(M(1) << (T.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T.min.bitPattern, M.min)
            XCTAssertEqual(T.max.bitPattern, M.max)
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
}

#endif
