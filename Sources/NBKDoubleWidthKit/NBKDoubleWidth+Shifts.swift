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
        lhs.bitShiftLeftSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    @inlinable public static func &<<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitShiftLeft(by: NBK.leastPositiveResidue(dividing: rhs, by: NBK.NonZero(unchecked: Self.bitWidth)))
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
    @inlinable public mutating func bitShiftLeftSmart(by distance: Int) {
        let size = distance.magnitude as UInt
        switch (distance >= 0, size < UInt(bitPattern: self.bitWidth)) {
        case (true,  true ): self.bitShiftLeft (by: Int(bitPattern: size))
        case (true,  false): self = Self(repeating: false)
        case (false, true ): self.bitShiftRight(by: Int(bitPattern: size))
        case (false, false): self = Self(repeating: self.isLessThanZero) }
    }
    
    /// Performs a smart left shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public func bitShiftedLeftSmart(by distance: Int) -> Self {
        var result = self; result.bitShiftLeftSmart(by: distance); return result
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitShiftLeft(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitShiftLeft(major: major, minor: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitShiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitShiftLeft(by: distance); return result
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitShiftLeft(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftLeft(major: major)
        }
        //=--------------------------------------=
        NBK.SBI.bitShiftLeftCodeBlock(&self, environment: 0 as UInt, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitShiftedLeft(major: Int, minor: Int) -> Self {
        var result = self; result.bitShiftLeft(major: major, minor: minor); return result
    }
        
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitShiftLeft(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        NBK.SBI.bitShiftLeft(&self, environment: 0 as UInt, majorAtLeastOne: major)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitShiftedLeft(major: Int) -> Self {
        var result = self; result.bitShiftLeft(major: major); return result
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
        lhs.bitShiftRightSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    @inlinable public static func &>>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitShiftRight(by: NBK.leastPositiveResidue(dividing: rhs, by: NBK.NonZero(unchecked: Self.bitWidth)))
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
    @inlinable public mutating func bitShiftRightSmart(by distance: Int) {
        let size = distance.magnitude as UInt
        switch (distance >= 0, size < UInt(bitPattern: self.bitWidth)) {
        case (true,  true ): self.bitShiftRight(by: Int(bitPattern: size))
        case (true,  false): self = Self(repeating: self.isLessThanZero)
        case (false, true ): self.bitShiftLeft (by: Int(bitPattern: size))
        case (false, false): self = Self(repeating: false) }
    }
    
    /// Performs an un/signed, smart, right shift.
    ///
    /// - Parameters:
    ///   - distance: `Int.min <= distance <= Int.max`
    ///
    @inlinable public func bitShiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitShiftRightSmart(by: distance); return result
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitShiftRight(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitShiftRight(major: major, minor: minor)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitShiftedRight(by distance: Int) -> Self {
        var result = self; result.bitShiftRight(by: distance); return result
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitShiftRight(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftRight(major: major)
        }
        //=--------------------------------------=
        let environment = UInt(repeating: self.isLessThanZero)
        NBK.SBI.bitShiftRightCodeBlock(&self, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitShiftedRight(major: Int, minor: Int) -> Self {
        var result = self; result.bitShiftRight(major: major, minor: minor); return result
    }
        
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitShiftRight(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        let environment = UInt(repeating: self.isLessThanZero)
        NBK.SBI.bitShiftRight(&self, environment: environment, majorAtLeastOne: major)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitShiftedRight(major: Int) -> Self {
        var result = self; result.bitShiftRight(major: major); return result
    }
}
