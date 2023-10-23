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
    @inlinable public static func bitShiftLeft(_ base: inout Base, by distance: Int) {
        let (major, minor) = distance.quotientAndRemainder(dividingBy: Base.Element.bitWidth)
        return self.bitShiftLeft(&base, major: major, minor: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - minor: `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitShiftLeft(_ base: inout Base, major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftLeft(&base, major: major)
        }
        //=--------------------------------------=
        self.bitShiftLeft(&base, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public static func bitShiftLeft(_ base: inout Base, major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitShiftLeft(&base, majorAtLeastOne: major)
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
    @inlinable public static func bitShiftLeft(_ base: inout Base, major: Int, minorAtLeastOne minor: Int) {
        Binary.bitShiftLeft(&base, environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public static func bitShiftLeft(_ base: inout Base, majorAtLeastOne major: Int) {
        Binary.bitShiftLeft(&base, environment: 0 as Base.Element, majorAtLeastOne: major)
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
    @inlinable public static func bitShiftRight(_ base: inout Base, by distance: Int) {
        let (major, minor) = distance.quotientAndRemainder(dividingBy: Base.Element.bitWidth)
        return self.bitShiftRight(&base, major: major, minor: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - bits:  `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitShiftRight(_ base: inout Base, major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitShiftRight(&base, major: major)
        }
        //=--------------------------------------=
        self.bitShiftRight(&base, major: major, minorAtLeastOne: minor)
    }
        
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public static func bitShiftRight(_ base: inout Base, major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitShiftRight(&base, majorAtLeastOne: major)
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
    @inlinable public static func bitShiftRight(_ base: inout Base, major: Int, minorAtLeastOne minor: Int) {
        Binary.bitShiftRight(&base, environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public static func bitShiftRight(_ base: inout Base, majorAtLeastOne major: Int) {
        Binary.bitShiftRight(&base, environment: 0 as Base.Element, majorAtLeastOne: major)
    }
}
