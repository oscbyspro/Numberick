#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Twin Headed
//*============================================================================*

final class NBKTwinHeadedTests: XCTestCase {
    
    typealias T<Base> = NBKTwinHeaded<Base> where Base: RandomAccessCollection
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        let base = [0, 1, 2, 3]
        
        NBKAssertIteration(  T(base, reversed: false), [0, 1, 2, 3])
        NBKAssertIteration(  T(base, reversed: true ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: false), reversed: false), [0, 1, 2, 3])
        NBKAssertIteration(T(T(base, reversed: false), reversed: true ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: false), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: true ), [0, 1, 2, 3])
    }
    
    func testInitDoesNotReverseByDefault() {
        let base = [0, 1, 2, 3]
        
        NBKAssertIteration(  T(base),  [0, 1, 2, 3])
        NBKAssertIteration(T(T(base)), [0, 1, 2, 3])
    }
    
    func testReversed() {
        let base = [0, 1, 2, 3]
        
        NBKAssertIteration(T(base, reversed: false),                       [0, 1, 2, 3])
        NBKAssertIteration(T(base, reversed: false).reversed(),            [3, 2, 1, 0])
        NBKAssertIteration(T(base, reversed: false).reversed().reversed(), [0, 1, 2, 3])
        
        NBKAssertIteration(T(base, reversed: true ),                       [3, 2, 1, 0])
        NBKAssertIteration(T(base, reversed: true ).reversed(),            [0, 1, 2, 3])
        NBKAssertIteration(T(base, reversed: true ).reversed().reversed(), [3, 2, 1, 0])
        
        XCTAssert(type(of: T(base)) == type(of: T(T(base))))
        XCTAssert(type(of: T(base)) == type(of: T(base).reversed()))
    }
}

//*============================================================================*
// MARK: * NBK x Twin Headed x Assertions
//*============================================================================*

private func NBKAssertIteration<B: RandomAccessCollection & MutableCollection>(
_ lhs: B, _ rhs: [B.Element],
file: StaticString = #file, line: UInt  = #line) where B.Element: FixedWidthInteger, B.Element: Equatable {
    XCTAssertEqual(Array(lhs),            rhs,            file: file, line: line)
    XCTAssertEqual(Array(lhs.reversed()), rhs.reversed(), file: file, line: line)
    XCTAssertEqual(Array({ var x = lhs; x.reverse(); return x }()), rhs.reversed(), file: file, line: line)
    
    do {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            lhsIndex = lhs.index(after: lhsIndex)
            rhsIndex = rhs.index(after: rhsIndex)
        }
    }
    
    do {
        var lhsIndex = lhs.endIndex
        var rhsIndex = rhs.endIndex
        while lhsIndex > lhs.startIndex {
            lhsIndex = lhs.index(before: lhsIndex)
            rhsIndex = rhs.index(before: rhsIndex)
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
        }
    }
    
    do {
        for lhsIndex in lhs.indices.enumerated() {
            XCTAssertEqual(lhs[lhsIndex.element], rhs[lhsIndex.offset], file: file, line: line)
        }
    }
    
    do {
        for dropFirst in 0 ..< (2 * lhs.count) {
            XCTAssertEqual(Array(lhs.dropFirst(dropFirst)), Array(rhs.dropFirst(dropFirst)), file: file, line: line)
            if  let first = lhs.dropFirst(dropFirst).first {
                let firstIndex = lhs.index(lhs.startIndex, offsetBy: dropFirst)
                XCTAssertEqual(first, lhs[firstIndex],  file: file, line: line)
            }
        }
    }
    
    do {
        for dropLast in 0 ..< (2 * lhs.count) {
            XCTAssertEqual(Array(lhs.dropLast(dropLast)), Array(rhs.dropLast(dropLast)), file: file, line: line)
            if  let last = lhs.dropLast(dropLast).last {
                let lastIndex = lhs.index(lhs.endIndex, offsetBy: ~dropLast)
                XCTAssertEqual(last, lhs[lastIndex], file: file, line: line)
            }
        }
    }
    
    do {
        var lhs = lhs, lhsIndex = lhs.startIndex
        var rhs = rhs, rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            lhs[lhsIndex] &+= 1
            rhs[rhsIndex] &+= 1
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            lhs.formIndex(after: &lhsIndex)
            rhs.formIndex(after: &rhsIndex)
        }
    }
}

#endif
