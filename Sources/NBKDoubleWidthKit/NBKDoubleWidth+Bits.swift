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
// MARK: * NBK x Double Width x Bits
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var bitWidth: Int {
        Low.bitWidth + High.bitWidth
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(descending: HL(High.zero, Low(bit: bit)))
    }
    
    @inlinable public init(repeating bit: Bool) {
        self.init(bitPattern: bit ? Magnitude.max : Magnitude.min)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var nonzeroBitCount: Int {
        self.low.nonzeroBitCount &+ self.high.nonzeroBitCount
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        let count  = self.high.leadingZeroBitCount
        if  count != High.bitWidth { return count }
        return count &+ self.low.leadingZeroBitCount
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        let count  = self.low.trailingZeroBitCount
        if  count != Low.bitWidth { return count }
        return count &+ self.high.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.high.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.low.leastSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func matches(repeating bit: Bool) -> Bool {
        bit ? self.isFull : self.isZero
    }
}
