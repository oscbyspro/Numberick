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
// MARK: * NBK x Double Width x Shifts x L
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
        lhs.bitshiftLeftUnchecked(by: Int(bitPattern: rhs._lowWord) & (Self.bitWidth &- 1))
    }
    
    @inlinable public static func &<<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs &<<= rhs; return lhs
    }
    
    // TODO: make these public
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftLeftSmart(by amount: Int) {
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  false)
        case (false, true ): self.bitshiftRightUnchecked(by: Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  self.isLessThanZero)
        }
    }
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedLeftSmart(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftLeftSmart(by: amount); return newValue
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeftUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid total shift amount")
        let (words, bits) = amount.dividedByBitWidth()
        return self.bitshiftLeftUnchecked(words: words, bits: bits)
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedLeftUnchecked(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftLeftUnchecked(by: amount); return newValue
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeftUnchecked(words major: Int, bits minor: Int) {
        assert(0 ..< Self.endIndex ~= major, "invalid major shift amount")
        assert(0 ..< UInt.bitWidth ~= minor, "invalid minor shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: minor)
        let b = UInt(bitPattern: UInt.bitWidth &- minor)
        let x = minor.isZero as  Bool
        //=--------------------------------------=
        for i: Int  in  self.indices.reversed() {
            let j:  Int = i &- major
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
        var newValue = self; newValue.bitshiftLeftUnchecked(words: words, bits: bits); return newValue
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x R
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
        lhs.bitshiftRightUnchecked(by: Int(bitPattern: rhs._lowWord) & (Self.bitWidth &- 1))
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
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftRightUnchecked(by: Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  self.isLessThanZero)
        case (false, true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  false)
        }
    }
    
    /// Performs a smart, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedRightSmart(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftRightSmart(by: amount); return newValue
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRightUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid total shift amount")
        let (words, bits) = amount.dividedByBitWidth()
        return self.bitshiftRightUnchecked(words: words, bits: bits)
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedRightUnchecked(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftRightUnchecked(by: amount); return newValue
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRightUnchecked(words major: Int, bits minor: Int) {
        assert(0 ..< Self.endIndex ~= major, "invalid major shift amount")
        assert(0 ..< UInt.bitWidth ~= minor, "invalid minor shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: minor)
        let b = UInt(bitPattern: UInt.bitWidth &- minor)
        let c = UInt(repeating:  self.isLessThanZero)
        let x = minor.isZero as  Bool
        //=--------------------------------------=
        for i: Int  in  self.indices {
            let j:  Int = i &+ major
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
        var newValue = self; newValue.bitshiftRightUnchecked(words: words, bits: bits); return newValue
    }
}
