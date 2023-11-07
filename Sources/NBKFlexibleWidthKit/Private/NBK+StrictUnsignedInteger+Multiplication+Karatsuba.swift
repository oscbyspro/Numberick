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
    /// - Parameter base: A buffer of size `lhs.count` + `rhs.count`.
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
        let k1c = k0c &>> 1
        let k2c = k1c &<< 1
        
        let (x1s, x0s) = NBK.SUISS.partitionTrimmingRedundantZeros(lhs, at: k1c)
        let (y1s, y0s) = NBK.SUISS.partitionTrimmingRedundantZeros(rhs, at: k1c)
        let (z1c, z0c) = (x1s.count + y1s.count, x0s.count + y0s.count)
        
        let count = 2  * (z0c + z1c) as Int
        Swift.withUnsafeTemporaryAllocation(of: Base.Element.self, capacity: count) { buffer in
            var pointer: UnsafeMutablePointer<Base.Element>
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.baseAddress!.deinitialize(count: count)
            }
            //=----------------------------------=
            // temporary memory regions
            //=----------------------------------=
            pointer  = buffer.baseAddress! as UnsafeMutablePointer<Base.Element>
            var x0 = UnsafeMutableBufferPointer(start: pointer, count: x0s.count); pointer += x0.count
            var x1 = UnsafeMutableBufferPointer(start: pointer, count: x1s.count); pointer += x1.count
            var y0 = UnsafeMutableBufferPointer(start: pointer, count: y0s.count); pointer += y0.count
            var y1 = UnsafeMutableBufferPointer(start: pointer, count: y1s.count); pointer += y1.count
            var z0 = UnsafeMutableBufferPointer(start: pointer, count: z0c);       pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer, count: z1c);       pointer += z1.count
            Swift.assert(buffer.baseAddress!.distance(to: pointer) == count)
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            x0.baseAddress!.initialize(from: x0s.baseAddress!, count: x0s.count)
            x1.baseAddress!.initialize(from: x1s.baseAddress!, count: x1s.count)
            y0.baseAddress!.initialize(from: y0s.baseAddress!, count: y0s.count)
            y1.baseAddress!.initialize(from: y1s.baseAddress!, count: y1s.count)
            
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
            
            NBK.SUISS.decrement( &x1, by: UnsafeBufferPointer(x0))
            NBK.SUISS.decrement( &y1, by: UnsafeBufferPointer(y0))
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0.isZero }))
            z1 = UnsafeMutableBufferPointer(rebasing: z1.prefix(base[k2c...].count))
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            pointer  = base.baseAddress! as  UnsafeMutablePointer<Base.Element>
            pointer += NBK.initializeGetCount(pointer, to: UnsafeBufferPointer(z0))
            pointer += NBK.initializeGetCount(pointer, repeating: Base.Element.zero, count: k2c - z0.count)
            pointer += NBK.initializeGetCount(pointer, to: UnsafeBufferPointer(z1))
            pointer += NBK.initializeGetCount(pointer, repeating: Base.Element.zero, count: base.count - (k2c + z1.count))
            Swift.assert(base.baseAddress!.distance(to: pointer) == base.count)
            //=----------------------------------=
            var slice = UnsafeMutableBufferPointer(rebasing: base.suffix(from: k1c))
            
            NBK.SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
            NBK.SUISS.increment(&slice, by: UnsafeBufferPointer(z1))
            
            z2: do { // reuse z0 and z1 memory to form z2
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!,  count: x1.count + y1.count)
                NBK.SUISS.initialize(&(z0), to: UnsafeBufferPointer(x1), times: UnsafeBufferPointer(y1))
            };  if xs == ys {
                NBK.SUISS.decrement(&slice, by: UnsafeBufferPointer(z0))
            }   else {
                NBK.SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
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
    ///             sub │ (x1 - x0) * (x1 - x0) │ : z2
    ///                 └───────────────────────┘
    ///
    ///
    /// - Parameter base: A buffer of size `lhs.count` + `rhs.count`.
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
        Swift.assert(base.count == 2 * elements.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let k0c = elements.count
        let k1c = k0c &>> 1
        let k2c = k1c &<< 1
        
        let (x1s, x0s) = NBK.SUISS.partitionTrimmingRedundantZeros(elements, at: k1c)
        let (z1c, z0c) = (2 * x1s.count, 2 * x0s.count)
        
        let count = 3  * (x1s.count + x0s.count) as Int
        Swift.withUnsafeTemporaryAllocation(of: Base.Element.self, capacity: count) { buffer in
            var pointer: UnsafeMutablePointer<Base.Element>
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.baseAddress!.deinitialize(count: count)
            }
            //=----------------------------------=
            // temporary memory regions
            //=----------------------------------=
            pointer  = buffer.baseAddress! as UnsafeMutablePointer<Base.Element>
            var x0 = UnsafeMutableBufferPointer(start: pointer, count: x0s.count); pointer += x0.count
            var x1 = UnsafeMutableBufferPointer(start: pointer, count: x1s.count); pointer += x1.count
            var z0 = UnsafeMutableBufferPointer(start: pointer, count: z0c);       pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer, count: z1c);       pointer += z1.count
            Swift.assert(buffer.baseAddress!.distance(to: pointer) == count)
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            x0.baseAddress!.initialize(from: x0s.baseAddress!, count: x0s.count)
            x1.baseAddress!.initialize(from: x1s.baseAddress!, count: x1s.count)
            
            NBK.SUISS.initialize(&z0, toSquareProductOf: UnsafeBufferPointer(x0))
            NBK.SUISS.initialize(&z1, toSquareProductOf: UnsafeBufferPointer(x1))
            
            if  NBK.SUISS.compare(x1, to: x0).isLessThanZero {
                Swift.swap(&x0,  &x1)
            }
            
            NBK.SUISS.decrement( &x1, by: UnsafeBufferPointer(x0))
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0.isZero }))
            z1 = UnsafeMutableBufferPointer(rebasing: z1.prefix(base[k2c...].count))
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            pointer  = base.baseAddress! as  UnsafeMutablePointer<Base.Element>
            pointer += NBK.initializeGetCount(pointer, to: UnsafeBufferPointer(z0))
            pointer += NBK.initializeGetCount(pointer, repeating: Base.Element.zero, count: k2c - z0.count)
            pointer += NBK.initializeGetCount(pointer, to: UnsafeBufferPointer(z1))
            pointer += NBK.initializeGetCount(pointer, repeating: Base.Element.zero, count: base.count - (k2c + z1.count))
            Swift.assert(base.baseAddress!.distance(to: pointer) == base.count)
            //=----------------------------------=
            var slice = UnsafeMutableBufferPointer(rebasing: base.suffix(from: k1c))
            NBK.SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
            NBK.SUISS.increment(&slice, by: UnsafeBufferPointer(z1))
            
            z2: do { // reuse z0 and z1 memory to form z2
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!, count: x1.count &<< 1)
                NBK.SUISS.initialize(&(z0), toSquareProductOf: UnsafeBufferPointer(x1))
                NBK.SUISS.decrement(&slice, by:/*-----------*/ UnsafeBufferPointer(z0))
            }
        }
    }
}
