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
        return self.bitshiftLeft(major: major, minor: minor)
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
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftLeft(major: major)
        }
        //=--------------------------------------=
        SBI.bitshiftLeftCodeBlock(&self, environment: 0 as UInt, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedLeft(major: Int, minor: Int) -> Self {
        var result = self; result.bitshiftLeft(major: major, minor: minor); return result
    }
        
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        SBI.bitshiftLeft(&self, environment: 0 as UInt, majorAtLeastOne: major)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitshiftedLeft(major: Int) -> Self {
        var result = self; result.bitshiftLeft(major: major); return result
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
        return self.bitshiftRight(major: major, minor: minor)
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
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftRight(major: major)
        }
        //=--------------------------------------=
        let environment = UInt(repeating: self.isLessThanZero)
        SBI.bitshiftRightCodeBlock(&self, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitshiftedRight(major: Int, minor: Int) -> Self {
        var result = self; result.bitshiftRight(major: major, minor: minor); return result
    }
        
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        let environment = UInt(repeating: self.isLessThanZero)
        SBI.bitshiftRight(&self, environment: environment, majorAtLeastOne: major)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitshiftedRight(major: Int) -> Self {
        var result = self; result.bitshiftRight(major: major); return result
    }
}
