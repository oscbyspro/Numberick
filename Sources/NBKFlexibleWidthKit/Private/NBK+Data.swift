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
// MARK: * NBK x Data
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` by pushing `source` then returns the `data`.
    @inlinable public static func initialize<T: NBKCoreInteger>(
    _   base: inout UnsafeMutablePointer<T>, to source: UnsafeBufferPointer<T>) -> UnsafeMutableBufferPointer<T> {
        base.initialize(from: source.baseAddress!, count: source.count)
        
        defer {
            base = base.advanced(by: source.count)
        }
        
        return UnsafeMutableBufferPointer(start: base, count: source.count)
    }
    
    
    /// Initializes `base` by pushing `source` then returns the `data`.
    @inlinable public static func initialize<T: NBKCoreInteger>(
    _   base: inout UnsafeMutablePointer<T>, repeating element: T, count: Int) -> UnsafeMutableBufferPointer<T> {
        base.initialize(repeating: element, count: count)
        
        defer {
            base = base.advanced(by: count)
        }
        
        return UnsafeMutableBufferPointer(start: base, count: count)
    }
}
