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

//*============================================================================*
// MARK: * NBK x Assert x Words
//*============================================================================*

func NBKAssertWords<T: NBKBinaryInteger>(
_ integer: T, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Array(integer.words), words, file: file, line: line)
}
