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
        lhs.bitshiftLeftUnchecked(by: rhs.moduloBitWidth(of: Self.self))
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
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftLeftSmart(by amount: Int) {
        let unsigned = amount.magnitude as UInt
        switch (amount >= 0, unsigned < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: unsigned))
        case (true,  false): self = Self(repeating: false)
        case (false, true ): self.bitshiftRightUnchecked(by: Int(bitPattern: unsigned))
        case (false, false): self = Self(repeating: self.isLessThanZero) }
    }
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedLeftSmart(by amount: Int) -> Self {
        var result = self; result.bitshiftLeftSmart(by: amount); return result
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeftUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid left shift amount")
        let major = amount .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor = amount.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftLeftUnchecked(words: major, bits: minor)
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedLeftUnchecked(by amount: Int) -> Self {
        var result = self; result.bitshiftLeftUnchecked(by: amount); return result
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeftUnchecked(words: Int, bits: Int) {
        assert(0 ..< Self.endIndex ~= words, "invalid major left shift amount")
        assert(0 ..< UInt.bitWidth ~= bits,  "invalid minor left shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: bits)
        let b = UInt(bitPattern: UInt.bitWidth &- bits)
        let x = bits.isZero  as  Bool
        //=--------------------------------------=
        for i: Int  in  self.indices.reversed() {
            let j:  Int = i &- words
            let k:  Int = j &- 1
            
            let p: UInt =         (j >= self.startIndex ? self[j] : 0) &<< a
            let q: UInt = x ? 0 : (k >= self.startIndex ? self[k] : 0) &>> b
            
            self[i] = p | q
        }
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedLeftUnchecked(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftLeftUnchecked(words: words, bits: bits); return result
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
        lhs.bitshiftRightUnchecked(by: rhs.moduloBitWidth(of: Self.self))
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
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftRightSmart(by amount: Int) {
        let unsigned = amount.magnitude as UInt
        switch (amount >= 0, unsigned < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftRightUnchecked(by: Int(bitPattern: unsigned))
        case (true,  false): self = Self(repeating: self.isLessThanZero)
        case (false, true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: unsigned))
        case (false, false): self = Self(repeating: false) }
    }
    
    /// Performs a smart, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedRightSmart(by amount: Int) -> Self {
        var result = self; result.bitshiftRightSmart(by: amount); return result
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRightUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid right shift amount")
        let major = amount .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor = amount.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftRightUnchecked(words: major, bits: minor)
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedRightUnchecked(by amount: Int) -> Self {
        var result = self; result.bitshiftRightUnchecked(by: amount); return result
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRightUnchecked(words: Int, bits: Int) {
        assert(0 ..< Self.endIndex ~= words, "invalid major right shift amount")
        assert(0 ..< UInt.bitWidth ~= bits,  "invalid minor right shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: bits)
        let b = UInt(bitPattern: UInt.bitWidth &- bits)
        let c = UInt(repeating:  self.isLessThanZero)
        let x = bits.isZero  as  Bool
        //=--------------------------------------=
        for i: Int  in  self.indices {
            let j:  Int = i &+ words
            let k:  Int = j &+ 1
            
            let p: UInt =         (j < self.endIndex ? self[j] : c) &>> a
            let q: UInt = x ? 0 : (k < self.endIndex ? self[k] : c) &<< b
            
            self[i] = p | q
        }
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedRightUnchecked(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftRightUnchecked(words: words, bits: bits); return result
    }
}
