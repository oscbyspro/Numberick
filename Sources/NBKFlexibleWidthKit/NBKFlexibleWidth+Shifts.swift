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
// MARK: * NBK x Flexible Width x Shifts x Unsigned
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeftSmart(by: Int(clamping: rhs))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitshiftLeftSmart(by distance: Int) {
        switch distance >= 0 {
        case  true: self.bitshiftLeft (by: distance)
        case false: self.bitshiftRight(by: distance.negated()) }
    }
    
    @inlinable public func bitshiftedLeftSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftLeftSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftLeft(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftLeft(words: major, bits: minor)
    }
    
    @inlinable public func bitshiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitshiftLeft(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftLeft(words: Int, bits: Int) {
        precondition(words >= 0, NBK.callsiteOutOfBoundsInfo())
        precondition(bits  >= 0 && bits < UInt.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        self.storage.resize(minCount: self.storage.elements.endIndex + words + 1)
        //=--------------------------------------=
        let offset: Int = ~(words)
        var destination = self.storage.elements.endIndex as Int
        var word = self.storage.elements[destination &+ offset]
        //=--------------------------------------=
        while destination > self.storage.elements.startIndex {
            self.storage.elements.formIndex(before: &destination)
            let pushed = word &<< push
            word = destination > words ? self.storage.elements[destination &+ offset] : UInt()
            let pulled = word &>> pull
            self.storage.elements[destination ] = pushed | pulled
        }
        //=--------------------------------------=
        self.storage.normalize()
    }
    
    @inlinable public func bitshiftedLeft(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words, bits: bits); return result
    }
    
    @inlinable public mutating func bitshiftLeft(words: Int) {
        precondition(words >= 0, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        if  self .isZero { return }
        //=--------------------------------------=
        let prefix = repeatElement(UInt.zero, count: words)
        self.storage.elements.insert(contentsOf: prefix,  at: Int())
    }
    
    @inlinable public func bitshiftedLeft(words: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words); return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRightSmart(by: Int(clamping: rhs))
    }

    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitshiftRightSmart(by distance: Int) {
        switch distance >= 0 {
        case  true: self.bitshiftRight(by: distance)
        case false: self.bitshiftLeft (by: distance.negated()) }
    }
    
    @inlinable public func bitshiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftRightSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftRight(words: major, bits: minor)
    }
    
    @inlinable public func bitshiftedRight(by distance: Int) -> Self {
        var result = self; result.bitshiftRight(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftRight(words: Int, bits: Int) {
        precondition(words >= 0, NBK.callsiteOutOfBoundsInfo())
        precondition(bits  >= 0 && bits < UInt.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  words >= self.storage.elements.count {
            return self = Self.zero
        }
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        let sign = UInt(repeating: self.isLessThanZero)
        //=--------------------------------------=
        var destination = self.storage.elements.startIndex
        let edge = self.storage.elements.distance(from: words, to: self.storage.elements.endIndex)
        var word = self.storage.elements[words] as UInt
        //=--------------------------------------=
        while destination < edge {
            let after  = self.storage.elements.index(after: destination)
            let pushed = word &>> push
            word = after < edge ? self.storage.elements[after &+ words] : sign
            let pulled = word &<< pull
            self.storage.elements[destination ] = pushed | pulled
            destination = after
        }
        //=--------------------------------------=
        self.storage.elements.removeLast(words)
        self.storage.normalize()
    }
    
    @inlinable public func bitshiftedRight(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftRight(words: words, bits: bits); return result
    }
    
    @inlinable public mutating func bitshiftRight(words: Int) {
        precondition(words >= 0, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        self.storage.elements.removeFirst(Swift.min(words, self.storage.elements.count))
        self.storage.normalize()
    }
    
    @inlinable public func bitshiftedRight(words: Int) -> Self {
        var result = self; result.bitshiftRight(words: words); return result
    }
}
