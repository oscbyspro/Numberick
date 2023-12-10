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
// MARK: * NBK x Flexible Width x Exponentiation x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `power` of `self` raised to `exponent`.
    ///
    /// - Parameter exponent: A value greater than or equal to zero.
    ///
    @inlinable public func power(_ exponent: Int) -> Self {
        //=--------------------------------------=
        if      exponent == 0 { return Self.one }
        else if exponent == 1 { return self     }
        //=--------------------------------------=
        Swift.assert(exponent > 001)
        var power = Self(digit: 001)
        var multiplier: Self = self
        var pattern = UInt(exponent)
        //=--------------------------------------=
        repeat {
            
            if  pattern.isOdd {
                power *= multiplier
            }
            
            pattern &>>= 000001
            multiplier.square()
            
        }   while !pattern.isZero
        //=--------------------------------------=
        return power as Self as Self as Self as Self
    }
}
