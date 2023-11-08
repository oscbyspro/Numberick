//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Mul. x Long x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the [long][algorithm] product of `lhs` and `rhs` plus `addend`.
    ///
    /// - Parameter base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public static func initializeByLongAlgorithm<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>,
    plus addend: Base.Element = .zero) where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == lhs.count + rhs.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        var pointer = base.baseAddress!
        //=--------------------------------------=
        // pointee: initialization 1
        //=--------------------------------------=
        var carry: Base.Element = addend
        let first: Base.Element = rhs.first ?? Base.Element.zero
        
        for element in lhs {
            var wide = element.multipliedFullWidth(by: first)
            carry = Base.Element(bit: wide.low.addReportingOverflow(carry)) &+ wide.high
            pointer.initialize(to: wide.low) // done, uninitialized or discarded pointee
            pointer = pointer.successor()
        }
        
        if !rhs.isEmpty {
            pointer.initialize(to: carry)
            pointer = pointer.successor()
        }
        
        Swift.assert(base.baseAddress!.distance(to: pointer) == lhs.count + Int(bit: !rhs.isEmpty))
        //=--------------------------------------=
        // pointee: initialization 2
        //=--------------------------------------=
        for var index in rhs.indices.dropFirst() {
            pointer.initialize(to: 00000)
            pointer = pointer.successor()
            NBK.SUISS.incrementInIntersection(&base, by: lhs, times: rhs[index], plus: Base.Element.zero, at: &index)
        }
        
        Swift.assert(base.baseAddress!.distance(to: pointer) == base.count)
    }
    
    /// Initializes `base` to the square [long][algorithm] product of `elements` plus `addend`.
    ///
    /// - Parameter base: A buffer of size `2 * elements`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public static func initializeByLongAlgorithm<T>(
    _ base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>, plus addend: Base.Element = .zero)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == 2 * elements.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        // pointee: initialization
        //=--------------------------------------=
        base.initialize(repeating: 0 as Base.Element)
        //=--------------------------------------=
        var index: Int
        var carry: Base.Element = addend
        //=--------------------------------------=
        var baseIndex = elements.startIndex; while baseIndex < elements.endIndex {
            let multiplier = elements[ baseIndex]
            let productIndex = 2 * baseIndex
            elements.formIndex(after: &baseIndex)
            
            index = productIndex + 1 // add non-diagonal products
            
            NBK.SUISS.incrementInIntersection(
            &base, by: UnsafeBufferPointer(rebasing: elements[baseIndex...]), 
            times: multiplier, plus: Base.Element.zero, at: &index)
            
            index = productIndex // partially double non-diagonal products
            
            NBK.SUISS.multiply(&base, by: 2, add: &carry, from: &index, to: productIndex + 2)
            
            index = productIndex // add this iteration's diagonal product
            
            carry  &+= Base.Element(bit: NBK.SUISS.incrementInIntersection(
            &base, by: CollectionOfOne(multiplier),
            times: multiplier, plus: Base.Element.zero, at: &index))
        }
    }
}
