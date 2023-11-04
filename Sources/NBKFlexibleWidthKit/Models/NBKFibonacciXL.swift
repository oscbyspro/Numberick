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
// MARK: * NBK x FibonacciXL
//*============================================================================*

/// The [Fibonacci sequence](https://en.wikipedia.org/wiki/fibonacci_sequence).
///
/// It is represented by an index and two consecutive elements.
///
/// ```swift
/// NBKFibonacciXL(0) // (index: 0, element: 0, next: 1)
/// NBKFibonacciXL(1) // (index: 1, element: 1, next: 1)
/// NBKFibonacciXL(2) // (index: 2, element: 1, next: 2)
/// NBKFibonacciXL(3) // (index: 3, element: 2, next: 3)
/// NBKFibonacciXL(4) // (index: 4, element: 3, next: 5)
/// NBKFibonacciXL(5) // (index: 5, element: 5, next: 8)
/// ```
///
/// ### Development
///
/// Sequences like these are useful for testing large integer values.
///
@frozen public struct NBKFibonacciXL {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var i: UInt
    @usableFromInline var a: UIntXL
    @usableFromInline var b: UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the start sequence.
    ///
    /// ```
    /// (index: 0, element: 0, next: 1)
    /// ```
    ///
    @inlinable public init() {
        self.i = UInt()
        self.a = UIntXL(digit: 0)
        self.b = UIntXL(digit: 1)
    }
    
    /// Returns the sequence at the given `index`.
    ///
    /// ```swift
    /// UIntXL.Fibonacci(0) // (index: 0, element: 0, next: 1)
    /// UIntXL.Fibonacci(1) // (index: 1, element: 1, next: 1)
    /// UIntXL.Fibonacci(2) // (index: 2, element: 1, next: 2)
    /// UIntXL.Fibonacci(3) // (index: 3, element: 2, next: 3)
    /// UIntXL.Fibonacci(4) // (index: 4, element: 3, next: 5)
    /// UIntXL.Fibonacci(5) // (index: 5, element: 5, next: 8)
    /// ```
    ///
    @inlinable public init(_ index: UInt) {
        self.i = index as UInt
        self.a = UIntXL(digit: 0)
        self.b = UIntXL(digit: 1)
        
        var mask = UInt.one &<< (index.bitWidth &+ index.leadingZeroBitCount.onesComplement())
        doubleAndAdd: while !mask.isZero {
            
            var (x): UIntXL // f(2x + 0)
            x  = b.bitShiftedLeft(major: Int.zero, minor: Int.one)
            x -= a
            x *= a
            
            var (y): UIntXL // f(2x + 1)
            y  = a.squared()
            y += b.squared()
            
            if  (index & mask).isZero {
                a  = x
                b  = y
            }   else {
                x += y
                a  = y
                b  = x
            }
            
            mask &>>= UInt.one
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The sequence `index`.
    @inlinable public var index: UInt {
        self.i
    }
    
    /// The sequence `element` at `index`.
    @inlinable public var element: UIntXL {
        self.a
    }
    
    /// The sequence `element` at `index + 1`.
    @inlinable public var next: UIntXL {
        self.b
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sequence pair before this instance.
    public mutating func decrement() {
        self.i -= 1
        self.b -= a
        Swift.swap(&a, &b)
    }
    
    /// Forms the sequence pair after this instance.
    public mutating func increment() {
        self.i += 1
        self.a += b
        Swift.swap(&a, &b)
    }
}
