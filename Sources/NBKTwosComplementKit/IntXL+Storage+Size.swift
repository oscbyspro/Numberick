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
// MARK: * NBK x Flexible Width x Storage x Size
//*============================================================================*

extension PrivateIntXLOrUIntXLStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ word: UInt) {
        self.elements.append(word)
    }
 
    @inlinable mutating func resize(maxCount: Int) {
        precondition(maxCount.isMoreThanZero)
        if  self.elements.count > maxCount {
            self.elements.removeSubrange(maxCount...)
        }
    }
    
    @inlinable mutating func resize(minCount: Int, appending element: UInt) {
        self.reserveCapacity(minCount)
        appending: while self.elements.count < minCount {
            self.elements.append(element)
        }
    }
    
    @inlinable mutating func resize(minCount: Int) {
        self.resize(minCount: minCount, appending: UInt(repeating: self.isLessThanZero))
    }
    
    @inlinable mutating func reserveCapacity(_ minCapacity: Int) {
        self.elements.reserveCapacity(minCapacity)
    }
}
