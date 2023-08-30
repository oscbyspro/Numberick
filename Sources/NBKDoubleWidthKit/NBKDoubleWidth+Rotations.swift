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
        return self.bitrotatedLeft(words: major, bits: minor)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateLeft(words: Int, bits: Int) {
        self = self.bitrotatedLeft(words: words, bits: bits)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedLeft(words: Int, bits: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, NBK.callsiteOutOfBoundsInfo())
        precondition(0 ..< UInt.bitWidth ~= bits,  NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitrotatedLeft(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            var word = self.last as UInt
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.startIndex, offsetBy: words)
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
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitrotateLeft(words: Int) {
        self = self.bitrotatedLeft(words: words)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public func bitrotatedLeft(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.startIndex, offsetBy: words)
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
        return self.bitrotatedRight(words: major, bits: minor)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateRight(words: Int, bits: Int) {
        self = self.bitrotatedRight(words: words, bits: bits)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedRight(words: Int, bits: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, NBK.callsiteOutOfBoundsInfo())
        precondition(0 ..< UInt.bitWidth ~= bits,  NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitrotatedRight(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            var word = self.last as UInt
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.endIndex, offsetBy: ~words)
            //=----------------------------------=
            precondition(result.indices ~= destination)
            for source in  self.indices {
                //=------------------------------=
                let pulled = word &>> push
                (word) = self[source]
                let pushed = word &<< pull
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
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitrotateRight(words: Int) {
        self = self.bitrotatedRight(words: words)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public func bitrotatedRight(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return  Self.uninitialized(as: UInt.self) {
            let result = NBKTwinHeaded($0, reversed: NBK.isBigEndian)
            var destination = result.index(result.endIndex, offsetBy: -words)
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
