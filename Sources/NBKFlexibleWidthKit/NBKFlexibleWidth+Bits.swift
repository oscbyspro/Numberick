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
// MARK: * NBK x Flexible Width x Bits x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(digit: Digit(bit: bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        self.magnitude.bitWidth + self.storageBitWidthNeeded
    }
        
    @inlinable public var nonzeroBitCount: Int {
        if  self.isLessThanZero {
            let  s = NBK.nonzeroBitCount(twosComplementOf: self.magnitude.storage)
            return s + self.storageBitWidthNeeded
        }   else {
            return self.magnitude.nonzeroBitCount
        }
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.isLessThanZero ? Int.zero : (self.magnitude.leadingZeroBitCount + self.storageBitWidthNeeded)
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        self.magnitude.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.isLessThanZero
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.magnitude.leastSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// The number of extra bits in `bitWidth` compared to `magnitude/bitWidth`.
    @inlinable var storageBitWidthNeeded: Int {
        self.storageNeedsOneMoreWord ? UInt.bitWidth : Int.zero
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Bits x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(digit: Digit(bit: bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        self.storage.bitWidth
    }
    
    @inlinable public var nonzeroBitCount: Int {
        self.storage.nonzeroBitCount
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.storage.last.leadingZeroBitCount
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        self.storage.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.storage.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.storage.leastSignificantBit
    }
}
