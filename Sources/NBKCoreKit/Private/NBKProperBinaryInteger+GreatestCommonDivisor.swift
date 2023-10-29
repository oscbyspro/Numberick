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
    /// precondition(0 ... T.min.magnitude ~= result)
    /// ```
    ///
    /// - Note: The GCD of `0` and `0` is `0`.
    ///
    /// - Note: The GCD of `0` and `X` is `X`.
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
    /// guard !result.isZero, result <= T.max else { return }
    /// precondition(lhsQuotient == lhs / T(result))
    /// precondition(rhsQuotient == rhs / T(result))
    /// ```
    ///
    /// ### Iteration
    ///
    /// ```swift
    /// let lhsCoefficientSign = lhs.isLessThanZero != iteration.isOdd
    /// let rhsCoefficientSign = rhs.isLessThanZero == iteration.isOdd
    /// ```
    ///
    @inlinable public static func greatestCommonDivisorByExtendedEuclideanAlgorithm(of lhs: Integer, and rhs: Integer)
    -> (result: Integer.Magnitude, lhsCoefficient: Integer, rhsCoefficient: Integer, lhsQuotient: Integer, rhsQuotient: Integer, iteration: Integer.Magnitude) {
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = Magnitude.greatestCommonDivisorByExtendedEuclideanAlgorithm(of: lhs.magnitude, and: rhs.magnitude)
        let odd = unsigned.iteration.isOdd as Bool
        //=--------------------------------------=
        return (
        result:         unsigned.result    as Integer.Magnitude,
        lhsCoefficient: Integer(sign: lhsIsLessThanZero != odd ? .minus : .plus, magnitude: unsigned.lhsCoefficient)!,
        rhsCoefficient: Integer(sign: rhsIsLessThanZero == odd ? .minus : .plus, magnitude: unsigned.rhsCoefficient)!,
        lhsQuotient:    Integer(sign: lhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.lhsQuotient   )!,
        rhsQuotient:    Integer(sign: rhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.rhsQuotient   )!,
        iteration:      unsigned.iteration as Integer.Magnitude)
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
    /// precondition(0 ... T.max ~= result)
    /// ```
    ///
    /// - Note: The GCD of `0` and `0` is `0`.
    ///
    /// - Note: The GCD of `0` and `X` is `X`.
    ///
    /// ### Bézout's identity (unsigned)
    ///
    /// ```swift
    /// if !iteration.isOdd {
    ///     precondition(result == (lhs &* lhsCoefficient &- rhs &* rhsCoefficient))
    /// }   else {
    ///     precondition(result == (rhs &* rhsCoefficient &- lhs &* lhsCoefficient))
    /// }
    /// ```
    ///
    /// ### Quotients of dividing by GCD
    ///
    /// ```swift
    /// guard !result.isZero else { return }
    /// precondition(lhsQuotient == lhs / result)
    /// precondition(rhsQuotient == rhs / result)
    /// ```
    ///
    /// ### Iteration
    ///
    /// ```swift
    /// let lhsCoefficientSign = lhs.isLessThanZero != iteration.isOdd
    /// let rhsCoefficientSign = rhs.isLessThanZero == iteration.isOdd
    /// ```
    ///
    @inlinable public static func greatestCommonDivisorByExtendedEuclideanAlgorithm(of lhs: Integer, and rhs: Integer)
    -> (result: Integer, lhsCoefficient: Integer, rhsCoefficient: Integer, lhsQuotient: Integer, rhsQuotient: Integer, iteration: Integer) {
        //=--------------------------------------=
        var (a, b) = (lhs, rhs) as (Integer,Integer)
        var (c, d) = (001, 000) as (Integer,Integer)
        var (e, f) = (000, 001) as (Integer,Integer)
        var iteration = 0000000 as (((((Integer)))))
        //=--------------------------------------=
        while !b.isZero {
            let division = a.quotientAndRemainder(dividingBy: b)
            (a, b) = (b, division.remainder)
            (c, d) = (d, division.quotient * d + c)
            (e, f) = (f, division.quotient * f + e)
            iteration += 000000001 as Integer.Digit
        }
        //=--------------------------------------=
        return (result: a, lhsCoefficient: c, rhsCoefficient: e, lhsQuotient: f, rhsQuotient: d, iteration: iteration)
    }
}
