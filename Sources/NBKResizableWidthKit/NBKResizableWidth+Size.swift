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
// MARK: * NBK x Resizable Width x Size x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Resize
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func append(_ word: UInt) {
        self.storage.append(word)
    }
    
    @inlinable public mutating func reserve(minCount: Int) {
        self.storage.reserveCapacity(minCount)
    }
    
    @inlinable public mutating func resize(minCount: Int) {
        self.reserve(minCount: minCount)
        appending: while self.storage.count < minCount {
            self.storage.append(UInt.zero)
        }
    }
    
    @inlinable public mutating func resize(maxCount: Int) {
        //=--------------------------------------=
        if  self.storage.count > maxCount {
            self.storage.removeSubrange(maxCount...)
        }
        //=--------------------------------------=
        precondition(self.isOK, Self.callsiteInvariantsInfo())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable public var isNormal: Bool {
        self.storage.count == 1 || !self.last.isZero
    }
    
    @inlinable public mutating func normalize() {
        trimming: while self.storage.count > 1, self.last.isZero {
            self.storage.removeLast()
        }
    }
    
    @inlinable public mutating func normalize(assign value: UInt) {
        self.storage.removeAll(keepingCapacity: true)
        self.storage.append(value)
    }
}