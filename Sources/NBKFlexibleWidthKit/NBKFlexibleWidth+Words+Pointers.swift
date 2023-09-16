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
// MARK: * NBK x Flexible Width x Words x Pointers x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
 
    //=------------------------------------------------------------------------=
    // MARK: Details x Contiguous UInt Collection
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the collection's contiguous storage.
    @inlinable public func withUnsafeBufferPointer<T>(
    _   body:(NBK.UnsafeWords) throws -> T) rethrows -> T {
        try self.storage.withUnsafeBufferPointer(body)
    }
    
    /// Grants unsafe access to the collection's contiguous mutable storage.
    @inlinable public mutating func withUnsafeMutableBufferPointer<T>(
    _   body:(inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T {
        defer{     self.storage.normalize() }
        return try self.storage.withUnsafeMutableBufferPointer(body)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Pointers x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Contiguous UInt Collection
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the collection's contiguous storage.
    @inlinable func withUnsafeBufferPointer<T>(
    _   body:(NBK.UnsafeWords) throws -> T) rethrows -> T {
        try self.elements.withUnsafeBufferPointer(body)
    }
    
    /// Grants unsafe access to the collection's contiguous mutable storage.
    @inlinable mutating func withUnsafeMutableBufferPointer<T>(
    _   body:(inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T {
        try self.elements.withUnsafeMutableBufferPointer(body)
    }
}
