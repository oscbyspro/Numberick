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
    // MARK: Utilities x Binary Algorithm
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using [this binary algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm(
    of lhs: Integer, and rhs: Integer) -> Integer.Magnitude {
        NBK.PUI.greatestCommonDivisorByBinaryAlgorithm(of: lhs.magnitude, and: rhs.magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Euclidean Algorithm
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm00(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Void, Void> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm10(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm01(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Void, Integer> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm11(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
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
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm00(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Void, Void> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm10(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Integer, Void> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm01(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Void, Integer> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
    
    /// Finds the GCD of `lhs` and `rhs` by using this [algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByEuclideanAlgorithm11(
    of  lhs: Integer, and rhs: Integer) -> GreatestCommonDivisorByEuclideanAlgorithm<Integer, Integer> {
        GreatestCommonDivisorByEuclideanAlgorithm(of: lhs, and: rhs)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x E.E.A
//*============================================================================*

extension NBK.ProperBinaryInteger {
    
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
    /// if !result.isZero, result <= Integer.max {
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
    @frozen public struct GreatestCommonDivisorByEuclideanAlgorithm<X, Y> {
        
        /// The main integer's magnitude type.
        public typealias I = Integer.Magnitude
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var i: ((I))
        @usableFromInline var r: (I,I)
        @usableFromInline var x: (X,X)
        @usableFromInline var y: (Y,Y)
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var iteration: I {
            self.i
        }
        
        @inlinable public var result: I {
            self.r.0
        }
        
        @inlinable public var lhsCoefficient: X {
            self.x.0
        }
        
        @inlinable public var rhsQuotient: X {
            self.x.1
        }
        
        @inlinable public var rhsCoefficient: Y {
            self.y.0
        }
        
        @inlinable public var lhsQuotient: Y {
            self.y.1
        }
    }
}
//=----------------------------------------------------------------------------=
// MARK: + Void, Void
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger.GreatestCommonDivisorByEuclideanAlgorithm where X == Void, Y == Void {
    
    public typealias Magnitude = NBK.ProperBinaryInteger<I>.GreatestCommonDivisorByEuclideanAlgorithm<Void, Void>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: Integer, and rhs: Integer) {
        //=--------------------------------------=
        let unsigned = Magnitude(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        self.i = unsigned.i
        self.r = unsigned.r
    }
    
    @inlinable init(of lhs: Integer, and rhs: Integer) where Integer: NBKUnsignedInteger {
        self.i = (00000000)
        self.r = (lhs, rhs)
        
        reduce: while !(self.r.1.isZero) {
            self.i   += 1 as Integer.Digit
            self.r.0 %= self.r.1
            Swift.swap(&self.r.0, &self.r.1)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer, Void
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger.GreatestCommonDivisorByEuclideanAlgorithm where X == Integer, Y == Void {
    
    public typealias Magnitude = NBK.ProperBinaryInteger<I>.GreatestCommonDivisorByEuclideanAlgorithm<I, Void>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: Integer, and rhs: Integer) {
        //=--------------------------------------=
        let lhsIsLessThanZero = lhs.isLessThanZero
        let rhsIsLessThanZero = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = Magnitude(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        self.i = unsigned.i
        self.r = unsigned.r
        //=--------------------------------------=
        let even = unsigned.iteration.isEven as Bool
        self.x.0 = X(sign: NBK.sign(Integer.isSigned && lhsIsLessThanZero == even), magnitude: unsigned.x.0)!
        self.x.1 = X(sign: NBK.sign(Integer.isSigned && rhsIsLessThanZero    /**/), magnitude: unsigned.x.1)!
    }
    
    @inlinable init(of lhs: Integer, and rhs: Integer) where Integer: NBKUnsignedInteger {
        self.i = (00000000)
        self.r = (lhs, rhs)
        self.x = (001, 000)
        
        reduce: while !self.r.1.isZero {
            let division = self.r.0.quotientAndRemainder(dividingBy: self.r.1)
            self.i += (00000001) as Integer.Digit
            self.r  = (self.r.1, division.remainder)
            self.x  = (self.x.1, division.quotient * self.x.1 + self.x.0)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Void, Integer
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger.GreatestCommonDivisorByEuclideanAlgorithm where X == Void, Y == Integer {
    
    public typealias Magnitude = NBK.ProperBinaryInteger<I>.GreatestCommonDivisorByEuclideanAlgorithm<Void, I>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: Integer, and rhs: Integer) {
        //=--------------------------------------=
        let lhsIsLessThanZero = lhs.isLessThanZero
        let rhsIsLessThanZero = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = Magnitude(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        self.i = unsigned.i
        self.r = unsigned.r
        //=--------------------------------------=
        let even = unsigned.iteration.isEven as Bool
        self.y.0 = Y(sign: NBK.sign(Integer.isSigned && rhsIsLessThanZero != even), magnitude: unsigned.y.0)!
        self.y.1 = Y(sign: NBK.sign(Integer.isSigned && lhsIsLessThanZero    /**/), magnitude: unsigned.y.1)!
    }
    
    @inlinable init(of lhs: Integer, and rhs: Integer) where Integer: NBKUnsignedInteger {
        self.i = (00000000)
        self.r = (lhs, rhs)
        self.y = (000, 001)
        
        reduce: while !self.r.1.isZero {
            let division = self.r.0.quotientAndRemainder(dividingBy: self.r.1)
            self.i += (00000001) as Integer.Digit
            self.r  = (self.r.1, division.remainder)
            self.y  = (self.y.1, division.quotient * self.y.1 + self.y.0)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Integer, Integer
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger.GreatestCommonDivisorByEuclideanAlgorithm where X == Integer, Y == Integer {
    
    public typealias Magnitude = NBK.ProperBinaryInteger<I>.GreatestCommonDivisorByEuclideanAlgorithm<I, I>

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(of lhs: Integer, and rhs: Integer) {
        //=--------------------------------------=
        let lhsIsLessThanZero = lhs.isLessThanZero
        let rhsIsLessThanZero = rhs.isLessThanZero
        //=--------------------------------------=
        let unsigned = Magnitude(of: lhs.magnitude, and: rhs.magnitude)
        //=--------------------------------------=
        self.i = unsigned.i
        self.r = unsigned.r
        //=--------------------------------------=
        let even = unsigned.iteration.isEven as Bool
        self.x.0 = X(sign: NBK.sign(Integer.isSigned && lhsIsLessThanZero == even), magnitude: unsigned.x.0)!
        self.x.1 = X(sign: NBK.sign(Integer.isSigned && rhsIsLessThanZero    /**/), magnitude: unsigned.x.1)!
        self.y.0 = Y(sign: NBK.sign(Integer.isSigned && rhsIsLessThanZero != even), magnitude: unsigned.y.0)!
        self.y.1 = Y(sign: NBK.sign(Integer.isSigned && lhsIsLessThanZero    /**/), magnitude: unsigned.y.1)!
    }
    
    @inlinable init(of lhs: Integer, and rhs: Integer) where Integer: NBKUnsignedInteger {
        self.i = (00000000)
        self.r = (lhs, rhs)
        self.x = (001, 000)
        self.y = (000, 001)
        
        reduce: while !self.r.1.isZero {
            let division = self.r.0.quotientAndRemainder(dividingBy: self.r.1)
            self.i += (00000001) as Integer.Digit
            self.r  = (self.r.1, division.remainder)
            self.x  = (self.x.1, division.quotient * self.x.1 + self.x.0)
            self.y  = (self.y.1, division.quotient * self.y.1 + self.y.0)
        }
    }
}
