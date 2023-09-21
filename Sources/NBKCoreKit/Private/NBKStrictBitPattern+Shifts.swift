//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Bit Pattern x Shifts x Left
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public static func bitshiftLeft(
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
// MARK: + Major + Minor
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftLeft(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        self.bitshiftLeftCodeBlock(&base, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a left shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    /// ### Development
    ///
    /// - `@inline(always)` is required for `NBKDoubleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func bitshiftLeftCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = push.twosComplement()
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
}

//*============================================================================*
// MARK: * NBK x Strict Bit Pattern x Shifts x Right
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `1 <= major < base.count`
    ///
    @inlinable public static func bitshiftRight(
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

//=----------------------------------------------------------------------------=
// MARK: + Major + Minor
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    @inlinable public static func bitshiftRight(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        Self.bitshiftRightCodeBlock(&base, environment: environment, major: major, minorAtLeastOne: minor)
    }
    
    /// Performs a right shift, assuming the `base` is ordered from least to most significant.
    ///
    /// - Parameters:
    ///   - base: The mutable collection.
    ///   - environment: The element used to fill the void.
    ///   - major: `0 <= major < base.count`
    ///   - minor: `1 <= minor < Base.Element.bitWidth`
    ///
    /// ### Development
    ///
    /// - `@inline(always)` is required for `NBKDoubleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func bitshiftRightCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(0 <  minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = push.twosComplement()
        //=--------------------------------------=
        var destination = base.startIndex
        var element = base[major] as Base.Element
        //=--------------------------------------=
        while destination < base.endIndex {
            let after  = destination &+ 1
            let source = after   &+ major
            let pushed = element &>> push
            element = source < base.endIndex ? base[source] : environment
            let pulled = element &<< pull
            base[destination] = pushed | pulled
            destination = after as Base.Index
        }
    }
}
