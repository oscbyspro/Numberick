//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !COCOAPODS
import NBKCoreKit
#endif

//*============================================================================*
// MARK: * NBK x Double Width x Endianness
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bigEndian value: Self) {
        #if _endian(big)
        self = value
        #else
        self = value.byteSwapped
        #endif
    }
    
    @inlinable public init(littleEndian value: Self) {
        #if _endian(big)
        self = value.byteSwapped
        #else
        self = value
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public var bigEndian: Self {
        #if _endian(big)
        return self
        #else
        return self.byteSwapped
        #endif
    }
    
    @inlinable public var littleEndian: Self {
        #if _endian(big)
        return self.byteSwapped
        #else
        return self
        #endif
    }
    
    @inlinable public var byteSwapped: Self {
        let high = High(bitPattern: self.low .byteSwapped)
        let low  = Low (bitPattern: self.high.byteSwapped)
        return Self(high: high, low: low)
    }
}
