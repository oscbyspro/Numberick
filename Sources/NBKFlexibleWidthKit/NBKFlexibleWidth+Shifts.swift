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
            self.bitshiftRight(by: NBK.initOrBitCast(clamping: distance.magnitude, as: Int.self))
        }
    }
    
    @inlinable public func bitshiftedLeftSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftLeftSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftLeft(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitshiftLeft(major: major, minor: minor)
    }
    
    @inlinable public func bitshiftedLeft(by distance: Int) -> Self {
        var result = self; result.bitshiftLeft(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftLeft(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftLeft(major: major)
        }
        //=--------------------------------------=
        self.bitshiftLeft(major: major, minorAtLeastOne: minor)
    }
    
    @inlinable public func bitshiftedLeft(major: Int, minor: Int) -> Self {
        var result = self; result.bitshiftLeft(major: major, minor: minor); return result
    }
    
    @inlinable public mutating func bitshiftLeft(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftLeft(majorAtLeastOne: major)
    }
    
    @inlinable public func bitshiftedLeft(major: Int) -> Self {
        var result = self; result.bitshiftLeft(major: major); return result
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
    @inlinable mutating func bitshiftLeft(major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        let rollover = Int(bit: self.leadingZeroBitCount < minor)
        self.storage.resize(minCount: self.storage.elements.count + major + rollover)
        
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitshiftLeft(&$0, major: major, minorAtLeastOne: minor)
        }
        
        Swift.assert(self.storage.isNormal)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major`
    ///
    @inlinable mutating func bitshiftLeft(majorAtLeastOne major: Int) {
        //=--------------------------------------=
        if  self.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: self.storage.elements.count + major)
        
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitshiftLeft(&$0, majorAtLeastOne: major)
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
            self.bitshiftLeft (by: NBK.initOrBitCast(clamping: distance.magnitude, as: Int.self))
        }
    }
    
    @inlinable public func bitshiftedRightSmart(by distance: Int) -> Self {
        var result = self; result.bitshiftRightSmart(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftRight(@NBK.ZeroOrMore by distance: Int) {
        let major = NBK .quotient(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: $distance, by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.bitshiftRight(major: major, minor: minor)
    }
    
    @inlinable public func bitshiftedRight(by distance: Int) -> Self {
        var result = self; result.bitshiftRight(by: distance); return result
    }
    
    @inlinable public mutating func bitshiftRight(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftRight(major: major)
        }
        //=--------------------------------------=
        self.bitshiftRight(major: major, minorAtLeastOne: minor)
    }
    
    @inlinable public func bitshiftedRight(major: Int, minor: Int) -> Self {
        var result = self; result.bitshiftRight(major: major, minor: minor); return result
    }
    
    @inlinable public mutating func bitshiftRight(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftRight(majorAtLeastOne: major)
    }
    
    @inlinable public func bitshiftedRight(major: Int) -> Self {
        var result = self; result.bitshiftRight(major: major); return result
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
    @inlinable mutating func bitshiftRight(major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        let rollover = Int(bit: 0 <= minor + self.leadingZeroBitCount - UInt.bitWidth)
        let maxCount = self.storage.elements.count - major - rollover
        //=--------------------------------------=
        if  maxCount <= 0 {
            return self.update(0 as UInt)
        }
        //=--------------------------------------=
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitshiftRight(&$0, major: major, minorAtLeastOne: minor)
        }
        
        self.storage.resize(maxCount: maxCount)
        Swift.assert(self.storage.isNormal)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major`
    ///
    @inlinable mutating func bitshiftRight(majorAtLeastOne major: Int) {
        //=--------------------------------------=
        if  self.storage.elements.count <= major {
            return self.update(0 as UInt)
        }
        //=--------------------------------------=
        self.storage.withUnsafeMutableBufferPointer {
            NBK.SUI.bitshiftRight(&$0, majorAtLeastOne: major)
        }
        
        self.storage.resize(maxCount: self.storage.elements.count - major)
        Swift.assert(self.storage.isNormal)
    }
}
