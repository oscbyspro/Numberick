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
        typealias SBI = SuccinctBinaryInteger<UnsafeWords>
        let lhs = SBI.components(fromStrictSignedInteger: lhs)
        let rhs = SBI.components(fromStrictSignedInteger: rhs)
        return SBI.compare(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    @inlinable public static func compareStrictSignedInteger(_ lhs: UnsafeWords, to rhs: UnsafeWords, at index: Int) -> Int {
        typealias SBI = SuccinctBinaryInteger<UnsafeWords>
        let lhs = SBI.components(fromStrictSignedInteger: lhs)
        let rhs = SBI.components(fromStrictSignedInteger: rhs)
        let partition = Swift.min(index,   lhs.body.endIndex)
        let suffix = UnsafeWords(rebasing: lhs.body.suffix(from: partition))
        let comparison = SBI.compare((body: suffix, sign: lhs.sign),to: rhs)
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
        typealias SBI = SuccinctBinaryInteger<UnsafeWords>
        let lhs = SBI.components(fromStrictUnsignedIntegerSubSequence: lhs)
        let rhs = SBI.components(fromStrictUnsignedIntegerSubSequence: rhs)
        return SBI.compareSameSign(lhs, to: rhs)
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
