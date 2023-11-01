//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Modular Mul. Inverse
//*============================================================================*

extension NBK.ProperBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the modular multiplicative inverse of `lhs` modulo `rhs`, if it exists.
    ///
    /// - Returns: A value from `0` to `modulus` or `nil`.
    ///
    @inlinable public static func modularMultiplicativeInverse(of lhs: Integer, modulo rhs: Integer) -> Integer? {
        //=--------------------------------------=
        let lhsIsLessThanZero = lhs.isLessThanZero
        let rhsIsLessThanZero = rhs.isLessThanZero
        //=--------------------------------------=
        if  rhsIsLessThanZero { return nil }
        //=--------------------------------------=
        guard  let magnitude = Magnitude.modularMultiplicativeInverse(
        sign:  NBK.sign(lhsIsLessThanZero), magnitude: lhs.magnitude, modulo: rhs.magnitude) else { return nil }
        return Integer(magnitude: magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Modular Mul. Inverse x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the modular multiplicative inverse of `sign` and `magnitude` modulo `modulus`, if it exists.
    ///
    /// - Returns: A value from `0` to `modulus` or `nil`.
    ///
    @inlinable public static func modularMultiplicativeInverse(sign: NBK.Sign, magnitude: Integer, modulo modulus: Integer) -> Integer? {
        //=--------------------------------------=
        switch modulus.compared(to: 1 as Integer.Digit) {
        case  1: break;
        case  0: return Integer.zero
        default: return nil }
        //=--------------------------------------=
        let extended = self.greatestCommonDivisorByEuclideanAlgorithm10(of: magnitude, and: modulus)
        //=--------------------------------------=
        guard extended.result.compared(to: 1 as Integer.Digit).isZero else {
            return nil // the arguments must be coprime
        }
        //=--------------------------------------=
        Swift.assert(extended.lhsCoefficient.isMoreThanZero)
        return (sign == .minus) == extended.iteration.isEven ? modulus - extended.lhsCoefficient : extended.lhsCoefficient
    }
}
