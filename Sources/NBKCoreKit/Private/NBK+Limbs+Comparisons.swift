//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Limbs x Comparisons x Signed
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer x Strict
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareStrictSignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords) -> Int {
        let lhs = NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: lhs)
        let rhs = NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: rhs)
        return NBK.compareSuccinctBinaryIntegerUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareStrictSignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords, at index: Int) -> Int {
        let lhs = NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: lhs)
        let rhs = NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: rhs)
        let partition = Swift.min(index, lhs.body.endIndex)
        let suffix = UnsafeWords(rebasing: lhs.body.suffix(from: partition))
        let comparison = NBK.compareSuccinctBinaryIntegerUnchecked((body: suffix, sign: lhs.sign), to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = UnsafeWords(rebasing: lhs.body.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Comparisons x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer x Lenient
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compareLenientUnsignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords) -> Int {
        let lhs = NBK.makeSuccinctUnsignedInteger(fromLenientUnsignedInteger: lhs)
        let rhs = NBK.makeSuccinctUnsignedInteger(fromLenientUnsignedInteger: rhs)
        return NBK.compareSameSignSuccinctBinaryIntegerUnchecked(lhs,to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compareLenientUnsignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = NBK.compareLenientUnsignedInteger(suffix, to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Comparisons x Succinct
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSuccinctBinaryIntegerUnchecked<Body>(
    _ lhs: (body: Body, sign: Bool), to rhs: (body: Body, sign: Bool)) -> Int
    where Body: BidirectionalCollection, Body.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        //=--------------------------------------=
        assert(lhs.body.last != Body.Element(repeating: lhs.sign))
        assert(rhs.body.last != Body.Element(repeating: rhs.sign))
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return lhs.sign ? -1 : 1
        }
        //=---------------------------------------=
        return NBK.compareSameSignSuccinctBinaryIntegerUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSameSignSuccinctBinaryIntegerUnchecked<Body>(
    _ lhs: (body: Body, sign: Bool), to rhs: (body: Body, sign: Bool)) -> Int
    where Body: BidirectionalCollection, Body.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        //=--------------------------------------=
        assert(lhs.sign == rhs.sign)
        assert(lhs.body.last != Body.Element(repeating: lhs.sign))
        assert(rhs.body.last != Body.Element(repeating: rhs.sign))
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count  !=  rhs.body.count {
            return lhs.sign == (lhs.body.count > rhs.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return NBK.compareSameSizeSameSignSuccinctBinaryIntegerUnchecked(lhs, to: rhs)
    }

    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSameSizeSameSignSuccinctBinaryIntegerUnchecked<Body>(
    _ lhs: (body: Body, sign: Bool), to rhs: (body: Body, sign: Bool)) -> Int
    where Body: BidirectionalCollection, Body.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        //=--------------------------------------=
        assert(lhs.sign == rhs.sign)
        assert(lhs.body.count == rhs.body.count)
        assert(lhs.body.last  != Body.Element(repeating: lhs.sign))
        assert(rhs.body.last  != Body.Element(repeating: rhs.sign))
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        for index in lhs.body.indices.reversed() {
            let lhsWord  = lhs.body[index] as Body.Element
            let rhsWord  = rhs.body[index] as Body.Element
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return 0 as Int
    }
}
