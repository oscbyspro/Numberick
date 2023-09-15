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
// MARK: * NBK x Flexible Width x Size x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Resize
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ word: UInt) {
        self.elements.append(word)
    }
    
    @inlinable mutating func resize(minCount: Int) {
        self.reserveCapacity(minCount)
        appending: while self.elements.count < minCount {
            self.elements.append(UInt.zero)
        }
    }
    
    @inlinable mutating func resize(maxCount: Int) {
        precondition(maxCount.isMoreThanZero)
        if  self.elements.count > maxCount {
            self.elements.removeSubrange(maxCount...)
        }
    }
    
    @inlinable mutating func reserveCapacity(_ minCapacity: Int) {
        self.elements.reserveCapacity(minCapacity)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize() {
        trimming: while self.elements.count > 1, self.elements.last!.isZero {
            self.elements.removeLast()
        }
    }
    
    @inlinable mutating func normalize(update value: UInt) {
        self.elements.replaceSubrange(self.elements.indices, with: CollectionOfOne(value))
    }
}
