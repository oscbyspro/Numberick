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
        let lhs = SuccinctInt(fromStrictSignedInteger: lhs)!
        let rhs = SuccinctInt(fromStrictSignedInteger: rhs)!
        return lhs.compared(to: rhs) as Int
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareStrictSignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords, at index: Int) -> Int {
        let lhs = SuccinctInt(fromStrictSignedInteger: lhs)!
        let rhs = SuccinctInt(fromStrictSignedInteger: rhs)!
        let partition = Swift.min(index,   lhs.body.endIndex)
        let suffix = UnsafeWords(rebasing: lhs.body.suffix(from: partition))
        let comparison = SuccinctInt(unchecked: suffix, sign: lhs.sign).compared(to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = UnsafeWords(rebasing: lhs.body.prefix(upTo: partition))
        return Int(bit: partition == index ? !prefix.allSatisfy{ $0.isZero } : lhs.sign)
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
        let lhs = SuccinctInt(fromStrictUnsignedIntegerSubSequence: lhs)
        let rhs = SuccinctInt(fromStrictUnsignedIntegerSubSequence: rhs)
        return lhs.compared(toSameSign: rhs) as Int
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
