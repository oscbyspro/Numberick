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
// MARK: * NBK x Signed x Division x Digit
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func /=(lhs: inout Self, rhs: Digit) {
        lhs.sign ^= rhs.sign; lhs.magnitude /= rhs.magnitude
    }
    
    @_disfavoredOverload @inlinable public static func /(lhs: Self, rhs: Digit) -> Self {
        Self(sign: lhs.sign ^ rhs.sign, magnitude: lhs.magnitude / rhs.magnitude)
    }
    
    @_disfavoredOverload @inlinable public static func %=(lhs: inout Self, rhs: Digit) {
        lhs.magnitude %= rhs.magnitude
    }
    
    @_disfavoredOverload @inlinable public static func %(lhs: Self, rhs: Digit) -> Digit {
        Digit(sign: lhs.sign, magnitude: lhs.magnitude % rhs.magnitude)
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainder(dividingBy other: Digit) -> QR<Self, Digit> {
        let x: QR<Magnitude, Magnitude.Digit> = self.magnitude.quotientAndRemainder(dividingBy: other.magnitude)
        return QR(Self(sign: self.sign ^ other.sign, magnitude: x.quotient), Digit(sign: self.sign, magnitude: x.remainder))
    }
}
