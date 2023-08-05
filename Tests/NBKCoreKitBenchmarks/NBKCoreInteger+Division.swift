//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Division x Int
//*============================================================================*

final class NBKCoreIntegerBenchmarksOnDivisionAsInt: XCTestCase {
    
    typealias T =  Int
    typealias M = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testQuotientAndRemainder() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testQuotientReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testRemainderReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.remainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var lhs = NBK.blackHoleIdentity((T.max))
        var rhs = NBK.blackHoleIdentity((T.max / 2, M(bitPattern: T.max)))
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividingFullWidth(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testDividingFullWidthReportingOverflow() {
        var lhs = NBK.blackHoleIdentity((T.max))
        var rhs = NBK.blackHoleIdentity((T.max / 2, M(bitPattern: T.max)))
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividingFullWidthReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Division x UInt
//*============================================================================*

final class NBKCoreIntegerBenchmarksOnDivisionAsUInt: XCTestCase {
    
    typealias T = UInt
    typealias M = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testQuotientAndRemainder() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testQuotientReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testRemainderReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(~T(123))
        var rhs = NBK.blackHoleIdentity( T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.remainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var lhs = NBK.blackHoleIdentity((T.max))
        var rhs = NBK.blackHoleIdentity((T.max - 1, M.max))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividingFullWidth(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testDividingFullWidthReportingOverflow() {
        var lhs = NBK.blackHoleIdentity((T.max))
        var rhs = NBK.blackHoleIdentity((T.max - 1, M.max))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.dividingFullWidthReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
