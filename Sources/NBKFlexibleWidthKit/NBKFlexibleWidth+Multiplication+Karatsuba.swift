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
// MARK: * NBK x Flexible Width x Multiplication x Karatsuba x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the product of `lhs` and `rhs` using [the Karatsuba algorithm](
    /// https://en.wikipedia.org/wiki/karatsuba_algorithm).
    ///
    ///                high                    low
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * y1        │        x0 * y0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │ (x1 + x0) * (y1 + y0) │
    ///                 ├───────────────────────┤
    ///             sub │        x0 * y0        │
    ///                 ├───────────────────────┤
    ///             sub │        x1 * y1        │
    ///                 └───────────────────────┘
    ///
    @inlinable static func productByKaratsubaAlgorithm(multiplying lhs: UIntXL, by rhs: UIntXL) -> UIntXL {
        let k0 = Swift.max(lhs.count, rhs.count)
        let k1 = k0 &>> 1 &+ k0 & 1
        
        let x0 = k1 < lhs.count ? UIntXL(words: lhs.words.prefix(upTo: k1)) : lhs
        var x1 = k1 < lhs.count ? UIntXL(words: lhs.words.suffix(from: k1)) : UIntXL()
        let y0 = k1 < rhs.count ? UIntXL(words: rhs.words.prefix(upTo: k1)) : rhs
        var y1 = k1 < rhs.count ? UIntXL(words: rhs.words.suffix(from: k1)) : UIntXL()
        
        let z0 = x0 * y0
        let z2 = x1 * y1
        
        x1  += x0
        y1  += y0
        var z1 = x1 * y1
        z1  -= z0
        z1  -= z2
        
        return Self.uninitialized(count: k1 * 4) { product in
        z0.withUnsafeBufferPointer { z0  in
        z1.withUnsafeBufferPointer { z1  in
        z2.withUnsafeBufferPointer { z2  in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            product.initialize(repeating: 0 as UInt)
            //=----------------------------------=
            var index: Int, carry: Bool
            
            index = 0
            carry = false
            
            NBK.SUISS.increment(&product, by: z0, plus: &carry, at: &index)
            
            index = k1 &<< 1
            carry = false
            
            NBK.SUISS.increment(&product, by: z2, plus: &carry, at: &index)
            
            index = k1
            carry = false
            
            NBK.SUISS.increment(&product, by: z1, plus: &carry, at: &index)
        }}}}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Square
    //=------------------------------------------------------------------------=
    
    /// Returns the square product of `base` by using [the Karatsuba algorithm](
    /// https://en.wikipedia.org/wiki/karatsuba_algorithm).
    ///
    ///                high                    low
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * x1        │        x0 * x0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │        x0 * x0        │
    ///                 ├───────────────────────┤
    ///             add │        x1 * x1        │
    ///                 ├───────────────────────┤
    ///             sub │ |x1 - x0| * |x1 - x0| │
    ///                 └───────────────────────┘
    ///
    @inlinable static func productBySquareKaratsubaAlgorithm(multiplying base: UIntXL) -> UIntXL {
        let k1 = base.count &>> 1 &+ base.count & 1
        
        var x0 = UIntXL(words: base.words.prefix(upTo: k1))
        var x1 = UIntXL(words: base.words.suffix(from: k1))
        
        let z0 = x0.squared()
        let z2 = x1.squared()
        
        var z1: Self
        if  x1 >= x0 {
            x1 -= x0
            z1  = x1
        }   else  {
            x0 -= x1
            z1  = x0
        };  z1.square()
        
        return Self.uninitialized(count: k1 * 4) { product in
        z0.withUnsafeBufferPointer { z0  in
        z1.withUnsafeBufferPointer { z1  in
        z2.withUnsafeBufferPointer { z2  in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            product.initialize(repeating: 0 as UInt)
            //=----------------------------------=
            var index: Int, carry: Bool
            
            index = 0
            carry = false
            
            NBK.SUISS.incrementInIntersection(&product, by: z0, plus: &carry, at: &index)
            
            index = k1 &<< 1
            carry = false
            
            NBK.SUISS.incrementInIntersection(&product, by: z2, plus: &carry, at: &index)
            
            index = k1
            carry = false
            
            NBK.SUISS.increment(&product, by: z0, plus: &carry, at: &index)
            
            index = k1
            carry = false
            
            NBK.SUISS.increment(&product, by: z2, plus: &carry, at: &index)
            
            index = k1
            carry = false
            
            NBK.SUISS.decrement(&product, by: z1, plus: &carry, at: &index)
        }}}}
    }
}
