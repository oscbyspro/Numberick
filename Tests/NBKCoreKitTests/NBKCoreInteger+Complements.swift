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

//*============================================================================*
// MARK: * NBK x Core Integer x Complements x Assertions
//*============================================================================*

private func NBKAssertBitPattern<T: NBKCoreInteger>(
_ integer: T, _ bitPattern: T.BitPattern,
file: StaticString = #file, line: UInt = #line) where T.BitPattern: Equatable {
    typealias B = T.BitPattern
    //=------------------------------------------=
    XCTAssertEqual(integer   .bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(integer, T(bitPattern:  bitPattern), file: file, line: line)
    XCTAssertEqual(bitPattern.bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(B(bitPattern: integer), bitPattern,  file: file, line: line)
}

private func NBKAssertOnesComplement<T: NBKCoreInteger>(
_ integer: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.onesComplement(),                               result, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(false).partialValue,  result, file: file, line: line)
    
    XCTAssertEqual({ var x = integer; let _ = x.formOnesComplement();                  return x }(), result, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(false);  return x }(), result, file: file, line: line)
}

private func NBKAssertTwosComplement<T: NBKCoreInteger>(
_ integer: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.twosComplement(),                               partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementReportingOverflow().partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementReportingOverflow().overflow,     overflow,     file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(true  ).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(true  ).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = integer;         x.formTwosComplement();                  return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementReportingOverflow(); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let o = x.formTwosComplementReportingOverflow(); return o }(), overflow,     file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(true  ); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let o = x.formTwosComplementSubsequence(true  ); return o }(), overflow,     file: file, line: line)
}

private func NBKAssertAdditiveInverse<T: NBKCoreInteger & NBKSignedInteger>(
_ operand: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(-operand,                                    partialValue, file: file, line: line)
        XCTAssertEqual((operand).negated(),                         partialValue, file: file, line: line)
        XCTAssertEqual({ var x = operand; x.negate(); return x }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(operand.negatedReportingOverflow().partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(operand.negatedReportingOverflow().overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = operand; let _ = x.negateReportingOverflow(); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = operand; let o = x.negateReportingOverflow(); return o }(), overflow,     file: file, line: line)
}
