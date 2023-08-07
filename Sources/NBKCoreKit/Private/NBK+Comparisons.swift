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
        return NBK.compareSuccinctSignedIntegerLimbsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareSignedIntegerLimbs(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let lhs = NBK.makeSuccinctSignedIntegerLimbs(lhs)
        let rhs = NBK.makeSuccinctSignedIntegerLimbs(rhs)
        //=--------------------------------------=
        let partition = Swift.min(index, lhs.body.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.body.suffix(from: partition))
        let comparison = NBK.compareSuccinctSignedIntegerLimbsUnchecked((body: suffix, sign: lhs.sign), to: rhs)
        if !comparison.isZero { return comparison }
        //=--------------------------------------=
        let prefix = NBK.UnsafeWords(rebasing: lhs.body.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs x Succinct
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSuccinctSignedIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Bool),
    to rhs: (body: NBK.UnsafeWords, sign: Bool)) -> Int {
        assert(lhs.body.last != UInt(repeating: lhs.sign))
        assert(rhs.body.last != UInt(repeating: rhs.sign))
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return lhs.sign ? -1 : 1
        }
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count  !=  rhs.body.count {
            return lhs.sign != (lhs.body.count < rhs.body.count) ? -1 : 1
        }
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

//*============================================================================*
// MARK: * NBK x Comparisons x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareUnsignedIntegerLimbs(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.makeSuccinctUnsignedIntegerLimbs(lhs)
        let rhs = NBK.makeSuccinctUnsignedIntegerLimbs(rhs)
        return NBK.compareSuccinctUnsignedIntegerLimbsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareUnsignedIntegerLimbs(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = NBK.compareUnsignedIntegerLimbs(suffix,to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs x Succinct
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSuccinctUnsignedIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Void),
    to rhs: (body: NBK.UnsafeWords, sign: Void)) -> Int {
        assert(lhs.body.last  != UInt(repeating: false))
        assert(rhs.body.last  != UInt(repeating: false))
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count != rhs.body.count {
            return lhs.body.count < rhs.body.count ? -1 : 1
        }
        //=--------------------------------------=
        return NBK.compareSameSizeSuccinctUnsignedIntegerLimbsUnchecked(lhs, to: rhs)
    }

    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareSameSizeSuccinctUnsignedIntegerLimbsUnchecked(
    _  lhs: (body: NBK.UnsafeWords, sign: Void),
    to rhs: (body: NBK.UnsafeWords, sign: Void)) -> Int {
        assert(lhs.body.count == rhs.body.count)
        assert(lhs.body.last  != UInt(repeating: false))
        assert(rhs.body.last  != UInt(repeating: false))
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
