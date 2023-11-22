//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Roots x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the integer `square root` of `power` by using [this algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/newton%27s_method
    ///
    /// - Parameter power: A value in `Integer.zero ... Integer.max`.
    ///
    @inlinable public static func squareRootByNewtonsMethod(of power: Integer) -> Integer {
        precondition(!power.isLessThanZero, NBK.callsiteOutOfBoundsInfo())
        return Integer(magnitude: Magnitude.squareRootByNewtonsMethod(of: power.magnitude))!
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Roots x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the integer `square root` of `power` by using [this algorithm][algorithm].
    /// 
    /// [algorithm]: https://en.wikipedia.org/wiki/newton%27s_method
    ///
    /// - Parameter power: A value in `Integer.zero ... Integer.max`.
    ///
    /// ### Development
    /// 
    /// - TODO: Consider `update(_:)` when NBKBinaryInteger gets it.
    /// - TODO: Consider `bitShift[...](by:)` when NBKBinaryInteger gets it.
    /// 
    @inlinable public static func squareRootByNewtonsMethod(of power: Integer) -> Integer {
        //=--------------------------------------=
        if  power.isZero {
            return power
        }
        //=--------------------------------------=
        var guess: (Integer,Integer)
        guess.0 =  Integer(digit: 1) << ((power.bitWidth &- power.leadingZeroBitCount) &>> 1 &+ 1)
        //=--------------------------------------=
        repeat {
            
            guess.1   = guess.0
            guess.0   = power
            guess.0  /= guess.1
            guess.0  += guess.1
            guess.0 >>= Int.one
            
        } while guess.0 < guess.1
        return (guess.1)
    }
}
