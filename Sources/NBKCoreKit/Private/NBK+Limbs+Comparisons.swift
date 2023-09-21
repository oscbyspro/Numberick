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
