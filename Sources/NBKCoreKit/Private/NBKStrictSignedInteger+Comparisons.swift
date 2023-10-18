//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Signed Integer x Comparisons
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// ### Development
    ///
    /// Specializing it where `T == UInt` makes it faster.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: some RandomAccessCollection<Base.Element>) -> Int {
        let lhs = NBK.SuccinctInt(fromStrictSignedIntegerSubSequence: lhs)!
        let rhs = NBK.SuccinctInt(fromStrictSignedIntegerSubSequence: rhs)!
        return lhs.compared(to: rhs) as Int
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// ### Development
    ///
    /// Specializing it where `T == UInt` makes it faster.
    ///
    @inlinable public static func compare(_ lhs: Base, to rhs: some RandomAccessCollection<Base.Element>, at index: Base.Index) -> Int {
        let lhs = NBK.SuccinctInt(fromStrictSignedIntegerSubSequence: lhs)!
        let rhs = NBK.SuccinctInt(fromStrictSignedIntegerSubSequence: rhs)!
        let partition  = min(index,lhs.body.endIndex)
        let suffix = lhs.body.suffix(from: partition)
        let comparison = NBK.SuccinctInt(unchecked: suffix, sign: lhs.sign).compared(to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = lhs.body.prefix(upTo: partition)
        return Int(bit: partition == index ? !prefix.allSatisfy({ $0.isZero }) : lhs.sign)
    }
}
