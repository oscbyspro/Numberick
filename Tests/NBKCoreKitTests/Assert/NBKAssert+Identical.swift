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
// MARK: * NBK x Assert x Identical
//*============================================================================*

func NBKAssertIdentical<T>(_ lhs: NBKSigned<T>, _ rhs: NBKSigned<T>, file: StaticString = #file, line: UInt = #line) {
    let success: Bool = lhs.sign == rhs.sign && lhs.magnitude == rhs.magnitude
    XCTAssert(success, "(\(text(lhs)) is not identical to (\(text(rhs)))", file: file, line: line)
}

func NBKAssertIdentical<T>(_ lhs: NBKSigned<T>?, _ rhs: NBKSigned<T>?, file: StaticString = #file, line: UInt = #line) {
    let success: Bool = lhs?.sign == rhs?.sign && lhs?.magnitude == rhs?.magnitude
    XCTAssert(success, "(\(text(lhs)) is not identical to (\(text(rhs)))", file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func text<T>(_ x: NBKSigned<T>?) -> String {
    x.map({ "\($0.sign)\($0.magnitude)" }) ?? "nil"
}
