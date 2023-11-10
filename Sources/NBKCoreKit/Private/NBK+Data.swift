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
    @inline(__always) @inlinable public static func initializeGetCount<T: NBKCoreInteger>(
    _   base: UnsafeMutablePointer<T>, to source: UnsafeBufferPointer<T>) -> Int {
        base.initialize(from: source.baseAddress!, count: source.count)
        return source.count as Int
    }
    
    /// Initializes `base` to `source` then returns the initialized `count`.
    @inline(__always) @inlinable public static func initializeGetCount<T: NBKCoreInteger>(
    _   base: UnsafeMutablePointer<T>, repeating element: T, count: Int) -> Int {
        base.initialize(repeating: element, count: count)
        return count as Int
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Unwraps the buffer's base address and count, if possible.
    @inline(__always) @inlinable public static func unwrapping<T>(
    _   buffer: UnsafeBufferPointer<T>) -> (baseAddress: UnsafePointer<T>, count: Int)? {
        guard let baseAddress = buffer.baseAddress  else { return nil }
        return   (baseAddress:  baseAddress, count: buffer.count)
    }
    
    /// Unwraps the buffer's base address and count, if possible.
    @inline(__always) @inlinable public static func unwrapping<T>(
    _   buffer: UnsafeMutableBufferPointer<T>) -> (baseAddress: UnsafeMutablePointer<T>, count: Int)? {
        guard let baseAddress = buffer.baseAddress  else { return nil }
        return   (baseAddress:  baseAddress, count: buffer.count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to a temporary allocation of `1` element.
    @inline(__always) @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    of  type: Element.Type, perform: (UnsafeMutablePointer<Element>) -> Result) -> Result {
        Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: 1) {
            //=----------------------------------=
            // allocation: count <= $0.count
            //=----------------------------------=
            perform($0.baseAddress.unsafelyUnwrapped)
        }
    }
    
    /// Grants unsafe access to a temporary allocation of `count` elements.
    @inline(__always) @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    of  type: Element.Type, count: Int, perform: (UnsafeMutableBufferPointer<Element>) -> Result) -> Result {
        Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: count) {
            //=----------------------------------=
            // allocation: count <= $0.count
            //=----------------------------------=
            perform(UnsafeMutableBufferPointer(start: $0.baseAddress!, count: count))
        }
    }
    
    /// Copies the elements of the given `collection` to a temporary allocation of `collection.count` elements.
    ///
    /// ### Development
    ///
    /// - TODO: [Swift 5.8](https://github.com/apple/swift-evolution/blob/main/proposals/0370-pointer-family-initialization-improvements.md)
    ///
    @inline(__always) @inlinable public static func withUnsafeTemporaryAllocation<Element: NBKCoreInteger, Result>(
    copying collection: some Collection<Element>, perform: (UnsafeMutableBufferPointer<Element>) -> Result) -> Result {
        NBK.withUnsafeTemporaryAllocation(of: Element.self, count: collection.count) { buffer in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            _ = buffer.initialize(from: collection)
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.baseAddress!.deinitialize(count: buffer.count)
            }
            
            return perform(buffer)
        }
    }
}
