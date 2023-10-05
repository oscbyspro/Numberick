//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Sign Magnitude x Comparisons x Sub Sequence
//*============================================================================*

extension NBK.StrictSignMagnitude.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns whether `components` is less than `zero`.
    @inlinable public static func isLessThanZero(_ components: Components) -> Bool {
        components.sign == Sign.minus && !components.magnitude.allSatisfy({ $0.isZero })
    }
    
    /// Returns whether `components` is more than `zero`.
    @inlinable public static func isMoreThanZero(_ components: Components) -> Bool {
        components.sign == Sign.plus  && !components.magnitude.allSatisfy({ $0.isZero })
    }
    
    /// A three-way comparison of `components` against `zero`.
    @inlinable public static func signum(_ components: Components) -> Int {
        components.magnitude.allSatisfy({ $0.isZero }) ? 0 : components.sign == Sign.plus ? 1 : -1
    }
}
