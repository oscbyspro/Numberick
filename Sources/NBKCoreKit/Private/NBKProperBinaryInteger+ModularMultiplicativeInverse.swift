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
    
    /// Returns the modular multiplicative inverse of `integer` modulo `modulus`, if it exists.
    ///
    /// - Returns: A value from `0` to `modulus` or `nil`.
    ///
    @inlinable public static func modularMultiplicativeInverse(of integer: Integer, mod modulus: Integer) -> Integer? {
        //=--------------------------------------=
        let lhsIsLessThanZero = integer.isLessThanZero
        let rhsIsLessThanZero = modulus.isLessThanZero
        //=--------------------------------------=
        if  rhsIsLessThanZero { return nil }
        //=--------------------------------------=
        guard let unsigned = Magnitude.modularMultiplicativeInverse(of: integer.magnitude, mod: modulus.magnitude) else { return nil }
        //=--------------------------------------=
        var inverse = Integer(sign: NBK.sign(lhsIsLessThanZero), magnitude: unsigned)!
        if  inverse.isLessThanZero { inverse += modulus }
        return inverse as Integer as Integer as Integer
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Modular Mul. Inverse x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the modular multiplicative inverse of `integer` modulo `modulus`, if it exists.
    ///
    /// - Returns: A value from `0` to `modulus` or `nil`.
    ///
    @inlinable public static func modularMultiplicativeInverse(of integer: Integer, mod modulus: Integer) -> Integer? {
        //=--------------------------------------=
        switch modulus.compared(to: 1 as Integer.Digit) {
        case  1: break;
        case  0: return Integer.zero
        default: return nil }
        //=--------------------------------------=
        let extended = self.greatestCommonDivisorByEuclideanAlgorithm10(of: integer, and: modulus)
        //=--------------------------------------=
        guard extended.result.compared(to: 1 as Integer.Digit).isZero else {
            return nil // the arguments must be coprime
        }
        //=--------------------------------------=
        return extended.iteration.isOdd ? modulus - extended.lhsCoefficient : extended.lhsCoefficient
    }
}
