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
// MARK: * NBK x Double Width x Uninitialized
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    // NOTE: Wrapped function call fixes Swift 5.7 performance problem.
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to uninitialized words.
    ///
    /// ```swift
    /// let value = Int256.uninitialized { words in
    ///     for index in words.indices {
    ///         words.base.initializeElement(at: words.baseIndex(index), to: UInt.zero)
    ///     }
    /// }
    /// ```
    ///
    @inlinable public static func uninitialized(_ body: (NBKLittleEndianOrdered<NBK.UnsafeMutableWords>) -> Void) -> Self {
        Self(bitPattern: BitPattern.uninitialized(body))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Uninitialized x Uninitialized
//*============================================================================*

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to uninitialized words.
    ///
    /// ```swift
    /// let value = Int256.uninitialized { words in
    ///     for index in words.indices {
    ///         words.base.initializeElement(at: words.baseIndex(index), to: UInt.zero)
    ///     }
    /// }
    /// ```
    ///
    @inlinable static func uninitialized(_ body: (NBKLittleEndianOrdered<NBK.UnsafeMutableWords>) -> Void) -> Self {
        Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress.unsafelyUnwrapped
            //=----------------------------------=
            // pointee: initialization by callee
            //=----------------------------------=
            pointer.withMemoryRebound(to: UInt.self, capacity: Self.count) { start in
                body(NBKLittleEndianOrdered(NBK.UnsafeMutableWords(start: start, count: Self.count)))
            }
            //=----------------------------------=
            // pointee: deinitialization by move
            //=----------------------------------=
            return pointer.move()
        }
    }
}
