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
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the in-memory representation of this value.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable func withUnsafeData<T: NBKCoreInteger, U>(
    as type: T.Type, perform body: (UnsafeBufferPointer<T>) throws -> U) rethrows -> U {
        //=--------------------------------------=
        assert(MemoryLayout<Self>.size / MemoryLayout<T>.stride >= 1)
        assert(MemoryLayout<Self>.size % MemoryLayout<T>.stride == 0)
        //=--------------------------------------=
        return try Swift.withUnsafePointer(to: self) { base in
            let count = MemoryLayout<Self>.size / MemoryLayout<T>.stride
            return try base.withMemoryRebound(to: T.self, capacity: count) { start in
                let data = UnsafeBufferPointer(start: start, count: count)
                return try body(data)
            }
        }
    }
    
    /// Grants unsafe access to the in-memory representation of this value.
    ///
    /// - Note: The bytes of this integer are ordered by system endianness.
    ///
    @inlinable mutating func withUnsafeMutableData<T: NBKCoreInteger,  U>(
    as type: T.Type, perform body: (inout UnsafeMutableBufferPointer<T>) throws -> U) rethrows -> U {
        //=--------------------------------------=
        assert(MemoryLayout<Self>.size / MemoryLayout<T>.stride >= 1)
        assert(MemoryLayout<Self>.size % MemoryLayout<T>.stride == 0)
        //=--------------------------------------=
        return try Swift.withUnsafeMutablePointer(to: &self) { base in
            let count = MemoryLayout<Self>.size / MemoryLayout<T>.stride
            return try base.withMemoryRebound(to: T.self, capacity: count) { start in
                var data = UnsafeMutableBufferPointer(start: start, count:   count)
                return try body(&data)
            }
        }
    }
}
