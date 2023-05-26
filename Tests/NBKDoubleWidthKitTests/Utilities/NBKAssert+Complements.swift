//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Complements
//*============================================================================*

func NBKAssertTwosComplement<T: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<T>, _ twosComplement: NBKDoubleWidth<T>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.twosComplement(),                              twosComplement,      file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(true ).partialValue, twosComplement,      file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(false).partialValue, twosComplement &- 1, file: file, line: line)
    
    XCTAssertEqual({ var x = integer;     x.formTwosComplement();                 return x }(), twosComplement,      file: file, line: line)
    XCTAssertEqual({ var x = integer; _ = x.formTwosComplementSubsequence(true ); return x }(), twosComplement,      file: file, line: line)
    XCTAssertEqual({ var x = integer; _ = x.formTwosComplementSubsequence(false); return x }(), twosComplement &- 1, file: file, line: line)
}
