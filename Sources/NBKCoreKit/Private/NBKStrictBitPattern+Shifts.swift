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
    // MARK: Transformations x Algorithms (performance)
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
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(1 <= minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = NBK.initOrBitCast(truncating: Base.Element.bitWidth - minor, as: Base.Element.self)
        //=--------------------------------------=
        let offset: Int = major.onesComplement()
        var destination = base.endIndex as Base.Index
        let edge    = base.index(base.startIndex,  offsetBy: major)
        var element = base[base.index(destination, offsetBy: offset)]
        //=--------------------------------------=
        while destination > base.startIndex {
            base.formIndex(before: &destination)
            let pushed = element &<< push
            element = destination >  edge ? base[base.index(destination, offsetBy: offset)] : environment
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
        precondition(1 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let offset: Int = major.twosComplement()
        var destination = base.endIndex as Base.Index
        let edge = base.index(base.startIndex, offsetBy: major)
        //=--------------------------------------=
        while destination > base.startIndex {
            base.formIndex(before: &destination)
            base[destination] = destination >= edge ? base[base.index(destination, offsetBy: offset)] : environment
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
    // MARK: Transformations x Algorithms (performance)
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
        precondition(0 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        precondition(1 <= minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = NBK.initOrBitCast(truncating: minor, as: Base.Element.self)
        let pull = NBK.initOrBitCast(truncating: Base.Element.bitWidth - minor, as: Base.Element.self)
        //=--------------------------------------=
        var destination = base.startIndex as Base.Index
        let edge = base.index(base.endIndex, offsetBy: major.onesComplement())
        var element = base[base.index(destination, offsetBy: major)]
        //=--------------------------------------=
        while destination < base.endIndex {
            let after  = base.index(after: destination)
            let pushed = element &>> push
            element    = after    <= edge ? base[base.index(after, offsetBy: major)] : environment
            let pulled = element &<< pull
            base[destination] = pushed | pulled
            destination = after as Base.Index
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
        precondition(1 <= major && major < base.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        var destination = base.startIndex as Base.Index
        let edge = base.index(base.endIndex, offsetBy: major.onesComplement())
        //=--------------------------------------=
        while destination < base.endIndex {
            base[destination] = destination <= edge ? base[base.index(destination, offsetBy: major)] : environment
            base.formIndex(after: &destination)
        }
    }
}
