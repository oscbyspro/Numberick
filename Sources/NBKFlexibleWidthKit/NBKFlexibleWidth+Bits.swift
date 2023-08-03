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
    
    /// The number of bits in ``words``.
    @inlinable public var bitWidth: Int {
        self.magnitude.bitWidth + self.storageBitWidthNeeded
    }
    
    @inlinable public var nonzeroBitCount: Int {
        switch self.isLessThanZero {
        case false: return self.magnitude.nonzeroBitCount
        case  true: return NBK.nonzeroBitCount(twosComplementOf: self.magnitude.storage.elements) + self.storageBitWidthNeeded }
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
    
    /// The number of bits in ``words``.
    @inlinable public var bitWidth: Int {
        self.storage.elements.count * UInt.bitWidth
    }
    
    @inlinable public var nonzeroBitCount: Int {
        NBK.nonzeroBitCount(of: self.storage.elements)
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.storage.elements.last?.leadingZeroBitCount ?? Int.zero
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        var index = self.storage.elements.startIndex
        var element = UInt.zero
        
        while index < self.storage.elements.endIndex, element.isZero {
            element = self.storage.elements[index]
            self.storage.elements.formIndex(after: &index)
        }
        
        return (index - 1) * UInt.bitWidth + element.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.storage.elements.last?.mostSignificantBit ?? false
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.storage.elements.first?.leastSignificantBit ?? false
    }
}
