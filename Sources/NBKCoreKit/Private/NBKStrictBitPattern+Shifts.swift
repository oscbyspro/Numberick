//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Bit Pattern x Shifts
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        Self.bitshiftLeftCodeBlock(&self.storage, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public mutating func bitshiftLeft(environment: Base.Element, majorAtLeastOne major: Int) {
        Self.bitshiftLeftCodeBlock(&self.storage, environment: environment, majorAtLeastOne: major)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms (pointerless performance)
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inline(__always) @inlinable public static func bitshiftLeftCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push: Base.Element = NBK.initOrBitCast(truncating: minor)
        let pull: Base.Element = push.twosComplement()
        //=--------------------------------------=
        let offset: Int = major.onesComplement()
        var destination = base.endIndex as Base.Index
        var element = base[destination &+ offset]
        //=--------------------------------------=
        while destination > base.startIndex {
            base.formIndex(before: &destination)
            let pushed = element &<< push
            element = destination > major ? base[destination &+ offset] : environment
            let pulled = element &>> pull
            base[destination] = pushed | pulled
        }
    }

    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inline(__always) @inlinable public static func bitshiftLeftCodeBlock(
    _ base: inout Base, environment: Base.Element, majorAtLeastOne major: Int) {
        //=--------------------------------------=
        // major: zero works but it is pointless
        //=--------------------------------------=
        Swift.assert(000000000001 <= major, NBK.callsiteOutOfBoundsInfo())
        precondition(base.indices ~= major, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let offset: Int = major.twosComplement()
        var destination = base.endIndex as Base.Index
        //=--------------------------------------=
        while destination > base.startIndex {
            base.formIndex(before: &destination)
            base[destination] = destination >= major ? base[destination &+ offset] : environment
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        Self.bitshiftRightCodeBlock(&self.storage, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public mutating func bitshiftRight(environment: Base.Element, majorAtLeastOne major: Int) {
        Self.bitshiftRightCodeBlock(&self.storage, environment: environment, majorAtLeastOne: major)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms (pointerless performance)
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inline(__always) @inlinable public static func bitshiftRightCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push: Base.Element = NBK.initOrBitCast(truncating: minor)
        let pull: Base.Element = push.twosComplement()
        //=--------------------------------------=
        var destination = base.startIndex as Base.Index
        var source  = base.index(destination, offsetBy: major)
        var element = base[NBK.index(base, pushing: &source)]
        //=--------------------------------------=
        while destination < base.endIndex {
            let pushed = element &>> push
            element = source < base.endIndex ? base[NBK.index(base, pushing: &source)] : environment
            let pulled = element &<< pull
            base[destination] = pushed | pulled
            base.formIndex(after: &destination)
        }
    }
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inline(__always) @inlinable public static func bitshiftRightCodeBlock(
    _ base: inout Base, environment: Base.Element, majorAtLeastOne major: Int) {
        //=--------------------------------------=
        // major: zero works but it is pointless
        //=--------------------------------------=
        Swift.assert(000000000001 <= major, NBK.callsiteOutOfBoundsInfo())
        precondition(base.indices ~= major, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let edge = base.endIndex &+ major.onesComplement()
        var destination = base.startIndex as Base.Index
        //=--------------------------------------=
        while destination < base.endIndex {
            base[destination] = destination <= edge ? base[destination &+ major] : environment
            base.formIndex(after: &destination)
        }
    }
}
