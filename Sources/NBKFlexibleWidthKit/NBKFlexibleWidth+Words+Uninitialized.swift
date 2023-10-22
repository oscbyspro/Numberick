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
// MARK: * NBK x Double Width x Words x Uninitialized
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func uninitialized(
    count: Int, init: (inout UnsafeMutableBufferPointer<UInt>) -> Void) -> Self {
        Self.uninitialized(capacity: count, init:{ $1 = $0.count; `init`(&$0) })
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Uninitialized x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func uninitialized(
    capacity: Int, init: (inout UnsafeMutableBufferPointer<UInt>, inout Int) throws -> Void) rethrows -> Self {
        Self(normalizing: try Storage.uninitialized(capacity: capacity, init: `init`))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Uninitialized x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized words.
    ///
    /// The `init` is responsible for initializing up to `capacity` prefixing words.
    /// The `init` is given a buffer and an initialized prefix count. All words in
    /// the prefix must be initialized and all words after it must be uninitialized.
    /// This postcondition must hold even when the `init` throws an error.
    ///
    /// - Note: While the resulting instance may have a capacity larger than the 
    /// requested amount, the buffer passed to `init` will cover exactly the requested
    /// number of words.
    ///
    /// ### No initialized prefix semantics
    ///
    /// It returns zero when the initialized prefix count is zero because the following
    /// expressions must return the same values:
    ///
    /// ```swift
    /// 1. Self.init(words:   words) // this is zero when words == []
    /// 2. Self.uninitialized(count:    words.count) {  _ = $0.initialize(from: words).index }
    /// 3. Self.uninitialized(capacity: words.count) { $1 = $0.initialize(from: words).index }
    /// ```
    ///
    @inlinable public static func uninitialized(
    capacity: Int, init: (inout UnsafeMutableBufferPointer<UInt>, inout Int) throws -> Void) rethrows -> Self {
        Self(nonemptying: try Elements(unsafeUninitializedCapacity: capacity, initializingWith: `init`))
    }
}
