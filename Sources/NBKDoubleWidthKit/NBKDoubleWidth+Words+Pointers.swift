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
// MARK: * NBK x Double Width x Words x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Contiguous UInt Collection
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the collection's contiguous storage.
    ///
    /// The elements of the contiguous storage appear in the order of the collection.
    ///
    @inlinable public func withContiguousStorage<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T {
        var base = self; return try Swift.withUnsafeMutablePointer(to: &base) { value in
            try value.withMemoryRebound(to: UInt.self, capacity:  Self.count) { start in
                var words = UnsafeMutableBufferPointer(start: start, count: Self.count)
                #if _endian(big)
                words.reverse()
                #endif
                return try body(UnsafeBufferPointer(words))
            }
        }
    }
        
    /// Grants unsafe access to the collection's contiguous storage.
    ///
    /// The elements of the contiguous storage appear in the order of the collection.
    ///
    /// - Note: This member is required by `Swift.Sequence`.
    ///
    @inlinable public func withContiguousStorageIfAvailable<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T? {
        try self.withContiguousStorage(body)
    }
    
    /// Grants unsafe access to the collection's contiguous mutable storage.
    ///
    /// The elements of the contiguous mutable storage appear in the order of the collection.
    ///
    @inlinable public mutating func withContiguousMutableStorage<T>(_ body: (inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T {
        try Swift.withUnsafeMutablePointer(to:  &self) { value in
            try value.withMemoryRebound(to: UInt.self, capacity: Self.count) { start in
                var words = UnsafeMutableBufferPointer(start: start, count: Self.count)
                #if _endian(big)
                do    { words.reverse() }
                defer { words.reverse() }
                #endif
                return try body(&words)
            }
        }
    }
    
    /// Grants unsafe access to the collection's contiguous mutable storage.
    ///
    /// The elements of the contiguous mutable storage appear in the order of the collection.
    ///
    /// - Note: This member is required by `Swift.MutableCollection`.
    ///
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<T>(_ body: (inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T? {
        try self.withContiguousMutableStorage(body)
    }
}
