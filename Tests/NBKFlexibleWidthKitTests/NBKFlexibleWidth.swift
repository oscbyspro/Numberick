//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x IntXL
//*============================================================================*

final class NBKFlexibleWidthTestsAsIntXL: XCTestCase {
    
    typealias T =  IntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSign() {
        XCTAssertEqual(T(sign: .plus,  magnitude: 0).sign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 0).sign, .minus)
        XCTAssertEqual(T(sign: .plus,  magnitude: 1).sign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 1).sign, .minus)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Assertions
//*============================================================================*

func NBKAssertIdentical(_ lhs: IntXL?, _ rhs: IntXL?, file: StaticString = #file, line: UInt = #line) {
    func description(of value: IntXL?) -> String {
        value.map({ "\(UnicodeScalar($0.sign.ascii))\($0.magnitude)" }) ?? "nil"
    }
    //=--------------------------------------=
    let success: Bool = lhs?.sign == rhs?.sign && lhs?.magnitude == rhs?.magnitude
    //=--------------------------------------=
    if  success {
        XCTAssertEqual(lhs, rhs, file: file, line: line)
    }
    //=--------------------------------------=
    XCTAssert(success, "\(description(of: lhs)) is not identical to \(description(of: rhs))", file: file, line: line)
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Initializers x IntXL
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    static let min256 = Self(x64:[ 0,  0,  0, ~0/2 + 1] as X)
    static let max256 = Self(x64:[~0, ~0, ~0, ~0/2 + 0] as X)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Limbs
    //=------------------------------------------------------------------------=
    
    init(x32: [UInt32]) {
        self.init(words: NBK.limbs(x32, as: [UInt].self))
    }
    
    init(x64: [UInt64]) {
        self.init(words: NBK.limbs(x64, as: [UInt].self))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Initializers x UIntXL
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    static let min256 = Self(x64:[ 0,  0,  0,  0] as X)
    static let max256 = Self(x64:[~0, ~0, ~0, ~0] as X)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Limbs
    //=------------------------------------------------------------------------=
    
    init(x32: [UInt32]) {
        self.init(words: NBK.limbs(x32, as: [UInt].self))
    }
    
    init(x64: [UInt64]) {
        self.init(words: NBK.limbs(x64, as: [UInt].self))
    }
}
