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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Maybe Two's Complement
//*============================================================================*

final class NBKMaybeTwosComplementTests: XCTestCase {
    
    typealias T = NBK.MaybeTwosComplement
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    private let top256/*--------------*/: W = [0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8]
    private let bottom256/*-----------*/: W = [0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918]
    private let twosComplementTop256/**/: W = [0x18191a1b1c1d1e20, 0x1011121314151617, 0x08090a0b0c0d0e0f, 0x0001020304050607]
    private let twosComplementBottom256 : W = [0xf8f9fafbfcfdff00, 0xf0f1f2f3f4f5f6f7, 0xe8e9eaebecedeeef, 0xe0e1e2e3e4e5e6e7]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertElementsEqual(T(twosComplementOf: top256   ), twosComplementTop256)
        NBKAssertElementsEqual(T(twosComplementOf: bottom256), twosComplementBottom256)
        NBKAssertElementsEqual(T(twosComplementOf: twosComplementTop256   ), top256)
        NBKAssertElementsEqual(T(twosComplementOf: twosComplementBottom256), bottom256)
        
        NBKAssertElementsEqual(T(top256,    formTwosComplement: true ), twosComplementTop256)
        NBKAssertElementsEqual(T(top256,    formTwosComplement: false), top256)
        NBKAssertElementsEqual(T(bottom256, formTwosComplement: true ), twosComplementBottom256)
        NBKAssertElementsEqual(T(bottom256, formTwosComplement: false), bottom256)
        
        NBKAssertElementsEqual(T(twosComplementTop256,    formTwosComplement: true ), top256)
        NBKAssertElementsEqual(T(twosComplementTop256,    formTwosComplement: false), twosComplementTop256)
        NBKAssertElementsEqual(T(twosComplementBottom256, formTwosComplement: true ), bottom256)
        NBKAssertElementsEqual(T(twosComplementBottom256, formTwosComplement: false), twosComplementBottom256)
    }
    
    func testTwosComplementWhenZeroOrEmpty() {
        for count in 0 ... 4 {
            let zero = W(repeating:  0000, count: count)
            NBKAssertElementsEqual(T(zero, formTwosComplement: true ), zero)
            NBKAssertElementsEqual(T(zero, formTwosComplement: false), zero)
        }
    }
        
    func testMagnitude() {
        NBKAssertElementsEqual(T(magnitudeOf: top256,    isSigned: true ), twosComplementTop256)
        NBKAssertElementsEqual(T(magnitudeOf: top256,    isSigned: false), top256)
        NBKAssertElementsEqual(T(magnitudeOf: bottom256, isSigned: true ), bottom256)
        NBKAssertElementsEqual(T(magnitudeOf: bottom256, isSigned: false), bottom256)
        
        NBKAssertElementsEqual(T(magnitudeOf: twosComplementTop256,    isSigned: true ), twosComplementTop256)
        NBKAssertElementsEqual(T(magnitudeOf: twosComplementTop256,    isSigned: false), twosComplementTop256)
        NBKAssertElementsEqual(T(magnitudeOf: twosComplementBottom256, isSigned: true ), bottom256)
        NBKAssertElementsEqual(T(magnitudeOf: twosComplementBottom256, isSigned: false), twosComplementBottom256)
    }
}

//*============================================================================*
// MARK: * NBK x Maybe Twos Complement x Assertions
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

private func NBKAssertElementsEqual<Base: RandomAccessCollection>(
_ base: Base, _ expectation: [Base.Element],
file: StaticString = #file, line: UInt = #line) where Base.Element: Equatable {
    //=------------------------------------------=
    XCTAssertEqual(Array(base), expectation, file: file,  line: line)
    XCTAssertEqual(Array(base.indices.map({ base[$0] })), expectation, file: file, line: line)
    //=------------------------------------------=
    for distance in 0 ..< base.count {
        //=--------------------------------------=
        let index0 = base.index(base.startIndex, offsetBy: distance + 0)
        let index1 = base.index(base.startIndex, offsetBy: distance + 1)
        //=--------------------------------------=
        XCTAssertEqual(base[index0],expectation[distance], file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.index(before: index1), index0, file: file, line: line)
        XCTAssertEqual(base.index(after:  index0), index1, file: file, line: line)

        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 0 - base.count), index0, file: file, line: line)
        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 1 - base.count), index1, file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.distance(from: base.startIndex, to: index0), distance + 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: base.startIndex, to: index1), distance + 1, file: file, line: line)
        
        XCTAssertEqual(base.distance(from: index0, to: base.endIndex), base.count - distance - 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: index1, to: base.endIndex), base.count - distance - 1, file: file, line: line)
    }
    //=------------------------------------------=
    for distance in 0 ... base.count + 1 {
        XCTAssert(base.prefix(distance).elementsEqual(expectation.prefix(distance)), file: file, line: line)
        XCTAssert(base.suffix(distance).elementsEqual(expectation.suffix(distance)), file: file, line: line)
    }
}
