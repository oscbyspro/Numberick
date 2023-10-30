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
    // MARK: Utilities x Euclidean Algorithm
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm100(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void, Void> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm110(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer, Void> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm101(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void, Integer> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm111(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer, Integer> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Binary Algorithm
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Euclidean Algorithm
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm100(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void, Void> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm110(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer, Void> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm101(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void, Integer> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm111(
    of  lhs: Integer, and rhs: Integer) -> NBK.GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer, Integer> {
        NBK.GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x E.E.A
//*============================================================================*

extension NBK {
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    /// It extends the Euclidean algorithm and returns some additional values.
    ///
    /// ### Result
    ///
    /// ```swift
    /// if  Integer.isSigned {
    ///     precondition(0 ... T.min.magnitude ~= result)
    /// }   else {
    ///     precondition(0 ... T.max.magnitude ~= result)
    /// }
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
    /// if  Integer.isSigned {
    ///     precondition((lhs &* lhsCoefficient &+ rhs &* rhsCoefficient) == Integer(bitPattern: result))
    ///     else if !iteration.isOdd {
    ///     precondition((lhs &* lhsCoefficient &- rhs &* rhsCoefficient) == result)
    /// }   else {
    ///     precondition((rhs &* rhsCoefficient &- lhs &* lhsCoefficient) == result)
    /// }
    /// ```
    ///
    /// ### Quotients of dividing by GCD
    ///
    /// ```swift
    /// if  result.isZero, result <= Integer.max else {
    ///     precondition(lhsQuotient == lhs / result)
    ///     precondition(rhsQuotient == rhs / result)
    /// }
    /// ```
    ///
    /// ### Iteration
    ///
    /// ```swift
    /// let lhsCoefficientSign = lhs.isLessThanZero != iteration.isOdd
    /// let rhsCoefficientSign = rhs.isLessThanZero == iteration.isOdd
    /// ```
    ///
    @frozen public struct GreatestCommonDivisorByEuclideanAlgorithm<X, Y, Z> where X: NBKBinaryInteger {
        
        /// The main integer's magnitude type.
        public typealias I = X.Magnitude
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var i: ((I))
        @usableFromInline var x: (I,I)
        @usableFromInline var y: (Y,Y)
        @usableFromInline var z: (Z,Z)
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var iteration: I {
            self.i
        }
        
        @inlinable public var result: I {
            self.x.0
        }
        
        @inlinable public var lhsCoefficient: Y {
            self.y.0
        }
        
        @inlinable public var rhsQuotient: Y {
            self.y.1
        }
        
        @inlinable public var rhsCoefficient: Z {
            self.z.0
        }
        
        @inlinable public var lhsQuotient: Z {
            self.z.1
        }
    }
}
//=----------------------------------------------------------------------------=
// MARK: + Integer, Void, Void
//=----------------------------------------------------------------------------=

extension NBK.GreatestCommonDivisorByEuclideanAlgorithm where Y == Void, Z == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKSignedInteger {
        //=--------------------------------------=
        let unsigned = NBK.GreatestCommonDivisorByEuclideanAlgorithm<I, Void, Void>(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        self.i = unsigned.i
        self.x = unsigned.x
    }
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKUnsignedInteger {
        self.i = (00000000)
        self.x = (lhs, rhs)
        
        reduce: while !(self.x.1.isZero) {
            self.i   += 0001 as X.Digit
            self.x.0 %= self.x.1
            Swift.swap(&self.x.0, &self.x.1)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer, Integer, Void
//=----------------------------------------------------------------------------=

extension NBK.GreatestCommonDivisorByEuclideanAlgorithm where Y == X, Z == Void {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKSignedInteger {
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = NBK.GreatestCommonDivisorByEuclideanAlgorithm<I, I, Void>(of: lhs.magnitude, and: rhs.magnitude)
        let odd = unsigned.iteration.isOdd as Bool
        //=--------------------------------------=
        self.i = unsigned.i
        self.x = unsigned.x
        //=--------------------------------------=
        self.y.0 = Y(sign: lhsIsLessThanZero != odd ? .minus : .plus, magnitude: unsigned.y.0)!
        self.y.1 = Y(sign: rhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.y.1)!
    }
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKUnsignedInteger {
        self.i = (00000000)
        self.x = (lhs, rhs)
        self.y = (001, 000)
        
        reduce: while !self.x.1.isZero {
            let division = self.x.0.quotientAndRemainder(dividingBy: self.x.1)
            self.i += (000000000000001) as X.Digit
            self.x  = (self.x.1, division.remainder)
            self.y  = (self.y.1, division.quotient * self.y.1 + self.y.0)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer, Void, Integer
//=----------------------------------------------------------------------------=

extension NBK.GreatestCommonDivisorByEuclideanAlgorithm where Y == Void, Z == X {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKSignedInteger {
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = NBK.GreatestCommonDivisorByEuclideanAlgorithm<I, Void, I>(of: lhs.magnitude, and: rhs.magnitude)
        let odd = unsigned.iteration.isOdd as Bool
        //=--------------------------------------=
        self.i = unsigned.i
        self.x = unsigned.x
        //=--------------------------------------=
        self.z.0 = Z(sign: rhsIsLessThanZero == odd ? .minus : .plus, magnitude: unsigned.z.0)!
        self.z.1 = Z(sign: lhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.z.1)!
    }
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKUnsignedInteger {
        self.i = (00000000)
        self.x = (lhs, rhs)
        self.z = (000, 001)
        
        reduce: while !self.x.1.isZero {
            let division = self.x.0.quotientAndRemainder(dividingBy: self.x.1)
            self.i += (000000000000001) as X.Digit
            self.x  = (self.x.1, division.remainder)
            self.z  = (self.z.1, division.quotient * self.z.1 + self.z.0)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer, Integer, Integer
//=----------------------------------------------------------------------------=

extension NBK.GreatestCommonDivisorByEuclideanAlgorithm where Y == X, Z == X {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKSignedInteger {
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = NBK.GreatestCommonDivisorByEuclideanAlgorithm<I, I, I>(of: lhs.magnitude, and: rhs.magnitude)
        let odd = unsigned.iteration.isOdd as Bool
        //=--------------------------------------=
        self.i = unsigned.i
        self.x = unsigned.x
        //=--------------------------------------=
        self.y.0 = Y(sign: lhsIsLessThanZero != odd ? .minus : .plus, magnitude: unsigned.y.0)!
        self.y.1 = Y(sign: rhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.y.1)!
        self.z.0 = Z(sign: rhsIsLessThanZero == odd ? .minus : .plus, magnitude: unsigned.z.0)!
        self.z.1 = Z(sign: lhsIsLessThanZero /*--*/ ? .minus : .plus, magnitude: unsigned.z.1)!
    }
    
    @inlinable init(of lhs: X, and rhs: X) where X: NBKUnsignedInteger {
        self.i = (00000000)
        self.x = (lhs, rhs)
        self.y = (001, 000)
        self.z = (000, 001)
        
        reduce: while !self.x.1.isZero {
            let division = self.x.0.quotientAndRemainder(dividingBy: self.x.1)
            self.i += (000000000000001) as X.Digit
            self.x  = (self.x.1, division.remainder)
            self.y  = (self.y.1, division.quotient * self.y.1 + self.y.0)
            self.z  = (self.z.1, division.quotient * self.z.1 + self.z.0)
        }
    }
}
