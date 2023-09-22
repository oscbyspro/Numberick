//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Shifts
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < base.bitWidth`
    ///
    @inlinable public static func bitshiftLeft(_ base: inout Base, by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftLeft(&base, major: major, minor: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - minor: `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftLeft(_ base: inout Base, major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftLeft(&base, major: major)
        }
        //=--------------------------------------=
        self.bitshiftLeft(&base, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public static func bitshiftLeft(_ base: inout Base, major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftLeft(&base, majorAtLeastOne: major)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftLeft(_ base: inout Base, major: Int, minorAtLeastOne minor: Int) {
        Binary.bitshiftLeft(&base, environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public static func bitshiftLeft(_ base: inout Base, majorAtLeastOne major: Int) {
        Binary.bitshiftLeft(&base, environment: 0 as Base.Element, majorAtLeastOne: major)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < base.bitWidth`
    ///
    @inlinable public static func bitshiftRight(_ base: inout Base, by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftRight(&base, major: major, minor: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - bits:  `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftRight(_ base: inout Base, major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftRight(&base, major: major)
        }
        //=--------------------------------------=
        self.bitshiftRight(&base, major: major, minorAtLeastOne: minor)
    }
        
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public static func bitshiftRight(_ base: inout Base, major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftRight(&base, majorAtLeastOne: major)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms
    //=------------------------------------------------------------------------=

    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftRight(_ base: inout Base, major: Int, minorAtLeastOne minor: Int) {
        Binary.bitshiftRight(&base, environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public static func bitshiftRight(_ base: inout Base, majorAtLeastOne major: Int) {
        Binary.bitshiftRight(&base, environment: 0 as Base.Element, majorAtLeastOne: major)
    }
}
