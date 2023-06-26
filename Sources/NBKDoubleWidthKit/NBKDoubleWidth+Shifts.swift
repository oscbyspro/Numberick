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
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftLeftSmart(by amount: Int) {
        let unsigned = amount.magnitude as UInt
        switch (amount >= 0, unsigned < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftLeft (by: Int(bitPattern: unsigned))
        case (true,  false): self = Self(repeating: false)
        case (false, true ): self.bitshiftRight(by: Int(bitPattern: unsigned))
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
    @inlinable public mutating func bitshiftLeft(by amount: Int) {
        precondition(0 <= amount, "invalid left shift amount")
        let major = amount .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor = amount.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftLeft(words: major, bits: minor)
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(by amount: Int) -> Self {
        var result = self; result.bitshiftLeft(by: amount); return result
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int, bits: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major left shift amount")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor left shift amount")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        let a = UInt(bitPattern: bits)
        let b = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        var x = self.distance(from: words, to: self.lastIndex)
        var y = self[x] as UInt
        //=--------------------------------------=
        for i in stride(from: self.lastIndex, to: -1, by: -1) {
            let p = y &<< a
            
            x = x  - 1
            y = x >= self.startIndex ? self[x] : 0
            
            let q = y &>> b
            self[i] = p | q
        }
    }
    
    /// Performs an unchecked left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
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
        precondition(0 ..< self.endIndex ~= words, "invalid major left shift amount")
        //=--------------------------------------=
        guard words > Int.zero else { return }
        //=--------------------------------------=
        for i in self.indices.reversed() {
            self[i] = i >= words ? self[i - words] : 0
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
    ///   - amount: `Int.min <= amount <= Int.max`
    ///
    @inlinable public mutating func bitshiftRightSmart(by amount: Int) {
        let unsigned = amount.magnitude as UInt
        switch (amount >= 0, unsigned < UInt(bitPattern: Self.bitWidth)) {
        case (true,  true ): self.bitshiftRight(by: Int(bitPattern: unsigned))
        case (true,  false): self = Self(repeating: self.isLessThanZero)
        case (false, true ): self.bitshiftLeft (by: Int(bitPattern: unsigned))
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
    @inlinable public mutating func bitshiftRight(by amount: Int) {
        precondition(0 <= amount, "invalid right shift amount")
        let major = amount .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor = amount.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitshiftRight(words: major, bits: minor)
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - amount: `0 <= amount < Self.bitWidth`
    ///
    @inlinable public func bitshiftedRight(by amount: Int) -> Self {
        var result = self; result.bitshiftRight(by: amount); return result
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(words: Int, bits: Int) {
        precondition(0 ..< self.endIndex ~= words, "invalid major right shift amount")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor right shift amount")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        let a = UInt(bitPattern: bits)
        let b = UInt(bitPattern: UInt.bitWidth - bits)
        let s = UInt(repeating:  self.isLessThanZero )
        //=--------------------------------------=
        var x = (words) as  Int
        var y = self[x] as UInt
        //=--------------------------------------=
        for i in self.indices {
            let p = y &>> a
            
            x = x + 1
            y = x < self.endIndex ? self[x] : s
            
            let q = y &<< b
            self[i] = p | q
        }
    }
    
    /// Performs an unchecked, signed, right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
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
        precondition(0 ..< self.endIndex ~= words, "invalid major right shift amount")
        //=--------------------------------------=
        if words.isZero { return }
        //=--------------------------------------=
        let s = UInt(repeating: self.isLessThanZero)
        let e = self.endIndex - words
        //=--------------------------------------=
        for i in self.indices {
            self[i] = (i < e) ? self[i + words] : s
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
