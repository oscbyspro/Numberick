//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Flexible Width x Fibonacci x Unsigned
//*============================================================================*
 
extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the Fibonacci sequence pair at `index`.
    ///
    /// ```swift
    /// UIntXL.fibonacci(0) // (element: 0, next: 1)
    /// UIntXL.fibonacci(1) // (element: 1, next: 1)
    /// UIntXL.fibonacci(2) // (element: 1, next: 2)
    /// UIntXL.fibonacci(3) // (element: 2, next: 3)
    /// UIntXL.fibonacci(4) // (element: 3, next: 5)
    /// UIntXL.fibonacci(5) // (element: 5, next: 8)
    /// ```
    /// 
    /// - Parameter index: A value greater than zero.
    ///
    public static func fibonacci(_ index: Int) -> (element: Self, next: Self) {
        //=--------------------------------------=
        // f(2x + 0) = f(x) * [2 * f(x + 1) - f(x)]
        // f(2x + 1) = f(x) ^  2 + f(x + 1) ^ 2
        //=--------------------------------------=
        precondition(index >= Int.zero)
        //=--------------------------------------=
        var a: Self = Self(digit: 0)
        var b: Self = Self(digit: 1)
        //=--------------------------------------=
        for bitIndex in (0 ..< Int.bitWidth - index.leadingZeroBitCount).reversed() {
            
            var (x): Self // f(2x + 0)
            x  = b.bitShiftedLeft(major: Int.zero, minor: Int.one)
            x -= a
            x *= a
            
            var (y): Self // f(2x + 1)
            y  = a.squared()
            y += b.squared()
            
            if  (index &>> bitIndex).isOdd {
                x += y
                a  = y
                b  = x
            }   else {
                a  = x
                b  = y
            }
        }
        
        return (element: a as Self, next: b as Self)
    }
}
