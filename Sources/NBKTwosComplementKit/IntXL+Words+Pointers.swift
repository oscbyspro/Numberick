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
// MARK: * NBK x Flexible Width x Words x Pointers
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the collection's contiguous storage.
    @inlinable public func withUnsafeBufferPointer<T>(
    _   body:(UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T {
        try self.storage.elements.withUnsafeBufferPointer(body)
    }
    
    /// Grants unsafe access to the collection's contiguous mutable storage.
    @inlinable public mutating func withUnsafeMutableBufferPointer<T>(
    _   body:(inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T {
        defer{ Self.normalize(&self.storage) }
        return try self.storage.elements.withUnsafeMutableBufferPointer(body)
    }
}
