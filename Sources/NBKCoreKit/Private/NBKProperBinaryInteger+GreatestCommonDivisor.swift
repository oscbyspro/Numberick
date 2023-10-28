//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor
//*============================================================================*

extension NBK.ProperBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using [this binary algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm(
    of lhs: Integer, and rhs: Integer) -> Integer.Magnitude {
        NBK.PUI.greatestCommonDivisorByBinaryAlgorithm(of: lhs.magnitude, and: rhs.magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Signed
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    /// It extends the Euclidean algorithm and returns some additional values.
    ///
    /// ### Result
    ///
    /// ```swift
    /// precondition(0 <= result && result <= T.min.magnitude)
    /// ```
    ///
    /// - Note: The GCD of `0` and `0` is `0`.
    ///
    /// - Note: The GCD of `Int.min` and `Int.min` is `Int.min.magnitude`.
    ///
    /// ### Bézout's identity
    ///
    /// ```swift
    /// precondition(T(bitPattern: result) == lhs &* lhsCoefficient &+ rhs &* rhsCoefficient)
    /// ```
    ///
    /// ### Quotients of dividing by GCD
    ///
    /// ```swift
    /// guard result != 00000 else { return }
    /// guard result <= T.max else { return }
    ///
    /// precondition(lhsQuotient == lhs / T(result))
    /// precondition(rhsQuotient == rhs / T(result))
    /// ```
    ///
    @inlinable public static func greatestCommonDivisorByExtendedEuclideanAlgorithm(of lhs: Integer, and rhs: Integer)
    -> (result: Integer.Magnitude, lhsCoefficient: Integer, rhsCoefficient: Integer, lhsQuotient: Integer, rhsQuotient: Integer) {
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = Magnitude.greatestCommonDivisorByExtendedEuclideanAlgorithm(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        return (result: unsigned.result,
        lhsCoefficient: Integer(sign: lhsIsLessThanZero != unsigned.iterationIsOdd ? .minus : .plus, magnitude: unsigned.lhsCoefficient)!,
        rhsCoefficient: Integer(sign: rhsIsLessThanZero == unsigned.iterationIsOdd ? .minus : .plus, magnitude: unsigned.rhsCoefficient)!,
        lhsQuotient:    Integer(sign: lhsIsLessThanZero /*----------------------*/ ? .minus : .plus, magnitude: unsigned.lhsQuotient   )!,
        rhsQuotient:    Integer(sign: rhsIsLessThanZero /*----------------------*/ ? .minus : .plus, magnitude: unsigned.rhsQuotient   )!)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    /// - TODO: Use `bitShift(...)` methods if/when NBKBinaryInteger...
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm(
    of  lhs: Integer, and rhs: Integer) -> Integer {
        //=--------------------------------------=
        if  rhs.isZero { return lhs }
        if  lhs.isZero { return rhs }
        //=--------------------------------------=
        let lhs2sCount = lhs.trailingZeroBitCount // lhs == 2 ^ x * a
        let rhs2sCount = rhs.trailingZeroBitCount // rhs == 2 ^ y * b
        //=--------------------------------------=
        var lhs: Integer = lhs >> lhs2sCount
        var rhs: Integer = rhs >> rhs2sCount
        
        while   lhs  != rhs {
            if  lhs   < rhs {
                let _ = rhs.subtractReportingOverflow(lhs)
                rhs >>= rhs.trailingZeroBitCount
            }   else {
                let _ = lhs.subtractReportingOverflow(rhs)
                lhs >>= lhs.trailingZeroBitCount
            }
        }
        
        lhs <<= Swift.min(lhs2sCount, rhs2sCount) // the 2s in common
        return  lhs as Integer.Magnitude
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    /// It extends the Euclidean algorithm and returns some additional values.
    ///
    /// ### Result
    ///
    /// ```swift
    /// precondition(0 <= result && result <= T.max)
    /// ```
    ///
    /// - Note: The GCD of `0` and `0` is `0`.
    ///
    /// ### Bézout's identity (unsigned)
    ///
    /// ```swift
    /// if !iterationIsOdd {
    ///     precondition(result == (lhs &* lhsCoefficient &- rhs &* rhsCoefficient))
    /// }   else {
    ///     precondition(result == (rhs &* rhsCoefficient &- lhs &* lhsCoefficient))
    /// }
    /// ```
    ///
    /// ### Quotients of dividing by GCD
    ///
    /// ```swift
    /// guard result != 0000000000 else { return }
    /// precondition(lhsQuotient == lhs / result)
    /// precondition(rhsQuotient == rhs / result)
    /// ```
    ///
    /// ### Loop count result
    ///
    /// ```swift
    /// let lhsCoefficientSign = lhs.isLessThanZero != iterationIsOdd
    /// let rhsCoefficientSign = rhs.isLessThanZero == iterationIsOdd
    /// ```
    ///
    @inlinable public static func greatestCommonDivisorByExtendedEuclideanAlgorithm(of lhs: Integer, and rhs: Integer)
    -> (result: Integer, lhsCoefficient: Integer, rhsCoefficient: Integer, lhsQuotient: Integer, rhsQuotient: Integer, iterationIsOdd: Bool) {
        //=--------------------------------------=
        var (a, b) = (lhs, rhs) as (Integer,Integer)
        var (c, d) = (001, 000) as (Integer,Integer)
        var (e, f) = (000, 001) as (Integer,Integer)
        var iterationIsOdd = (((((((((false)))))))))
        //=--------------------------------------=
        while !b.isZero {
            
            iterationIsOdd.toggle()
            let division = a.quotientAndRemainder(dividingBy: b)
            
            (a, b) = (b, division.remainder)
            (c, d) = (d, division.quotient * d + c)
            (e, f) = (f, division.quotient * f + e)
        }
        //=--------------------------------------=
        return (result: a, lhsCoefficient: c, rhsCoefficient: e, lhsQuotient: f, rhsQuotient: d, iterationIsOdd: iterationIsOdd)
    }
}
