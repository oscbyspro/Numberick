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
// MARK: * NBK x Double Width x Data
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    // NOTE: Wrapped function call fixes Swift 5.7 performance problem.
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized memory.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable static func uninitialized<T: NBKCoreInteger>(
    as type: T.Type, init body: (UnsafeMutableBufferPointer<T>) ->  Void) -> Self {
        Self(bitPattern: BitPattern.uninitialized(as: T.self, init: body))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the in-memory representation of this value.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable func withUnsafeData<T: NBKCoreInteger, R>(
    as type: T.Type, perform body: (UnsafeBufferPointer<T>) throws -> R) rethrows -> R {
        try Swift.withUnsafePointer(to: self) { base in
            try base.withMemoryRebound(to: T.self, capacity: BitPattern.count(T.self)) { start in
                let data = UnsafeBufferPointer(start: start, count: BitPattern.count(T.self))
                return try body(data)
            }
        }
    }
    
    /// Grants unsafe access to the in-memory representation of this value.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable mutating func withUnsafeMutableData<T: NBKCoreInteger, R>(
    as type: T.Type, perform body: (inout UnsafeMutableBufferPointer< T>) throws -> R) rethrows -> R {
        try Swift.withUnsafeMutablePointer(to: &self) { base in
            try base.withMemoryRebound(to: T.self, capacity: BitPattern.count(T.self)) { start in
                var data = UnsafeMutableBufferPointer(start: start, count: BitPattern.count(T.self))
                return try body(&data)
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Data x Unsigned
//*============================================================================*

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized memory.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable static func uninitialized<T: NBKCoreInteger>(
    as type: T.Type, init body: (UnsafeMutableBufferPointer<T>) -> Void) -> Self {
        Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress.unsafelyUnwrapped
            //=----------------------------------=
            // pointee: initialization by callee
            //=----------------------------------=
            pointer.withMemoryRebound(to: T.self, capacity: BitPattern.count(T.self)) { start in
                body(UnsafeMutableBufferPointer(start: start, count: BitPattern.count(T.self)))
            }
            //=----------------------------------=
            // pointee: deinitialization by move
            //=----------------------------------=
            return pointer.move()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// Counts the number of elements that fit in this type.
    ///
    /// The size of this type is an integer multiple of every core integer size.
    /// The smallest component is Int and it is at least half the size of Int64,
    /// so this double-width integer type can fit at least one Int64.
    ///
    @inlinable static func count<T>(_ type: T.Type) -> Int where T: NBKCoreInteger {
        assert(MemoryLayout<BitPattern>.size / MemoryLayout<T>.stride >= 1)
        assert(MemoryLayout<BitPattern>.size % MemoryLayout<T>.stride == 0)
        return MemoryLayout<BitPattern>.size / MemoryLayout<T>.stride
    }
    
    /// Returns the in-memory byte offset of the element at the given index.
    ///
    /// - Note: This operation is unchecked.
    ///
    @inlinable static func endiannessSensitiveByteOffset<T>(of type: T.Type, at index: Int) -> Int where T: NBKCoreInteger {
        assert(0 <= index && index < BitPattern.count(T.BitPattern.self))
        #if _endian(big)
        return MemoryLayout<T>.stride * ~index + MemoryLayout<BitPattern>.size
        #else
        return MemoryLayout<T>.stride * (index)
        #endif
    }
}
