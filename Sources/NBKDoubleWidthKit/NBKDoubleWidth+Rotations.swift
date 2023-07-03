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
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public mutating func bitrotateLeft(by distance: Int) {
        self = self.bitrotatedLeft(by: distance)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public func bitrotatedLeft(by distance: Int) -> Self {
        precondition(distance >= 0, "rotation distance must be at least zero")
        let major  = distance .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = distance.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitrotatedLeft(words: major, bits: minor)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateLeft(words: Int, bits: Int) {
        self = self.bitrotatedLeft(words: words, bits: bits)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedLeft(words: Int, bits: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor rotation distance")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitrotatedLeft(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        return Self.uninitialized { result in
            var (word) = self.last as UInt
            var destination = words
            for source in self.indices {
                //=------------------------------=
                let pulled = word &>> pull
                (word) = self[source]
                let pushed = word &<< push
                result[destination] = pulled | pushed
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
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitrotateLeft(words: Int) {
        self = self.bitrotatedLeft(words: words)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitrotatedLeft(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return Self.uninitialized { result in
            var destination = words
            for source in self.indices {
                //=------------------------------=
                result[destination] = self[source]
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
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public mutating func bitrotateRight(by distance: Int) {
        self = self.bitrotatedRight(by: distance)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable public func bitrotatedRight(by distance: Int) -> Self {
        precondition(distance >= 0, "rotation distance must be at least zero")
        let major  = distance .quotientDividingByBitWidthAssumingIsAtLeastZero()
        let minor  = distance.remainderDividingByBitWidthAssumingIsAtLeastZero()
        return self.bitrotatedRight(words: major, bits: minor)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitrotateRight(words: Int, bits: Int) {
        self = self.bitrotatedRight(words: words, bits: bits)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public func bitrotatedRight(words: Int, bits: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        precondition(0 ..< UInt.bitWidth ~= bits,  "invalid minor rotation distance")
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitrotatedRight(words: words)
        }
        //=--------------------------------------=
        let push = UInt(bitPattern: bits)
        let pull = UInt(bitPattern: UInt.bitWidth - bits)
        //=--------------------------------------=
        return Self.uninitialized { result in
            var (word) = self.last as UInt
            var destination =  result.endIndex &+ ~(words)
            precondition(0 ..< result.endIndex ~= destination)
            for source in self.indices {
                //=------------------------------=
                let pulled = word &>> push
                (word) = self[source]
                let pushed = word &<< pull
                result[destination] = pulled | pushed
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
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitrotateRight(words: Int) {
        self = self.bitrotatedRight(words: words)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitrotatedRight(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return Self.uninitialized { result in
            var destination =  result.endIndex &- words
            precondition(0 ..< result.endIndex ~= destination)
            for source in self {
                //=------------------------------=
                result[destination] = source
                //=------------------------------=
                result.formIndex(after: &destination)
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
}
