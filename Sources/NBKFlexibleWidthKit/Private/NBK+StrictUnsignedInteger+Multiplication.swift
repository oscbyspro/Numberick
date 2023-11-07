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
    /// - Parameters:
    ///   - base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Note: The `base` memory must be uninitialized or the pointee must be a trivial type.
    ///
    @inlinable static func initialize<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        if  lhs.count < 20 || rhs.count < 20 {
            return self.initializeByLongAlgorithm(&base, to: lhs, times: rhs, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(&base, to: lhs, times: rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Square
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the square product of `elements`.
    ///
    /// - Parameters:
    ///   - base: A buffer of size `2 * elements.count`.
    ///
    /// - Note: The `base` memory must be uninitialized or the pointee must be a trivial type.
    ///
    @inlinable static func initialize<T>(
    _ base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        if  elements.count < 20 {
            return self.initializeByLongAlgorithm(&base, toSquareProductOf: elements, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(&base, toSquareProductOf: elements)
        }
    }
}
