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
    // MARK: Details x Count
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func reserve(minCount: Int) {
        self.storage.reserveCapacity(minCount)
    }
    
    @inlinable mutating func resize(minCount: Int) {
        self.reserve(minCount: minCount)
        appending: while self.storage.count < minCount {
            self.storage.append(UInt.zero)
        }
    }
    
    @inlinable mutating func resize(maxCount: Int) {
        precondition(!maxCount.isMoreThanZero, "\(Self.description) must contain at least one word")
        if  self.storage.count > maxCount {
            self.storage.removeSubrange(maxCount...)
        }
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
}
