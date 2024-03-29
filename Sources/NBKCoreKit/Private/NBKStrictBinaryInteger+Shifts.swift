//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Shifts x Left
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger where Base: MutableCollection {
    
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
    @inlinable public static func bitShiftLeft(
    _ base: inout Base, environment: Base.Element, majorAtLeastOne major: Int) {
        //=--------------------------------------=
        var destination = base.endIndex as Base.Index
        var source = base.index(destination, offsetBy: major.twosComplement())
        //=--------------------------------------=
        precondition(base.startIndex < base.endIndex)//   dunno, the compiler seems to have a hard time
        precondition(base.startIndex < source && source < base.endIndex, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        while destination > base.startIndex {
            let element:  Base.Element
            
            if  source  > base.startIndex {
                base.formIndex(before: &source)
                element = base[source]
            }   else {
                element = environment
            }
            
            base.formIndex(before: &destination)
            base[destination] = element
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major + Minor
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger where Base: MutableCollection {
    
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
    @inlinable public static func bitShiftLeft(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        self.bitShiftLeftCodeBlock(&base, environment: environment, major: major, minorAtLeastOne: minor)
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
    /// `@inline(always)` is required for `NBKDoubleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func bitShiftLeftCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(1 <= minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = Base.Element(truncatingIfNeeded: minor)
        let pull = push.twosComplement()
        //=--------------------------------------=
        var destination = base.endIndex as Base.Index
        var source = base.index(destination, offsetBy: major.onesComplement())
        //=--------------------------------------=
        precondition(base.startIndex <= source && source < base.endIndex, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        var element = base[source] as Base.Element
        
        while destination > base.startIndex {
            let pushed: Base.Element = element &<< push
            
            if  source  > base.startIndex {
                base.formIndex(before: &source)
                element = base[source]
            }   else {
                element = environment
            }
            
            let pulled: Base.Element = element &>> pull
            base.formIndex(before: &destination)
            base[destination] = pushed | pulled
        }
    }
}

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Shifts x Right
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger where Base: MutableCollection {
    
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
    @inlinable public static func bitShiftRight(
    _ base: inout Base, environment: Base.Element, majorAtLeastOne major: Int) {
        //=--------------------------------------=
        var destination = base.startIndex as Base.Index
        var source = base.index(destination, offsetBy: major)
        //=--------------------------------------=
        precondition(base.startIndex < source && source < base.endIndex, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        while destination < base.endIndex  {
            let element:  Base.Element
            
            if  source  < base.endIndex {
                element = base[source]
                base.formIndex(after: &source)
            }   else {
                element = environment
            }
            
            base[destination] = element
            base.formIndex(after: &destination)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major + Minor
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger where Base: MutableCollection {
    
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
    @inlinable public static func bitShiftRight(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        Self.bitShiftRightCodeBlock(&base, environment: environment, major: major, minorAtLeastOne: minor)
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
    /// `@inline(always)` is required for `NBKDoubleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func bitShiftRightCodeBlock(
    _ base: inout Base, environment: Base.Element, major: Int, minorAtLeastOne minor: Int) {
        //=--------------------------------------=
        precondition(1 <= minor && minor < Base.Element.bitWidth, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        let push = Base.Element(truncatingIfNeeded: minor)
        let pull = push.twosComplement()
        //=--------------------------------------=
        var destination = base.startIndex as Base.Index
        var source = base.index(destination, offsetBy: major)
        //=--------------------------------------=
        precondition(base.startIndex <= source && source < base.endIndex, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        var element = base[source] as Base.Element
        base.formIndex(after: &source)
        
        while destination < base.endIndex {
            let pushed: Base.Element = element &>> push
            
            if  source  < base.endIndex {
                element = base[source]
                base.formIndex(after: &source)
            }   else {
                element = environment
            }
            
            let pulled: Base.Element = element &<< pull
            base[destination] = pushed | pulled
            base.formIndex(after: &destination)
        }
    }
}
