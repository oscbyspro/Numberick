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

/// The [Fibonacci sequence](https://en.wikipedia.org/wiki/fibonacci_sequence)\.
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
    
    /// Creates the first sequence pair.
    @inlinable public init() {
        self.i = UInt()
        self.a = UIntXL(digit: 0)
        self.b = UIntXL(digit: 1)
    }
    
    /// Creates the sequence pair at the given `index`.
    @inlinable public init(_ index: UInt) {
        self.init()
        var mask = UInt.one &<< UInt(bitPattern: index.bitWidth &+ index.leadingZeroBitCount.onesComplement())
        doubleAndAdd: while !mask.isZero {
            self.double()
            
            if !(index & mask).isZero {
                self.increment()
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
    
    /// Forms the sequence pair at `index + 1`.
    @inlinable public mutating func increment() {
        i += 1
        a += b
        Swift.swap(&a, &b)
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() {
        i -= 1
        b -= a
        Swift.swap(&a, &b)
    }
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() {
        var (x): UIntXL // f(2x + 0)
        x  = b.bitShiftedLeft(major: Int.zero, minor: Int.one)
        x -= a
        x *= a
        
        var (y): UIntXL // f(2x + 1)
        y  = a.squared()
        y += b.squared()
        
        i *= 2
        a  = x
        b  = y
    }
}
