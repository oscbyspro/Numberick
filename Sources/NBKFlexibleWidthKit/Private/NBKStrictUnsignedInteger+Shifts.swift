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
// MARK: * NBK x Strict Unsigned Integer x Shifts
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection, Base.Indices == Range<Int> { // TODO: remove range req.
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < base.bitWidth`
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
    ///   - major: `0 <= major < base.endIndex`
    ///   - minor: `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftLeft(major: major)
        }
        //=--------------------------------------=
        self.bitshiftLeft(major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftLeft(majorAtLeastOne: major)
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
    @inlinable public mutating func bitshiftLeft(major: Int, minorAtLeastOne minor: Int) {
        self.bitPattern.bitshiftLeft(environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(majorAtLeastOne major: Int) {
        self.bitPattern.bitshiftLeft(environment: 0 as Base.Element, majorAtLeastOne: major)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection, Base.Indices == Range<Int> { // TODO: remove range req.
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < base.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftRight(major: major, minor: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///   - bits:  `0 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(major: Int, minor: Int) {
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitshiftRight(major: major)
        }
        //=--------------------------------------=
        self.bitshiftRight(major: major, minorAtLeastOne: minor)
    }
        
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < base.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(major: Int) {
        //=--------------------------------------=
        if  major.isZero { return }
        //=--------------------------------------=
        self.bitshiftRight(majorAtLeastOne: major)
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
    @inlinable public mutating func bitshiftRight(major: Int, minorAtLeastOne minor: Int) {
        self.bitPattern.bitshiftRight(environment: 0 as Base.Element, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs an unsigned right shift.
    ///
    /// - Parameters:
    ///   - major: `1 <= major < base.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(majorAtLeastOne major: Int) {
        self.bitPattern.bitshiftRight(environment: 0 as Base.Element, majorAtLeastOne: major)
    }
}
