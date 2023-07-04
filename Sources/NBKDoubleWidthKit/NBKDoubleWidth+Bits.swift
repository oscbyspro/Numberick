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
        assert(MemoryLayout<Self>.size / MemoryLayout<UInt>.stride >= 2)
        assert(MemoryLayout<Self>.size % MemoryLayout<UInt>.stride == 0)
        return MemoryLayout<Self>.size * 8
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(low: Low(bit: bit))
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
        let    result  = self.high.leadingZeroBitCount
        guard  result == High.bitWidth else { return result }
        return result &+ self.low .leadingZeroBitCount
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        let    result  = self.low .trailingZeroBitCount
        guard  result == Low .bitWidth else { return result }
        return result &+ self.high.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.high.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.low.leastSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Get, Set, Clear, Toggle
    //=------------------------------------------------------------------------=
    
    @inlinable public func get(bit: Int) -> Bool {
        precondition(bit >= 0, NBK.callsiteOutOfBoundsInfo())
        let major  = bit .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = bit.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self[major].get(bit: minor)
    }
    
    @inlinable public mutating func set(bit: Int) {
        precondition(bit >= 0, NBK.callsiteOutOfBoundsInfo())
        let major  = bit .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = bit.remainderDividingByBitWidthAssumingIsAtLeastZero()
        self[major].set(bit: minor)
    }
    
    @inlinable public mutating func clear(bit: Int) {
        precondition(bit >= 0, NBK.callsiteOutOfBoundsInfo())
        let major  = bit .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = bit.remainderDividingByBitWidthAssumingIsAtLeastZero()
        self[major].clear(bit: minor)
    }
    
    @inlinable public mutating func toggle(bit: Int) {
        precondition(bit >= 0, NBK.callsiteOutOfBoundsInfo())
        let major  = bit .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = bit.remainderDividingByBitWidthAssumingIsAtLeastZero()
        self[major].toggle(bit: minor)
    }
}
