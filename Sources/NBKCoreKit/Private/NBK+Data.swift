//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Data
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to `source` then returns the initialized `count`.
    @inlinable public static func initializeGetCount<T: NBKCoreInteger>(
    _   base: UnsafeMutablePointer<T>, to source: UnsafeBufferPointer<T>) -> Int {
        base.initialize(from: source.baseAddress!, count: source.count)
        return source.count as Int
    }
    
    /// Initializes `base` to `source` then returns the initialized `count`.
    @inlinable public static func initializeGetCount<T: NBKCoreInteger>(
    _   base: UnsafeMutablePointer<T>, repeating element: T, count: Int) -> Int {
        base.initialize(repeating: element, count: count)
        return count as Int
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Unwraps the buffer's base address and count, if possible.
    @inlinable public static func unwrapping<T>(
    _   buffer: UnsafeBufferPointer<T>) -> (baseAddress: UnsafePointer<T>, count: Int)? {
        guard let baseAddress = buffer.baseAddress  else { return nil }
        return   (baseAddress:  baseAddress, count: buffer.count)
    }
    
    /// Unwraps the buffer's base address and count, if possible.
    @inlinable public static func unwrapping<T>(
    _   buffer: UnsafeMutableBufferPointer<T>) -> (baseAddress: UnsafeMutablePointer<T>, count: Int)? {
        guard let baseAddress = buffer.baseAddress  else { return nil }
        return   (baseAddress:  baseAddress, count: buffer.count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Copies the elements of the given `collection` to a temporary allocation.
    @inlinable public static func withUnsafeTemporaryAllocation<Element: NBKCoreInteger, Result>(
    copying collection: some Collection<Element>, perform: (inout UnsafeMutableBufferPointer<Element>) -> Result) -> Result {
        Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: collection.count) { buffer in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            let count = buffer.initialize(from: collection).1
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.baseAddress!.deinitialize(count: count)
            }
            //=----------------------------------=
            var swappable: UnsafeMutableBufferPointer = buffer
            return perform(&swappable) // replacing it is fine
        }
    }
}
