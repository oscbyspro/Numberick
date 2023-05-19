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
        lhs.bitshiftLeftUncheckedSmart(by: Int(clamping: rhs))
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
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftLeftUncheckedSmart(by amount: Int) {
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  false)
        case (false, true ): self.bitshiftRightUnchecked(by: Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  self.isLessThanZero)
        }
    }
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedLeftUncheckedSmart(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftLeftUncheckedSmart(by: amount); return newValue
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeftUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid total shift amount")
        let (words, bits) = amount.dividedByBitWidth()
        return self.bitshiftLeftUnchecked(words: words, bits: bits)
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedLeftUnchecked(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftLeftUnchecked(by: amount); return newValue
    }
    
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
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedLeftUnchecked(words: Int, bits: Int) -> Self {
        var newValue = self; newValue.bitshiftLeftUnchecked(words: words, bits: bits); return newValue
    }
}

// TODO: make these public
//*============================================================================*
// MARK: * NBK x Double Width x Shifts x R
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRightUncheckedSmart(by: Int(clamping: rhs))
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
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftRightUncheckedSmart(by amount: Int) {
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftRightUnchecked(by: Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  self.isLessThanZero)
        case (false, true ): self.bitshiftLeftUnchecked(by:  Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  false)
        }
    }
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public func bitshiftedRightUncheckedSmart(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftRightUncheckedSmart(by: amount); return newValue
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRightUnchecked(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid total shift amount")
        let (words, bits) = amount.dividedByBitWidth()
        return self.bitshiftRightUnchecked(words: words, bits: bits)
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedRightUnchecked(by amount: Int) -> Self {
        var newValue = self; newValue.bitshiftRightUnchecked(by: amount); return newValue
    }
    
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
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedRightUnchecked(words: Int, bits: Int) -> Self {
        var newValue = self; newValue.bitshiftRightUnchecked(words: words, bits: bits); return newValue
    }
}
