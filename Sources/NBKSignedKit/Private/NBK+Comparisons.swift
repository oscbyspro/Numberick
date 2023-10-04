//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Comparisons
//*============================================================================*

extension NBK {
    
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
    @inlinable public static func compare<A: NBKUnsignedInteger, B: NBKUnsignedInteger>(
    _   lhs: SM<A>, to rhs: SM<B>, using compare: (A, B) -> Int) -> Int {
        let absoluteValue: Int
        
        if  lhs.sign == rhs.sign {
            absoluteValue = compare(lhs.magnitude, rhs.magnitude)
        }   else {
            absoluteValue = lhs.magnitude.isZero && rhs.magnitude.isZero ? 0 : 1 as Int
        }
        
        Swift.assert(-1 <= absoluteValue && absoluteValue <= 1)
        return lhs.sign == Sign.plus ? absoluteValue : absoluteValue.twosComplement()
    }
}
