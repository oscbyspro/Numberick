//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !COCOAPODS
import NBKCoreKit
#endif

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x Left
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeftSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    @inlinable public static func &<<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeft(by: NBK.leastPositiveResidue(of: rhs, dividingByBitWidthOf: Self.self))
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
        switch (distance >= 0, size < UInt(bitPattern: self.bitWidth)) {
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
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftLeft(words: major, bits: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitshiftLeft(by: distance); return result
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int, bits: Int) {
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        NBK.bitshiftLeftAsFixedLimbsCodeBlock(&self, environment: false, limbs: words, atLeastOneBit: bits)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words, bits: bits); return result
    }
        
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        NBK.bitshiftLeftAsFixedLimbsCodeBlock(&self, environment: false, atLeastOneLimb: words)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
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
        lhs.bitshiftRightSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    @inlinable public static func &>>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRight(by: NBK.leastPositiveResidue(of: rhs, dividingByBitWidthOf: Self.self))
    }
    
    @inlinable public static func &>>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs &>>= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Performs an un/signed, smart, right shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public mutating func bitshiftRightSmart(by distance: Int) {
        let size = distance.magnitude as UInt
        switch (distance >= 0, size < UInt(bitPattern: self.bitWidth)) {
        case (true,  true ): self.bitshiftRight(by: Int(bitPattern: size))
        case (true,  false): self = Self(repeating: self.isLessThanZero)
        case (false, true ): self.bitshiftLeft (by: Int(bitPattern: size))
        case (false, false): self = Self(repeating: false) }
    }
    
    /// Performs an un/signed, smart, right shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public func bitshiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftRightSmart(by: distance); return result
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftRight(words: major, bits: minor)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitshiftedRight(by distance: Int) -> Self {
        var result = self; result.bitshiftRight(by: distance); return result
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(words: Int, bits: Int) {
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        let environment: Bool = self.isLessThanZero
        NBK.bitshiftRightAsFixedLimbsCodeBlock(&self, environment: environment, limbs: words, atLeastOneBit: bits)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedRight(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftRight(words: words, bits: bits); return result
    }
        
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        let environment: Bool = self.isLessThanZero
        NBK.bitshiftRightAsFixedLimbsCodeBlock(&self, environment: environment, atLeastOneLimb: words)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public func bitshiftedRight(words: Int) -> Self {
        var result = self; result.bitshiftRight(words: words); return result
    }
}
