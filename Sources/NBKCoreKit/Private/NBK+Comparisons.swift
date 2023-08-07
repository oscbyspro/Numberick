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
    // MARK: Details x Succinct Binary Integer
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareAsSignedIntegers(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.succinctSignedInteger(lhs)
        let rhs = NBK.succinctSignedInteger(rhs)
        return NBK.compareAsSuccinctSignedIntegers(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareAsSignedIntegers(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = NBK.compareAsSignedIntegers(suffix, to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        switch lhs.last!.mostSignificantBit {
        case  true: return -Int(bit: !prefix.allSatisfy({ $0 == UInt.max }))
        case false: return  Int(bit: !prefix.allSatisfy({ $0 == UInt.min })) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Succinct Binary Integer x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Requires: `lhs` and `rhs` must only contain significant words.
    ///
    @inlinable static func compareAsSuccinctSignedIntegers(
    _  lhs: (body: NBK.UnsafeWords, sign: Bool),
    to rhs: (body: NBK.UnsafeWords, sign: Bool)) -> Int {
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
        // Word By Word In Reverse Order
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
    // MARK: Details x Succinct Binary Integer
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareAsUnsignedIntegers(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.succinctUnsignedInteger(lhs)
        let rhs = NBK.succinctUnsignedInteger(rhs)
        return NBK.compareAsSuccinctUnsignedIntegers(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareAsUnsignedIntegers(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = NBK.compareAsUnsignedIntegers(suffix, to: rhs)
        guard comparison.isZero else { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0 == UInt.min }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Succinct Binary Integer x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Requires: `lhs` and `rhs` must only contain significant words.
    ///
    @inlinable static func compareAsSuccinctUnsignedIntegers(
    _  lhs: (body: NBK.UnsafeWords, sign: Void),
    to rhs: (body: NBK.UnsafeWords, sign: Void)) -> Int {
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count != rhs.body.count {
            return lhs.body.count < rhs.body.count ? -1 : 1
        }
        //=--------------------------------------=
        // Word By Word In Reverse Order
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
