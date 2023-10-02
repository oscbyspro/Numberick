//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Words
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the given element as a strict binary integer.
    @inlinable public static func withUnsafeBufferPointer<T, U>(
    to  element: T, perform body: (Base) throws -> U) rethrows -> U where Base == UnsafeBufferPointer<T> {
        try Swift.withUnsafePointer(to: element) {
            try body(Base(start: $0, count: 1 as Int))
        }
    }
}
