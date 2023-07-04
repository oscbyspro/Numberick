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
// MARK: * NBK x Assert x Bits
//*============================================================================*

func NBKAssertGetBitAtIndex<H: NBKFixedWidthInteger>(
_ bits: NBKDoubleWidth<H>, _ index: Int, _ result: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(bits[bit:     index], result, file: file, line: line)
    XCTAssertEqual(bits.get(bit: index), result, file: file, line: line)
}

func NBKAssertSetBitAtIndex<H: NBKFixedWidthInteger>(
_ bits: NBKDoubleWidth<H>, _ index: Int, _ newValue: Bool, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let currentValue = bits.get(bit: index)
    //=------------------------------------------=
    XCTAssertEqual({ var x = bits; x[bit: index] = newValue; return x }(), result, file: file, line: line)
    //=------------------------------------------=
    if  newValue {
        XCTAssertEqual({ var x = bits; x.set(bit:    index); return x }(), result, file: file, line: line)
    }
    
    if !newValue {
        XCTAssertEqual({ var x = bits; x.clear(bit:  index); return x }(), result, file: file, line: line)
    }
    
    if  newValue != currentValue {
        XCTAssertEqual({ var x = bits; x.toggle(bit: index); return x }(), result, file: file, line: line)
    }
}
