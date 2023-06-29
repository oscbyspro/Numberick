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
// MARK: * NBK x Double Width x Shifts x Left
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeftSmart(by: Int(clamping: rhs))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    @inlinable public static func &<<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeft(by: rhs.moduloBitWidth(of: Self.self))
    }
    
    @inlinable public static func &<<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs &<<= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public mutating func bitshiftLeftSmart(by distance: Int) {
        let size = distance.magnitude as UInt
        switch (distance >= 0, size < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftLeft (by: Int(bitPattern: size))
        case (true,  false): self = Self(repeating: false)
        case (false, true ): self.bitshiftRight(by: Int(bitPattern: size))
        case (false, false): self = Self(repeating: self.isLessThanZero) }
    }
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public func bitshiftedLeftSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftLeftSmart(by: distance); return result
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(by distance: Int) {
        precondition(distance >= 0, "shift distance must be at least zero")
        let major  = distance .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = distance.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftLeft(words: major, bits: minor)
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitshiftLeft(by: distance); return result
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int, bits: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major shift distance")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor shift distance")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        var destination = self.endIndex as Int
        let offset: Int = ~(words)
        var word = self[destination &+ offset]
        
        while destination > self.startIndex {
            self.formIndex(before: &destination)
            let pushed = word &<< push
            word = destination > words ? self[destination &+ offset] : UInt()
            let pulled = word &>> pull
            self[destination] = pushed | pulled
        }
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words, bits: bits); return result
    }
        
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major shift distance")
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        for destination in self.indices.reversed() {
            self[destination] = destination >= words ? self[destination - words] : UInt()
        }
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitshiftedLeft(words: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words); return result
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x Right
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRightSmart(by: Int(clamping: rhs))
    }

    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    @inlinable public static func &>>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRight(by: rhs.moduloBitWidth(of: Self.self))
    }
    
    @inlinable public static func &>>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs &>>= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Performs a smart, signed, right shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public mutating func bitshiftRightSmart(by distance: Int) {
        let size = distance.magnitude as UInt
        switch (distance >= 0, size < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftRight(by: Int(bitPattern: size))
        case (true,  false): self = Self(repeating: self.isLessThanZero)
        case (false, true ): self.bitshiftLeft (by: Int(bitPattern: size))
        case (false, false): self = Self(repeating: false) }
    }
    
    /// Performs a smart, signed, right shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public func bitshiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftRightSmart(by: distance); return result
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(distance >= 0, "shift distance must be at least zero")
        let major =  distance .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor =  distance.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftRight(words: major, bits: minor)
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public func bitshiftedRight(by distance: Int) -> Self {
        var result = self; result.bitshiftRight(by: distance); return result
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(words: Int, bits: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major shift distance")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor shift distance")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        let sign = UInt(repeating: self.isLessThanZero)
        //=--------------------------------------=
        var destination = self.startIndex
        var word = self[words]
        let edge = self.endIndex &- words
        
        while destination < self.endIndex {
            let after  = self.index(after: destination)
            let pushed = word &>> push
            word = after < edge ? self[after &+ words] : sign
            let pulled = word &<< pull
            self[destination] = pushed | pulled
            destination = after
        }
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedRight(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftRight(words: words, bits: bits); return result
    }
        
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(words: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major shift distance")
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        let sign = UInt(repeating: self.isLessThanZero)
        //=--------------------------------------=
        let edge = self.distance(from: words, to: self.endIndex)
        
        for destination in self.indices {
            self[destination] = destination < edge ? self[destination + words] : sign
        }
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitshiftedRight(words: Int) -> Self {
        var result = self; result.bitshiftRight(words: words); return result
    }
}
