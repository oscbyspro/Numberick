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
// MARK: * NBK x Core Integer x Comparisons
//*============================================================================*

final class NBKCoreIntegerTestsOnComparisons: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testComparing() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertComparisons(T( 0), T( 0), Int( 0))
            NBKAssertComparisons(T( 0), T(-0), Int( 0))
            NBKAssertComparisons(T(-0), T( 0), Int( 0))
            NBKAssertComparisons(T(-0), T(-0), Int( 0))
            
            NBKAssertComparisons(T( 1), T( 1), Int( 0))
            NBKAssertComparisons(T( 1), T(-1), Int( 1))
            NBKAssertComparisons(T(-1), T( 1), Int(-1))
            NBKAssertComparisons(T(-1), T(-1), Int( 0))
            
            NBKAssertComparisons(T( 2), T( 3), Int(-1))
            NBKAssertComparisons(T( 2), T(-3), Int( 1))
            NBKAssertComparisons(T(-2), T( 3), Int(-1))
            NBKAssertComparisons(T(-2), T(-3), Int( 1))
            
            NBKAssertComparisons(T( 3), T( 2), Int( 1))
            NBKAssertComparisons(T( 3), T(-2), Int( 1))
            NBKAssertComparisons(T(-3), T( 2), Int(-1))
            NBKAssertComparisons(T(-3), T(-2), Int(-1))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertComparisons(T( 0), T( 0), Int( 0))
            NBKAssertComparisons(T( 1), T( 1), Int( 0))
            NBKAssertComparisons(T( 2), T( 3), Int(-1))
            NBKAssertComparisons(T( 3), T( 2), Int( 1))
        }
                
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(( T(0)).isZero, true )
            XCTAssertEqual(( T(1)).isZero, false)
            XCTAssertEqual(( T(2)).isZero, false)
            
            XCTAssertEqual((~T(0)).isZero, false)
            XCTAssertEqual((~T(1)).isZero, false)
            XCTAssertEqual((~T(2)).isZero, false)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testIsLessThanZero() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(( T(0)).isLessThanZero, false)
            XCTAssertEqual(( T(1)).isLessThanZero, false)
            XCTAssertEqual(( T(2)).isLessThanZero, false)
            
            XCTAssertEqual((~T(0)).isLessThanZero, type.isSigned)
            XCTAssertEqual((~T(1)).isLessThanZero, type.isSigned)
            XCTAssertEqual((~T(2)).isLessThanZero, type.isSigned)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testIsMoreThanZero() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(( T(0)).isMoreThanZero, false)
            XCTAssertEqual(( T(1)).isMoreThanZero, true )
            XCTAssertEqual(( T(2)).isMoreThanZero, true )
            
            XCTAssertEqual((~T(0)).isMoreThanZero, !type.isSigned)
            XCTAssertEqual((~T(1)).isMoreThanZero, !type.isSigned)
            XCTAssertEqual((~T(2)).isMoreThanZero, !type.isSigned)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testIsOdd() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(( T(0)).isOdd, false)
            XCTAssertEqual(( T(1)).isOdd, true )
            XCTAssertEqual(( T(2)).isOdd, false)
            
            XCTAssertEqual((~T(0)).isOdd, true )
            XCTAssertEqual((~T(1)).isOdd, false)
            XCTAssertEqual((~T(2)).isOdd, true )
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testIsEven() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(( T(0)).isEven, true )
            XCTAssertEqual(( T(1)).isEven, false)
            XCTAssertEqual(( T(2)).isEven, true )
            
            XCTAssertEqual((~T(0)).isEven, false)
            XCTAssertEqual((~T(1)).isEven, true )
            XCTAssertEqual((~T(2)).isEven, false)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testIsPowerOf2() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertFalse((T( 3)).isPowerOf2)
            XCTAssertTrue ((T( 2)).isPowerOf2)
            XCTAssertTrue ((T( 1)).isPowerOf2)
            XCTAssertFalse((T( 0)).isPowerOf2)
            XCTAssertFalse((T(-1)).isPowerOf2)
            XCTAssertFalse((T(-2)).isPowerOf2)
            XCTAssertFalse((T(-3)).isPowerOf2)
            XCTAssertFalse((T(-4)).isPowerOf2)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertFalse((T( 0)).isPowerOf2)
            XCTAssertTrue ((T( 1)).isPowerOf2)
            XCTAssertTrue ((T( 2)).isPowerOf2)
            XCTAssertFalse((T( 3)).isPowerOf2)
            XCTAssertTrue ((T( 4)).isPowerOf2)
            XCTAssertFalse((T( 5)).isPowerOf2)
            XCTAssertFalse((T( 6)).isPowerOf2)
            XCTAssertFalse((T( 7)).isPowerOf2)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
