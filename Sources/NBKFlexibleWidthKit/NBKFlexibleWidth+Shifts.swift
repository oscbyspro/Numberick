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
// MARK: * NBK x Flexible Width x Shifts x Unsigned
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitShiftLeftSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs <<= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitShiftLeftSmart(by distance: Int) {
        if  distance >= 0 {
            self.bitShiftLeft (by: distance)
        }   else {
            self.bitShiftRight(by: NBK.initOrBitCast(clamping: distance.magnitude, as: Int.self))
        }
    }
    
    @inlinable public func bitShiftedLeftSmart(by distance: Int) -> Self {
        var result = self; result.bitShiftLeftSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitShiftLeft(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitShiftLeft(major: major, minor: minor)
    }
    
    @inlinable public func bitShiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitShiftLeft(by: distance); return result
    }
    
    @inlinable public mutating func bitShiftLeft(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftLeft(major: major)
        }
        //=--------------------------------------=
        self.bitShiftLeft(major: major, minorAtLeastOne: minor)
    }
    
    @inlinable public func bitShiftedLeft(major: Int, minor: Int) -> Self {
        var result = self; result.bitShiftLeft(major: major, minor: minor); return result
    }
    
    @inlinable public mutating func bitShiftLeft(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitShiftLeft(majorAtLeastOne: major)
    }
    
    @inlinable public func bitShiftedLeft(major: Int) -> Self {
        var result = self; result.bitShiftLeft(major: major); return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Left x Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major`
    ///   - minor: `1 <= minor < UInt.bitWidth`
    ///
    @inlinable mutating func bitShiftLeft(major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        let rollover = Int(bit: self.leadingZeroBitCount < minor)
        self.storage.resize(minCount: self.storage.elements.count + major + rollover)
        
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitShiftLeft(&$0, major: major, minorAtLeastOne: minor)
        }
        
        Swift.assert(self.storage.isNormal)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major`
    ///
    @inlinable mutating func bitShiftLeft(majorAtLeastOne major: Int) {
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: self.storage.elements.count + major)
        
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitShiftLeft(&$0, majorAtLeastOne: major)
        }
        
        Swift.assert(self.storage.isNormal)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        lhs.bitShiftRightSmart(by: NBK.initOrBitCast(clamping: rhs, as: Int.self))
    }
    
    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        var lhs = lhs; lhs >>= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitShiftRightSmart(by distance: Int) {
        if  distance >= 0 {
            self.bitShiftRight(by: distance)
        }   else {
            self.bitShiftLeft (by: NBK.initOrBitCast(clamping: distance.magnitude, as: Int.self))
        }
    }
    
    @inlinable public func bitShiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitShiftRightSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitShiftRight(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitShiftRight(major: major, minor: minor)
    }
    
    @inlinable public func bitShiftedRight(by distance: Int) -> Self {
        var result = self; result.bitShiftRight(by: distance); return result
    }
    
    @inlinable public mutating func bitShiftRight(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftRight(major: major)
        }
        //=--------------------------------------=
        self.bitShiftRight(major: major, minorAtLeastOne: minor)
    }
    
    @inlinable public func bitShiftedRight(major: Int, minor: Int) -> Self {
        var result = self; result.bitShiftRight(major: major, minor: minor); return result
    }
    
    @inlinable public mutating func bitShiftRight(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitShiftRight(majorAtLeastOne: major)
    }
    
    @inlinable public func bitShiftedRight(major: Int) -> Self {
        var result = self; result.bitShiftRight(major: major); return result
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right x Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable mutating func bitShiftRight(major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        let rollover = Int(bit: 0 <= minor + self.leadingZeroBitCount - UInt.bitWidth)
        let maxCount = self.storage.elements.count - major - rollover
        //=--------------------------------------=
        if  maxCount <= 0 {
            return self.update(0 as UInt)
        }
        //=--------------------------------------=
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitShiftRight(&$0, major: major, minorAtLeastOne: minor)
        }
        
        self.storage.resize(maxCount: maxCount)
        Swift.assert(self.storage.isNormal)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major`
    ///
    @inlinable mutating func bitShiftRight(majorAtLeastOne major: Int) {
        //=--------------------------------------=
        if  self.storage.elements.count <= major {
            return self.update(0 as UInt)
        }
        //=--------------------------------------=
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitShiftRight(&$0, majorAtLeastOne: major)
        }
        
        self.storage.resize(maxCount: self.storage.elements.count - major)
        Swift.assert(self.storage.isNormal)
    }
}
