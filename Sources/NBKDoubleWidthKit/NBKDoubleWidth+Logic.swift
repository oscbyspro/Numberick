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
// MARK: * NBK x Double Width x Logic
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(x: Self) -> Self {
        x.onesComplement()
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        lhs.low  &= rhs.low
        lhs.high &= rhs.high
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.low  |= rhs.low
        lhs.high |= rhs.high
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.low  ^= rhs.low
        lhs.high ^= rhs.high
    }
}
