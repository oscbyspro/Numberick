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
// MARK: * NBK x Strict Unsigned Integer x Mul. x Karatsuba x Sub Sequence
//*============================================================================*

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the [Karatsuba algorithm][algorithm] product of `lhs` and `rhs`.
    ///
    ///
    ///            high : z1                low : z0
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * y1        │        x0 * y0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │        x0 * y0        │
    ///                 ├───────────────────────┤
    ///             add │        x1 * y1        │
    ///                 ├───────────────────────┤
    ///             sub │ (x1 - x0) * (y1 - y0) │ : z2
    ///                 └───────────────────────┘
    ///
    ///
    /// - Parameters:
    ///   - base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Note: The `base` must be uninitialized or `pointee` must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    @inline(never) @inlinable public static func initializeByKaratsubaAlgorithm<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == lhs.count + rhs.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let k0c = Swift.max(lhs.count, rhs.count)
        let k1c = k0c &>> 1 &+ k0c & 1
        let k2c = k1c &<< 1
        
        let (x1s, x0s) = NBK.SUISS.partitionTrimmingRedundantZeros(lhs, at: k1c)
        let (y1s, y0s) = NBK.SUISS.partitionTrimmingRedundantZeros(rhs, at: k1c)
        let (z1c, z0c) = (x1s.count + y1s.count, x0s.count + y0s.count)
        
        Swift.withUnsafeTemporaryAllocation(of: Base.Element.self, capacity: 2 * (z0c + z1c)) { buffer in
            var index: Int, carry: Bool, pointer: UnsafeMutablePointer<Base.Element> = buffer.baseAddress!
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            var x0 = NBK.initialize(&pointer, to: x0s)
            var x1 = NBK.initialize(&pointer, to: x1s)
            var y0 = NBK.initialize(&pointer, to: y0s)
            var y1 = NBK.initialize(&pointer, to: y1s)
            var z0 = UnsafeMutableBufferPointer(start: pointer,  count: z0c); pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer,  count: z1c); pointer += z1.count
            Swift.assert(pointer - buffer.baseAddress! == buffer.count)
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            NBK.SUISS.initialize(&z0, to: UnsafeBufferPointer(x0), times: UnsafeBufferPointer(y0))
            NBK.SUISS.initialize(&z1, to: UnsafeBufferPointer(x1), times: UnsafeBufferPointer(y1))
            
            let xs = NBK.SUISS.compare(x1, to: x0).isLessThanZero
            if  xs { 
                Swift.swap(&x0,  &x1)
            }
            
            let ys = NBK.SUISS.compare(y1, to: y0).isLessThanZero
            if  ys { 
                Swift.swap(&y0,  &y1)
            }
            
            index = 000; carry = false
            
            NBK.SUISS.decrement(&x1,  by: UnsafeBufferPointer(x0), plus: &carry, at: &index)
            
            index = 000; carry = false
            
            NBK.SUISS.decrement(&y1,  by: UnsafeBufferPointer(y0), plus: &carry, at: &index)
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0.isZero }))
            z1 = UnsafeMutableBufferPointer(start: z1.baseAddress!, count: base.count - k2c)
            //=----------------------------------=
            // pointee: initialization 3
            //=----------------------------------=
            pointer = base.baseAddress!
            
            for element in z0 {
                pointer.initialize(to: element)
                pointer =  pointer.successor()
            }
            
            for _ in z0.count ..< k2c {
                pointer.initialize(to: 000000)
                pointer =  pointer.successor()
            }
            
            for element in z1 {
                pointer.initialize(to: element)
                pointer =  pointer.successor()
            }
            
            Swift.assert(base.baseAddress!.distance(to: pointer) == base.count)
            //=----------------------------------=
            index = k1c; carry = false
            
            NBK.SUISS.increment(&base, by: UnsafeBufferPointer(z0), plus: &carry, at: &index)
            
            index = k1c; carry = false
            
            NBK.SUISS.increment(&base, by: UnsafeBufferPointer(z1), plus: &carry, at: &index)
            
            index = k1c; carry = false
            
            z2: do { // reuse z0 and z1 memory to form z2
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!, count: x1.count + y1.count)
                NBK.SUISS.initialize(&z0,  to: UnsafeBufferPointer(x1), times: UnsafeBufferPointer(y1))
                switch xs == ys {
                case  true: NBK.SUISS.decrement(&base, by: UnsafeBufferPointer(z0), plus: &carry, at: &index)
                case false: NBK.SUISS.increment(&base, by: UnsafeBufferPointer(z0), plus: &carry, at: &index) }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Square
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the [square Karatsuba algorithm][algorithm] product of `lhs` and `rhs`.
    ///
    ///
    ///            high : z1                low : z0
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * x1        │        x0 * x0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │        x0 * x0        │
    ///                 ├───────────────────────┤
    ///             add │        x1 * x1        │
    ///                 ├───────────────────────┤
    ///             sub │ |x1 - x0| * |x1 - x0| │ : z2
    ///                 └───────────────────────┘
    ///
    ///
    /// - Parameters:
    ///   - base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Note: The `base` must be uninitialized or `pointee` must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    /// ### Development
    ///
    @inline(never) @inlinable public static func initializeByKaratsubaAlgorithm<T>(
    _ base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>) where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == 2 * elements.count)
        //=--------------------------------------=
        let k0c = elements.count
        let k1c = k0c &>> 1 &+ k0c & 1
        let k2c = k1c &<< 1
        
        let (x1s, x0s) = NBK.SUISS.partitionTrimmingRedundantZeros(elements, at: k1c)
        let (z1c, z0c) = (2 * x1s.count, 2 * x0s.count)
        
        Swift.withUnsafeTemporaryAllocation(of: Base.Element.self, capacity: 3 * (x0s.count + x1s.count)) { buffer in
            var index: Int, carry: Bool, pointer: UnsafeMutablePointer<Base.Element> = buffer.baseAddress!
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            var x0 = NBK.initialize(&pointer, to: x0s)
            var x1 = NBK.initialize(&pointer, to: x1s)
            var z0 = UnsafeMutableBufferPointer(start: pointer,  count: z0c); pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer,  count: z1c); pointer += z1.count
            Swift.assert(pointer - buffer.baseAddress! == buffer.count)
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            NBK.SUISS.initialize(&z0, toSquareProductOf: UnsafeBufferPointer(x0))
            NBK.SUISS.initialize(&z1, toSquareProductOf: UnsafeBufferPointer(x1))
            
            if  NBK.SUISS.compare(UnsafeBufferPointer(x1), to: UnsafeBufferPointer(x0)).isLessThanZero {
                Swift.swap(&x0,  &x1)
            }
            
            index = 000; carry = false
            
            NBK.SUISS.decrement(&(x1), by: UnsafeBufferPointer(x0), plus: &carry, at: &index)
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0.isZero }))
            z1 = UnsafeMutableBufferPointer(start: z1.baseAddress!, count: base.count - k2c)
            //=----------------------------------=
            // pointee: initialization 3
            //=----------------------------------=
            pointer = base.baseAddress!
            
            for element in z0 {
                pointer.initialize(to: element)
                pointer =  pointer.successor()
            }
            
            for _ in z0.count ..< k2c {
                pointer.initialize(to: 000000)
                pointer =  pointer.successor()
            }
                        
            for element in z1 {
                pointer.initialize(to: element)
                pointer =  pointer.successor()
            }
            
            Swift.assert(base.baseAddress!.distance(to: pointer) == base.count)
            //=----------------------------------=
            index = k1c; carry = false
            
            NBK.SUISS.increment(&base, by: UnsafeBufferPointer(z0), plus: &carry, at: &index)
            
            index = k1c; carry = false
            
            NBK.SUISS.increment(&base, by: UnsafeBufferPointer(z1), plus: &carry, at: &index)
            
            index = k1c; carry = false
            
            z2: do { // reuse z0 and z1 memory to form z2
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!, count: x1.count &<< 1)
                NBK.SUISS.initialize(&z0,  toSquareProductOf: UnsafeBufferPointer(x1))
                NBK.SUISS.decrement(&base, by: UnsafeBufferPointer(z0), plus: &carry, at: &index)
            }
        }
    }
}
