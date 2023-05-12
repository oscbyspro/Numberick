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
        lhs._bitshiftLeftSmart(by: Int(clamping: rhs))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    @inlinable public static func &<<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs._bitshiftLeft(by: Int(bitPattern: rhs._lowWord) & (Self.bitWidth &- 1))
    }
    
    @inlinable public static func &<<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs &<<= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable mutating func _bitshiftLeftSmart(by amount: Int) {
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self._bitshiftLeft(by:  Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  false)
        case (false, true ): self._bitshiftRight(by: Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  self.isLessThanZero)
        }
    }
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable func _bitshiftedLeftSmart(by amount: Int) -> Self {
        var x = self; x._bitshiftLeftSmart(by: amount); return x
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable mutating func _bitshiftLeft(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid shift amount")
        let words: Int = amount &>> UInt.bitWidth.trailingZeroBitCount
        let bits:  Int = amount &  (UInt.bitWidth &- 1)
        return self._bitshiftLeft(words: words, bits: bits)
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable func _bitshiftedLeft(by amount: Int) -> Self {
        var newValue = self; newValue._bitshiftLeft(by: amount); return newValue
    }
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func _bitshiftLeft(words major: Int, bits minor: Int) {
        assert(0 ..< Self.endIndex ~= major, "invalid shift amount")
        assert(0 ..< UInt.bitWidth ~= minor, "invalid shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: minor)
        let b = UInt(bitPattern: UInt.bitWidth &- minor)
        let x = minor.isZero as  Bool
        //=--------------------------------------=
        self.withUnsafeMutableWords { words in
            var i: Int = words.endIndex
            backwards: while i > words.startIndex {
                words.formIndex(before: &i)
                
                let j:  Int = i &- major
                let k:  Int = j &- 1
                
                let p: UInt =         (j >= words.startIndex ? words[j] : 0) &<< a
                let q: UInt = x ? 0 : (k >= words.startIndex ? words[k] : 0) &>> b
                
                words[i] = p | q
            }
        }
    }
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable func _bitshiftedLeft(words: Int, bits: Int) -> Self {
        var x = self; x._bitshiftLeft(words: words, bits: bits); return x
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
        lhs._bitshiftRightSmart(by: Int(clamping: rhs))
    }

    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    @inlinable public static func &>>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs._bitshiftRight(by: Int(bitPattern: rhs._lowWord) & (Self.bitWidth &- 1))
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
    @inlinable mutating func _bitshiftRightSmart(by amount: Int) {
        let amountAbsoluteValue = amount.magnitude  as UInt
        switch (amount >= 0, amountAbsoluteValue <  UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self._bitshiftRight(by: Int(bitPattern: amountAbsoluteValue))
        case (true,  false): self = Self(repeating:  self.isLessThanZero)
        case (false, true ): self._bitshiftLeft(by:  Int(bitPattern: amountAbsoluteValue))
        case (false, false): self = Self(repeating:  false)
        }
    }
    
    /// - Parameters:
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable func _bitshiftedRightSmart(by amount: Int) -> Self {
        var newValue = self; newValue._bitshiftRightSmart(by: amount); return newValue
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable mutating func _bitshiftRight(by amount: Int) {
        assert(0 ..< Self.bitWidth ~= amount, "invalid shift amount")
        let words: Int = amount &>> UInt.bitWidth.trailingZeroBitCount
        let bits:  Int = amount &  (UInt.bitWidth &- 1)
        return self._bitshiftRight(words: words, bits: bits)
    }
    
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable func _bitshiftedRight(by amount: Int) -> Self {
        var newValue = self; newValue._bitshiftRight(by: amount); return newValue
    }
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func _bitshiftRight(words major: Int, bits minor: Int) {
        assert(0 ..< Self.endIndex ~= major, "invalid shift amount")
        assert(0 ..< UInt.bitWidth ~= minor, "invalid shift amount")
        //=--------------------------------------=
        let a = UInt(bitPattern: minor)
        let b = UInt(bitPattern: UInt.bitWidth &- minor)
        let c = UInt(repeating:  self.isLessThanZero)
        let x = minor.isZero as  Bool
        //=--------------------------------------=
        self.withUnsafeMutableWords { words in
            var i: Int = words.startIndex
            forwards: while i < words.endIndex {
                let j:  Int = i &+ major
                let k:  Int = j &+ 1
                
                let p: UInt =         (j < words.endIndex ? words[j] : c) &>> a
                let q: UInt = x ? 0 : (k < words.endIndex ? words[k] : c) &<< b
                
                words[i] = p | q
                
                words.formIndex(after: &i)
            }
        }
    }
    
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable func _bitshiftedRight(words: Int, bits: Int) -> Self {
        var newValue = self; newValue._bitshiftRight(words: words, bits: bits); return newValue
    }
}
