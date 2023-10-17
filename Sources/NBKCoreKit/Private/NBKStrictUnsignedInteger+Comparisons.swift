//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Comparisons x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: Base) -> Int {
        let lhs = NBK.SuccinctInt(fromStrictUnsignedIntegerSubSequence: lhs)
        let rhs = NBK.SuccinctInt(fromStrictUnsignedIntegerSubSequence: rhs)
        return lhs.compared(toSameSign: rhs) as Int
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Note: This operation interprets empty collections as zero.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: Base, at index: Base.Index) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = lhs.suffix(from: partition)
        let comparison = NBK.SUISS<Base.SubSequence>.compare(suffix, to: rhs[...])
        if !comparison.isZero { return comparison }
        let prefix = lhs.prefix(upTo: partition)
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}
