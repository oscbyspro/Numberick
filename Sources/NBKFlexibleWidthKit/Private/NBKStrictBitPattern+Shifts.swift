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
// MARK: * NBK x Strict Bit Pattern x Shifts
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKStrictBitPattern where Base: MutableCollection, Base.Indices == Range<Int> {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - pointee: The mutable collection.
    ///   - environment: The bit used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(environment: Bool, major: Int, minorAtLeastOne minor: Int) {
        precondition(0 <= major && major < self.base.count/*--*/, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = NBK.initOrBitCast(truncating: Base.Element.bitWidth - minor, as: Base.Element.self)
        let fill = Base.Element(repeating: environment)
        //=--------------------------------------=
        var destination = self.base.endIndex as Int
        let offset: Int = ~(major)
        var element = self.base[destination &+ offset]
        //=--------------------------------------=
        while destination > self.base.startIndex {
            self.base.formIndex(before: &destination)
            let pushed = element &<< push
            element = destination > major ? self.base[destination &+ offset] : fill
            let pulled = element &>> pull
            self.base[destination] = pushed | pulled
        }
    }
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The bit used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public mutating func bitshiftLeft(environment: Bool, majorAtLeastOne major: Int) {
        precondition(0 < major && major < self.base.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let fill = Base.Element(repeating: environment)
        //=--------------------------------------=
        for destination in self.base.indices.reversed() {
            self.base[destination] = destination >= major ? self.base[destination - major] : fill
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKStrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The bit used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(environment: Bool, major: Int, minorAtLeastOne minor: Int) {
        precondition(0 <= major && major < self.base.count/*--*/, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = NBK.initOrBitCast(truncating: Base.Element.bitWidth - minor, as: Base.Element.self)
        let fill = Base.Element(repeating: environment)
        //=--------------------------------------=
        var destination = self.base.startIndex
        let edge = self.base.distance(from: major, to: self.base.endIndex)
        var element = self.base[major] as Base.Element
        //=--------------------------------------=
        while destination < self.base.endIndex {
            let after  = self.base.index(after: destination)
            let pushed = element &>> push
            element = after < edge ? self.base[after &+ major] : fill
            let pulled = element &<< pull
            self.base[destination] = pushed | pulled
            destination = after
        }
    }
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The bit used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public mutating func bitshiftRight(environment: Bool, majorAtLeastOne major: Int) {
        precondition(0 < major && major < self.base.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=--=
        let fill = Base.Element(repeating: environment)
        //=--------------------------------------=
        let edge = self.base.distance(from: major, to: self.base.endIndex)
        //=--------------------------------------=
        for destination in self.base.indices {
            self.base[destination] = destination < edge ? self.base[destination + major] : fill
        }
    }
}
