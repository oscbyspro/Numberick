
//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Sign Magnitude x Comparisons
//*============================================================================*

extension NBK.IntegerSignMagnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns whether `components` is less than `zero`.
    @inlinable public static func isLessThanZero(_ components: Components) -> Bool {
        components.sign == Sign.minus && !components.magnitude.isZero
    }
    
    /// Returns whether `components` is more than `zero`.
    @inlinable public static func isMoreThanZero(_ components: Components) -> Bool {
        components.sign == Sign.plus  && !components.magnitude.isZero
    }
    
    /// A three-way comparison of `components` against `zero`.
    @inlinable public static func signum(_ components: Components) ->  Int {
        components.magnitude.isZero ? 0 : components.sign == Sign.plus ? 1 : -1
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Composition
//=----------------------------------------------------------------------------=

extension NBK.IntegerSignMagnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way sign and magnitude comparison using the given magnitude operation.
    ///
    /// - Parameters:
    ///   - compare: A three-way magnitude comparison.
    ///
    /// - Returns: One of the following values: -1 (less), 0 (same), or 1 (more).
    ///
    @inlinable public static func compare<Other: NBKUnsignedInteger>(
    _   lhs: Components, to rhs: NBK.IntegerSignMagnitude<Other>.Components, using compare: (Magnitude, Other) -> Int) -> Int {
        let absoluteValue:  Int
        
        if  lhs.sign == rhs.sign {
            absoluteValue = compare(lhs.magnitude, rhs.magnitude)
        }   else {
            absoluteValue = lhs.magnitude.isZero && rhs.magnitude.isZero ? 0 : 1 as Int
        }
        
        Swift.assert(-1 <= absoluteValue && absoluteValue <= 1)
        return lhs.sign == Sign.plus ? absoluteValue : absoluteValue.twosComplement()
    }
}
