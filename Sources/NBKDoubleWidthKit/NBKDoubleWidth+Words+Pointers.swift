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
    // MARK: Details x Trivial UInt Collection
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the collection's contiguous storage.
    ///
    /// The elements of the contiguous storage appear in the order of the collection.
    ///
    @inlinable public func withContiguousStorage<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T {
        var base = self
        #if _endian(big)
        base.reverse()
        #endif
        return try base.withUnsafeUIntBufferPointer(body)
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
        #if _endian(big)
        do    { self.reverse() }
        defer { self.reverse() }
        #endif
        return try self.withUnsafeMutableUIntBufferPointer(body)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Trivial UInt Collection x Private
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable func withUnsafeUIntPointer<T>(_ body: (UnsafePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafePointer(to: self, { try $0.withMemoryRebound(to: UInt.self, capacity: Self.count, body) })
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable func withUnsafeUIntBufferPointer<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T {
        try self.withUnsafeUIntPointer({ try body(UnsafeBufferPointer(start: $0, count: Self.count)) })
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable mutating func withUnsafeMutableUIntPointer<T>(_ body: (UnsafeMutablePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafeMutablePointer(to: &self, { try $0.withMemoryRebound(to: UInt.self, capacity: Self.count, body) })
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable mutating func withUnsafeMutableUIntBufferPointer<T>(_ body: (inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T {
        try self.withUnsafeMutableUIntPointer({ var x = UnsafeMutableBufferPointer(start: $0, count: Self.count); return try body(&x) })
    }
}
