//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Comparisons x Signed
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareSignedIntegerLimbs(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.makeSuccinctSignedIntegerLimbs(lhs)
        let rhs = NBK.makeSuccinctSignedIntegerLimbs(rhs)
        return NBK.compareSuccinctBinaryIntegerLimbsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareSignedIntegerLimbs(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let lhs = NBK.makeSuccinctSignedIntegerLimbs(lhs)
        let rhs = NBK.makeSuccinctSignedIntegerLimbs(rhs)
        let partition = Swift.min(index, lhs.body.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.body.suffix(from: partition))
        let comparison = NBK.compareSuccinctBinaryIntegerLimbsUnchecked((body: suffix, sign: lhs.sign), to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.body.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}

//*============================================================================*
// MARK: * NBK x Comparisons x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compareUnsignedIntegerLimbsLenient(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.makeSuccinctUnsignedIntegerLimbsLenient(lhs)
        let rhs = NBK.makeSuccinctUnsignedIntegerLimbsLenient(rhs)
        return NBK.compareSameSignSuccinctBinaryIntegerLimbsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compareUnsignedIntegerLimbsLenient(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = NBK.compareUnsignedIntegerLimbsLenient(suffix, to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}

//*============================================================================*
// MARK: * NBK x Comparisons x Succinct
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSuccinctBinaryIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Bool),
    to rhs: (body: NBK.UnsafeWords, sign: Bool)) -> Int {
        //=--------------------------------------=
        assert(lhs.body.last != UInt(repeating: lhs.sign))
        assert(rhs.body.last != UInt(repeating: rhs.sign))
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return lhs.sign ? -1 : 1
        }
        //=---------------------------------------=
        return NBK.compareSameSignSuccinctBinaryIntegerLimbsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSameSignSuccinctBinaryIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Bool),
    to rhs: (body: NBK.UnsafeWords, sign: Bool)) -> Int {
        //=--------------------------------------=
        assert(lhs.sign == rhs.sign)
        assert(lhs.body.last != UInt(repeating: lhs.sign))
        assert(rhs.body.last != UInt(repeating: rhs.sign))
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count  !=  rhs.body.count {
            return lhs.sign == (lhs.body.count > rhs.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return NBK.compareSameSizeSameSignSuccinctBinaryIntegerLimbsUnchecked(lhs, to: rhs)
    }

    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSameSizeSameSignSuccinctBinaryIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Bool),
    to rhs: (body: NBK.UnsafeWords, sign: Bool)) -> Int {
        //=--------------------------------------=
        assert(lhs.sign == rhs.sign)
        assert(lhs.body.count == rhs.body.count)
        assert(lhs.body.last  != UInt(repeating: lhs.sign))
        assert(rhs.body.last  != UInt(repeating: rhs.sign))
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        for index in lhs.body.indices.reversed() {
            let lhsWord  = lhs.body[index] as UInt
            let rhsWord  = rhs.body[index] as UInt
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return Int.zero
    }
}
