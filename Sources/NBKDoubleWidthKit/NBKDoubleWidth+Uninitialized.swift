//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Uninitialized
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with access to a temporary allocation.
    @inlinable public static func uninitialized(_ body: (inout Self) -> Void) -> Self {
        Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            body( &buffer.baseAddress.unsafelyUnwrapped.pointee)
            return buffer.baseAddress.unsafelyUnwrapped.pointee
        }
    }
}
