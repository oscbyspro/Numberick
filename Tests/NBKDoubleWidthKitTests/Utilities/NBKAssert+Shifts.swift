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
// MARK: * NBK x Assert x Shifts
//*============================================================================*

func NBKAssertShiftLeft<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by:   rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by:   rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(                 lhs &<<  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeft(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedLeft(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words); return lhs }(), result, file: file, line: line)
    }
}

func NBKAssertShiftRight<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(                 lhs &>>  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRight(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedRight(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words); return lhs }(), result, file: file, line: line)
    }
}

//*============================================================================*
// MARK: * NBK x Assert x Shifts x Masked
//*============================================================================*

func NBKAssertShiftLeftByMasking<H: NBKFixedWidthInteger, S: NBKFixedWidthInteger & NBKSignedInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>, signitude: S.Type,
file: StaticString = #file, line: UInt = #line) where S.Digit: NBKCoreInteger<UInt> {
    //=------------------------------------------=
    typealias T  = NBKDoubleWidth<H>
    typealias M  = NBKDoubleWidth<H>.Magnitude
    typealias S2 = NBKDoubleWidth<S>
    typealias M2 = NBKDoubleWidth<S>.Magnitude
    precondition(S.Magnitude.self == M.self)
    //=------------------------------------------=
    func NBKAssertWith(_ lhs: T, _ rhs: Int, _ result: T) {
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWith(lhs, rhs,                result)
    NBKAssertWith(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWith(lhs, rhs - lhs.bitWidth, result)
    //=------------------------------------------=
    func NBKAssertWithProtocolWitnessesOf<T>(_ lhs: T, _ rhs: Int, _ result: T) where T: NBKFixedWidthInteger {
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWithProtocolWitnessesOf(lhs, rhs,                result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs - lhs.bitWidth, result)
}

func NBKAssertShiftRightByMasking<H: NBKFixedWidthInteger, S: NBKFixedWidthInteger & NBKSignedInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>, signitude: S.Type,
file: StaticString = #file, line: UInt = #line) where S.Digit: NBKCoreInteger<UInt> {
    //=------------------------------------------=
    typealias T  = NBKDoubleWidth<H>
    typealias M  = NBKDoubleWidth<H>.Magnitude
    typealias S2 = NBKDoubleWidth<S>
    typealias M2 = NBKDoubleWidth<S>.Magnitude
    precondition(S.Magnitude.self == M.self)
    //=------------------------------------------=
    func NBKAssertWith(_ lhs: T, _ rhs: Int, _ result: T) {
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWith(lhs, rhs,                result)
    NBKAssertWith(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWith(lhs, rhs - lhs.bitWidth, result)
    //=------------------------------------------=
    func NBKAssertWithProtocolWitnessesOf<T>(_ lhs: T, _ rhs: Int, _ result: T) where T: NBKFixedWidthInteger {
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWithProtocolWitnessesOf(lhs, rhs,                result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs - lhs.bitWidth, result)
}
