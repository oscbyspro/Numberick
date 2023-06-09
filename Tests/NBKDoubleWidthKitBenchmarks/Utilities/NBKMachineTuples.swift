//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKDoubleWidthKit

//*============================================================================*
// MARK: * NBK x Machine Tuples
//*============================================================================*

typealias NBK128X64 = (UInt64, UInt64)
typealias NBK128X32 = (UInt32, UInt32, UInt32, UInt32)

typealias NBK256X64 = (UInt64, UInt64, UInt64, UInt64)
typealias NBK256X32 = (UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32, UInt32)

//*============================================================================*
// MARK: * NBK x Machine Tuples x Double Width
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(x64: NBK128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK128X64) where BitPattern == UInt128 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
    
    init(x64: NBK256X64) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x64.3, x64.2, x64.1, x64.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x64), to: Self.self)
        #endif
    }
    
    init(x32: NBK256X32) where BitPattern == UInt256 {
        #if _endian(big)
        self = Swift.unsafeBitCast((x32.7, x32.6, x32.5, x32.4, x32.3, x32.2, x32.1, x32.0), to: Self.self)
        #else
        self = Swift.unsafeBitCast((x32), to: Self.self)
        #endif
    }
}
