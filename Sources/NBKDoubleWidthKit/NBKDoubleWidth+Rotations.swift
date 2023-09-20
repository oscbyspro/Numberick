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
// MARK: * NBK x Double Width x Rotations x Left
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitrotateLeft(by distance: Int) {
        self = self.bitrotatedLeft(by: distance)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitrotatedLeft(by distance: Int) -> Self {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitrotatedLeft(major: major, minor:minor)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateLeft(major: Int, minor:Int) {
        self = self.bitrotatedLeft(major: major, minor:minor)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedLeft(major: Int, minor:Int) -> Self {
        precondition(0 ..< self.endIndex ~= major, NBK.callsiteOutOfBoundsInfo())
        precondition(0 ..< UInt.bitWidth ~= minor, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitrotatedLeft(major: major)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: minor)
        let pull = UInt(bitPattern: UInt.bitWidth - minor)
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            var (word) = self.last as  UInt
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.startIndex, offsetBy: major)
            //=----------------------------------=
            for source in self.indices {
                //=------------------------------=
                let pulled = word &>> pull
                (word) = self[source]
                let pushed = word &<< push
                //=------------------------------=
                result.base.baseAddress!.advanced(by: result.baseSubscriptIndex(destination)).initialize(to: pulled | pushed)
                //=------------------------------=
                result.formIndex(after: &destination)
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitrotateLeft(major: Int) {
        self = self.bitrotatedLeft(major: major)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitrotatedLeft(major: Int) -> Self {
        precondition(0 ..< self.endIndex ~= major, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  major.isZero { return self }
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.startIndex, offsetBy: major)
            //=----------------------------------=
            for source in self.indices {
                //=------------------------------=
                result.base.baseAddress!.advanced(by: result.baseSubscriptIndex(destination)).initialize(to: self[source])
                //=------------------------------=
                result.formIndex(after: &destination)
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Rotations x Right
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitrotateRight(by distance: Int) {
        self = self.bitrotatedRight(by: distance)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public func bitrotatedRight(by distance: Int) -> Self {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitrotatedRight(major: major, minor:minor)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateRight(major: Int, minor:Int) {
        self = self.bitrotatedRight(major: major, minor:minor)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///   - minor: `0 <= minor < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedRight(major: Int, minor:Int) -> Self {
        precondition(0 ..< self.endIndex ~= major, NBK.callsiteOutOfBoundsInfo())
        precondition(0 ..< UInt.bitWidth ~= minor, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  minor.isZero {
            return self.bitrotatedRight(major: major)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: minor)
        let pull = UInt(bitPattern: UInt.bitWidth - minor)
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            var (word) = self.last as  UInt
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.endIndex, offsetBy: ~major)
            //=----------------------------------=
            precondition(result.indices ~= destination)
            for source in  self.indices {
                //=------------------------------=
                let pushed = word &>> push
                (word) = self[source]
                let pulled = word &<< pull
                //=------------------------------=
                result.base.baseAddress!.advanced(by: result.baseSubscriptIndex(destination)).initialize(to: pushed | pulled)
                //=------------------------------=
                result.formIndex(after: &destination)
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public mutating func bitrotateRight(major: Int) {
        self = self.bitrotatedRight(major: major)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - major: `0 <= major < self.endIndex`
    ///
    @inlinable public func bitrotatedRight(major: Int) -> Self {
        precondition(0 ..< self.endIndex ~= major, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  major.isZero { return self }
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.endIndex, offsetBy: -major)
            //=----------------------------------=
            precondition(result.indices ~= destination)
            for source in  self.indices {
                //=------------------------------=
                result.base.baseAddress!.advanced(by: result.baseSubscriptIndex(destination)).initialize(to: self[source])
                //=------------------------------=
                result.formIndex(after: &destination)
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
}
