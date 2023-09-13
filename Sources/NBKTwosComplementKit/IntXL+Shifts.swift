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
// MARK: * NBK x Flexible Width x Shifts
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftLeftSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitshiftLeftSmart(by distance: Int) {
        if  distance >= 0 {
            self.bitshiftLeft (by: distance)
        }   else {
            self.bitshiftRight(by: Int(clamping: distance.magnitude))
        }
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
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        self.bitshiftLeft(words: words, atLeastOneBit: bits)
    }
    
    @inlinable public func bitshiftedLeft(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words, bits: bits); return result
    }
    
    @inlinable public mutating func bitshiftLeft(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        self.bitshiftLeft(atLeastOneWord: words)
    }
    
    @inlinable public func bitshiftedLeft(words: Int) -> Self {
        var result = self; result.bitshiftLeft(words: words); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=
        
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words`
    ///   - bits:  `1 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
        defer {
            Swift.assert(Self.isNormal(self.storage))
        }
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        let rollover = Int(bit: self.leadingBitCount(self.isLessThanZero) < bits)
        self.storage.resize(minCount: self.storage.elements.count + words + rollover, appending: 0 as UInt)
        self.storage.bitshiftLeft(words: words, atLeastOneBit: bits)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words`
    ///
    @inlinable mutating func bitshiftLeft(atLeastOneWord words: Int) {
        defer {
            Swift.assert(Self.isNormal(self.storage))
        }
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: self.storage.elements.count + words, appending: 0 as UInt)
        self.storage.bitshiftLeft(atLeastOneWord: words)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitshiftRightSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }

    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitshiftRightSmart(by distance: Int) {
        if  distance >= 0 {
            self.bitshiftRight(by: distance)
        }   else {
            self.bitshiftLeft(by: Int(clamping: distance.magnitude))
        }
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
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        self.bitshiftRight(words: words, atLeastOneBit: bits)
    }
    
    @inlinable public func bitshiftedRight(words: Int, bits: Int) -> Self {
        var result = self; result.bitshiftRight(words: words, bits: bits); return result
    }
    
    @inlinable public mutating func bitshiftRight(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        self.bitshiftRight(atLeastOneWord: words)
    }
    
    @inlinable public func bitshiftedRight(words: Int) -> Self {
        var result = self; result.bitshiftRight(words: words); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func bitshiftRight(words: Int, atLeastOneBit bits: Int) {
        defer {
            Swift.assert(Self.isNormal(self.storage))
        }
        //=--------------------------------------=
        let rollover = Int(bit: 0 <= bits + self.leadingZeroBitCount - UInt.bitWidth)
        let maxCount = self.storage.elements.count - words - rollover
        //=--------------------------------------=
        if  maxCount <= 0 {
            return self.update(Digit(repeating: self.isLessThanZero))
        }
        //=--------------------------------------=
        self.storage.bitshiftRight(isSigned: Self.isSigned, words: words, atLeastOneBit: bits)
        self.storage.resize(maxCount: maxCount)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words`
    ///
    @inlinable mutating func bitshiftRight(atLeastOneWord words: Int) {
        defer {
            Swift.assert(Self.isNormal(self.storage))
        }
        //=--------------------------------------=
        if  self.storage.elements.count <= words {
            return self.update(Digit(repeating: self.isLessThanZero))
        }
        //=--------------------------------------=
        self.storage.bitshiftRight(isSigned: Self.isSigned, atLeastOneWord: words)
        self.storage.resize(maxCount: self.storage.elements.count - words)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Shifts x Storage
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension StorageXL {

    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `1 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words < self.endIndex`
    ///
    @inlinable mutating func bitshiftLeft(atLeastOneWord words: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension StorageXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable mutating func bitshiftRight(isSigned: Bool, words: Int, atLeastOneBit bits: Int) {
        let environment = isSigned && self.last.mostSignificantBit
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: environment, limbs: words, atLeastOneBit: bits)
        }
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `1 <= words < self.endIndex`
    ///
    @inlinable mutating func bitshiftRight(isSigned: Bool, atLeastOneWord words: Int) {
        let environment = isSigned && self.last.mostSignificantBit
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: environment, atLeastOneLimb: words)
        }
    }
}