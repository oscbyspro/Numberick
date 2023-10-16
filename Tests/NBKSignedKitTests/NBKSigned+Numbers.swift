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
import NBKSignedKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Numbers
//*============================================================================*

final class NBKSignedTestsOnNumbers: XCTestCase {
    
    typealias T = NBKSigned<UInt>
    typealias M = NBKSigned<UInt>.Magnitude
    typealias D = NBKSigned<UInt>.Digit
    typealias S = Int
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testZero() {
        NBKAssertIdentical(T(   ), T(sign: .plus,  magnitude: M(  )))
        NBKAssertIdentical(T.zero, T(sign: .plus,  magnitude: M(  )))
    }
    
    func testEdges() {
        NBKAssertIdentical(T.max,  T(sign: .plus,  magnitude: M.max))
        NBKAssertIdentical(T.min,  T(sign: .minus, magnitude: M.max))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testFromDigit() {
        NBKAssertIdentical(T(digit:  D(4)),  T(4))
        NBKAssertIdentical(T(digit: -D(4)), -T(4))
        NBKAssertIdentical(D(digit:  D(4)),  D(4))
        NBKAssertIdentical(D(digit: -D(4)), -D(4))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signitude
    //=------------------------------------------------------------------------=
    
    func testsToSignitude() {
        XCTAssertEqual(S(          T(sign: .plus , magnitude: M( 1))), S( 1))
        XCTAssertEqual(S(exactly:  T(sign: .plus , magnitude: M( 1))), S( 1))
        XCTAssertEqual(S(clamping: T(sign: .plus , magnitude: M( 1))), S( 1))
        
        XCTAssertEqual(S(          T(sign: .minus, magnitude: M( 1))), S(-1))
        XCTAssertEqual(S(exactly:  T(sign: .minus, magnitude: M( 1))), S(-1))
        XCTAssertEqual(S(clamping: T(sign: .minus, magnitude: M( 1))), S(-1))
        
        XCTAssertEqual(S(exactly:  T(sign: .plus , magnitude: M.max)),   nil)
        XCTAssertEqual(S(clamping: T(sign: .plus , magnitude: M.max)), S.max)
        
        XCTAssertEqual(S(exactly:  T(sign: .minus, magnitude: M.max)),   nil)
        XCTAssertEqual(S(clamping: T(sign: .minus, magnitude: M.max)), S.min)
        
        XCTAssertEqual(S(          T(sign: .plus , magnitude: S.max.magnitude)), S.max)
        XCTAssertEqual(S(exactly:  T(sign: .plus , magnitude: S.max.magnitude)), S.max)
        XCTAssertEqual(S(clamping: T(sign: .plus , magnitude: S.max.magnitude)), S.max)
        
        XCTAssertEqual(S(          T(sign: .minus, magnitude: S.min.magnitude)), S.min)
        XCTAssertEqual(S(exactly:  T(sign: .minus, magnitude: S.min.magnitude)), S.min)
        XCTAssertEqual(S(clamping: T(sign: .minus, magnitude: S.min.magnitude)), S.min)
    }

    func testToSignitudeAsPlusMinusZero() {
        XCTAssertEqual(S(          T(sign: .plus , magnitude: M(  ))), S(  ))
        XCTAssertEqual(S(exactly:  T(sign: .plus , magnitude: M(  ))), S(  ))
        XCTAssertEqual(S(clamping: T(sign: .plus , magnitude: M(  ))), S(  ))
        
        XCTAssertEqual(S(          T(sign: .minus, magnitude: M(  ))), S(  ))
        XCTAssertEqual(S(exactly:  T(sign: .minus, magnitude: M(  ))), S(  ))
        XCTAssertEqual(S(clamping: T(sign: .minus, magnitude: M(  ))), S(  ))
    }
    
    func testFromSignitude() {
        NBKAssertIdentical(T(          S( 1)),  T(1))
        NBKAssertIdentical(T(exactly:  S( 1)),  T(1))
        NBKAssertIdentical(T(clamping: S( 1)),  T(1))

        NBKAssertIdentical(T(          S(  )),  T( ))
        NBKAssertIdentical(T(exactly:  S(  )),  T( ))
        NBKAssertIdentical(T(clamping: S(  )),  T( ))
        
        NBKAssertIdentical(T(          S(-1)), -T(1))
        NBKAssertIdentical(T(exactly:  S(-1)), -T(1))
        NBKAssertIdentical(T(clamping: S(-1)), -T(1))
        
        NBKAssertIdentical(T(          S.max),  T(sign: .plus,  magnitude: M(S.max) + 0))
        NBKAssertIdentical(T(exactly:  S.max),  T(sign: .plus,  magnitude: M(S.max) + 0))
        NBKAssertIdentical(T(clamping: S.max),  T(sign: .plus,  magnitude: M(S.max) + 0))
        
        NBKAssertIdentical(T(          S.min),  T(sign: .minus, magnitude: M(S.max) + 1))
        NBKAssertIdentical(T(exactly:  S.min),  T(sign: .minus, magnitude: M(S.max) + 1))
        NBKAssertIdentical(T(clamping: S.min),  T(sign: .minus, magnitude: M(S.max) + 1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testsToMagnitude() {
        XCTAssertEqual(M(          T(sign: .plus , magnitude: M( 1))), M( 1))
        XCTAssertEqual(M(exactly:  T(sign: .plus , magnitude: M( 1))), M( 1))
        XCTAssertEqual(M(clamping: T(sign: .plus , magnitude: M( 1))), M( 1))
        
        XCTAssertEqual(M(exactly:  T(sign: .minus, magnitude: M( 1))),   nil)
        XCTAssertEqual(M(clamping: T(sign: .minus, magnitude: M( 1))), M.min)
        
        XCTAssertEqual(M(          T(sign: .plus , magnitude: M.max)), M.max)
        XCTAssertEqual(M(exactly:  T(sign: .plus , magnitude: M.max)), M.max)
        XCTAssertEqual(M(clamping: T(sign: .plus , magnitude: M.max)), M.max)

        XCTAssertEqual(M(exactly:  T(sign: .minus, magnitude: M.max)),   nil)
        XCTAssertEqual(M(clamping: T(sign: .minus, magnitude: M.max)), M.min)
        
        XCTAssertEqual(M(          T(sign: .plus , magnitude: M.max.magnitude)), M.max)
        XCTAssertEqual(M(exactly:  T(sign: .plus , magnitude: M.max.magnitude)), M.max)
        XCTAssertEqual(M(clamping: T(sign: .plus , magnitude: M.max.magnitude)), M.max)
        
        XCTAssertEqual(M(          T(sign: .minus, magnitude: M.min.magnitude)), M.min)
        XCTAssertEqual(M(exactly:  T(sign: .minus, magnitude: M.min.magnitude)), M.min)
        XCTAssertEqual(M(clamping: T(sign: .minus, magnitude: M.min.magnitude)), M.min)
    }

    func testToMagnitudeAsPlusMinusZero() {
        XCTAssertEqual(M(          T(sign: .plus , magnitude: M(  ))), M(  ))
        XCTAssertEqual(M(exactly:  T(sign: .plus , magnitude: M(  ))), M(  ))
        XCTAssertEqual(M(clamping: T(sign: .plus , magnitude: M(  ))), M(  ))
        
        XCTAssertEqual(M(          T(sign: .minus, magnitude: M(  ))), M(  ))
        XCTAssertEqual(M(exactly:  T(sign: .minus, magnitude: M(  ))), M(  ))
        XCTAssertEqual(M(clamping: T(sign: .minus, magnitude: M(  ))), M(  ))
    }
    
    func testFromMagnitude() {
        NBKAssertIdentical(T(          M(  )), T(  ))
        NBKAssertIdentical(T(exactly:  M(  )), T(  ))
        NBKAssertIdentical(T(clamping: M(  )), T(  ))
        
        NBKAssertIdentical(T(          M( 1)), T( 1))
        NBKAssertIdentical(T(exactly:  M( 1)), T( 1))
        NBKAssertIdentical(T(clamping: M( 1)), T( 1))
        
        NBKAssertIdentical(T(          M.max), T.max)
        NBKAssertIdentical(T(exactly:  M.max), T.max)
        NBKAssertIdentical(T(clamping: M.max), T.max)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Numbers x Open Source Issues
//*============================================================================*

final class NBKSignedTestsOnNumbersOpenSourceIssues: XCTestCase {
    
    typealias SIntXL = NBKSigned<UIntXL>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/apple/swift-numerics/pull/254
    ///
    /// - Note: Said to crash and return incorrect values.
    ///
    func testSwiftNumericsPull254() {
        XCTAssertEqual(UInt64(          SIntXL(UInt64.max)), UInt64(UInt64.max))
        XCTAssertEqual(SIntXL(          UInt64(UInt64.max)), SIntXL(UInt64.max))
        
        XCTAssertEqual(UInt64(exactly:  SIntXL(UInt64.max)), UInt64(UInt64.max))
        XCTAssertEqual(SIntXL(exactly:  UInt64(UInt64.max)), SIntXL(UInt64.max))
        
        XCTAssertEqual(UInt64(clamping: SIntXL(UInt64.max)), UInt64(UInt64.max))
        XCTAssertEqual(SIntXL(clamping: UInt64(UInt64.max)), SIntXL(UInt64.max))
    }
}

#endif
