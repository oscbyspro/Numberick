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
// MARK: * NBK x Resizable Width x Shifts x Unsigned
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftLeft(words: major, bits: minor)
    }
    
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int, bits: Int) {
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftLeft(words: words)
        }
        //=--------------------------------------=
        self.bitshiftLeft(words: words, atLeastOneBit: bits)
    }
        
    /// Performs a left shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitshiftLeft(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        self.bitshiftLeft(atLeastOneWord: words)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=

    // TODO: internal
    @inlinable public mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
        self.storage.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }

    // TODO: internal
    @inlinable public mutating func bitshiftLeft(atLeastOneWord words: Int) {
        self.storage.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Right
    //=------------------------------------------------------------------------=
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < self.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(distance >= 0, NBK.callsiteOutOfBoundsInfo())
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(distance)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(distance)
        return self.bitshiftRight(words: major, bits: minor)
    }
    
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///   - bits:  `0 <= bits  < UInt.bitWidth`
    ///
    @inlinable public mutating func bitshiftRight(words: Int, bits: Int) {
        //=--------------------------------------=
        if  bits.isZero {
            return self.bitshiftRight(words: words)
        }
        //=--------------------------------------=
        self.bitshiftRight(words: words, atLeastOneBit: bits)
    }
        
    /// Performs an un/signed right shift.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < self.endIndex`
    ///
    @inlinable public mutating func bitshiftRight(words: Int) {
        //=--------------------------------------=
        if  words.isZero { return }
        //=--------------------------------------=
        self.bitshiftRight(atLeastOneWord: words)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int x Private
    //=------------------------------------------------------------------------=

    // TODO: internal
    @inlinable public mutating func bitshiftRight(words: Int, atLeastOneBit bits: Int) {
        self.storage.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }
    
    // TODO: internal
    @inlinable public mutating func bitshiftRight(atLeastOneWord words: Int) {
        self.storage.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}
