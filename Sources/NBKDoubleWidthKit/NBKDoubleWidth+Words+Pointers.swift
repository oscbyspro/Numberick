//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Words x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Trivial UInt Collection
    //=------------------------------------------------------------------------=
    
    @inlinable public func withContiguousStorageIfAvailable<T>(
    _ body: (UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T? {
        var base = self
        #if _endian(big)
        base.reverse()
        #endif
        return try base.withUnsafeUIntBufferPointer(body)
    }
    
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<T>(
    _ body: (inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T? {
        #if _endian(big)
        do    { self.reverse() }
        defer { self.reverse() }
        #endif
        return try self.withUnsafeMutableUIntBufferPointer(body)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Trivial UInt Collection x Private
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable internal func withUnsafeUIntPointer<T>(
    _ body: (UnsafePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafePointer(to: self) { start in
            try start.withMemoryRebound(to: UInt.self, capacity: Self.count, body)
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable internal func withUnsafeUIntBufferPointer<T>(
    _ body: (UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T {
        try self.withUnsafeUIntPointer { start in
            try body(UnsafeBufferPointer(start: start, count: Self.count))
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable internal mutating func withUnsafeMutableUIntPointer<T>(
    _ body: (UnsafeMutablePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafeMutablePointer(to: &self) { start in
            try start.withMemoryRebound(to: UInt.self, capacity: Self.count, body)
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable internal mutating func withUnsafeMutableUIntBufferPointer<T>(
    _ body: (inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T {
        try self.withUnsafeMutableUIntPointer { start in
            var buffer = UnsafeMutableBufferPointer<UInt>(start: start, count: Self.count)
            return try body(&buffer)
        }
    }
}
