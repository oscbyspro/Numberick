//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG
#if SBI && swift(>=5.8)

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Static Big Int
//*============================================================================*

final class NBKStaticBigIntTests: XCTestCase {
    
    typealias T = NBKStaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testToFromSwiftStaticBigInt() {
        XCTAssertEqual(T(Swift.StaticBigInt(123))[0], 123)
        XCTAssertEqual(Swift.StaticBigInt(T(123))[0], 123)
    }
    
    func testBitWidth() {
        XCTAssertEqual(T( 1).bitWidth, 2)
        XCTAssertEqual(T( 0).bitWidth, 1)
        XCTAssertEqual(T(-1).bitWidth, 1)
        XCTAssertEqual(T(-2).bitWidth, 2)
        
        XCTAssertEqual(T( 2147483648).bitWidth, 33)
        XCTAssertEqual(T( 2147483647).bitWidth, 32)
        XCTAssertEqual(T(-2147483648).bitWidth, 32)
        XCTAssertEqual(T(-2147483649).bitWidth, 33)
        
        XCTAssertEqual(T( 9223372036854775808).bitWidth, 65)
        XCTAssertEqual(T( 9223372036854775807).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775808).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775809).bitWidth, 65)
    }
    
    func testSignum() {
        XCTAssertEqual(T( 1).signum(),  1)
        XCTAssertEqual(T( 0).signum(),  0)
        XCTAssertEqual(T(-1).signum(), -1)
        XCTAssertEqual(T(-2).signum(), -1)
        
        XCTAssertEqual(T( 2147483648).signum(),  1)
        XCTAssertEqual(T( 2147483647).signum(),  1)
        XCTAssertEqual(T(-2147483648).signum(), -1)
        XCTAssertEqual(T(-2147483649).signum(), -1)
        
        XCTAssertEqual(T( 9223372036854775808).signum(),  1)
        XCTAssertEqual(T( 9223372036854775807).signum(),  1)
        XCTAssertEqual(T(-9223372036854775808).signum(), -1)
        XCTAssertEqual(T(-9223372036854775809).signum(), -1)
    }
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T( 0)[Int.max],  0 as UInt)
        XCTAssertEqual(T(-1)[Int.max], ~0 as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Static Big Int x Collection
//*============================================================================*

final class NBKStaticBigIntTestsOnCollection: XCTestCase {
    
    typealias T = NBKStaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let top256:    T = -0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e20
    let bottom256: T =  0x1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() {
        NBKAssertElementsEqual(T( 1), [UInt( 1)])
        NBKAssertElementsEqual(T( 0), [UInt(  )])
        NBKAssertElementsEqual(T(-1), [UInt.max])
    }
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertElementsEqual(T(-0x8000000000000001), [UInt(bitPattern: Int.max), UInt.max])
        NBKAssertElementsEqual(T(-0x8000000000000000), [UInt(bitPattern: Int.min)])
        NBKAssertElementsEqual(T( 0x7fffffffffffffff), [UInt(bitPattern: Int.max)])
        NBKAssertElementsEqual(T( 0x8000000000000000), [UInt(bitPattern: Int.min), UInt.min])
        
        NBKAssertElementsEqual(   top256, [0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8])
        NBKAssertElementsEqual(bottom256, [0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertElementsEqual(T(-0x80000001), [UInt(bitPattern: Int.max), UInt.max])
        NBKAssertElementsEqual(T(-0x80000000), [UInt(bitPattern: Int.min)])
        NBKAssertElementsEqual(T( 0x7fffffff), [UInt(bitPattern: Int.max)])
        NBKAssertElementsEqual(T( 0x80000000), [UInt(bitPattern: Int.min), UInt.min])
        
        NBKAssertElementsEqual(   top256, [0xe3e2e1e0, 0xe7e6e5e4, 0xebeae9e8, 0xefeeedec, 0xf3f2f1f0, 0xf7f6f5f4, 0xfbfaf9f8, 0xfffefdfc])
        NBKAssertElementsEqual(bottom256, [0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c, 0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c])
    }
}

//*============================================================================*
// MARK: * NBK x Static Big Int x Assertions
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

#endif
#endif
