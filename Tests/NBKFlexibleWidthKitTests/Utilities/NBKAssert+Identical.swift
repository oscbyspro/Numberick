//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKFlexibleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Identical
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
