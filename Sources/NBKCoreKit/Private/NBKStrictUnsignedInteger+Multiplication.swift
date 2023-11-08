//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the product of `lhs` and `rhs`.
    ///
    /// - Parameter base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    @inlinable public static func initialize<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        if  lhs.count < 20 || rhs.count < 20 {
            return self.initializeByLongAlgorithm(
            &base, to: lhs, times: rhs, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(
            &base, to: lhs, times: rhs)
        }
    }
    
    /// Initializes `base` to the square product of `elements`.
    ///
    /// - Parameter base: A buffer of size `2 * elements.count`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    @inlinable public static func initialize<T>(
    _ base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        if  elements.count < 20 {
            return self.initializeByLongAlgorithm(
            &base, toSquareProductOf: elements, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(
            &base, toSquareProductOf: elements)
        }
    }
}
