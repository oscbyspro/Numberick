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
// MARK: * NBK x Flexible Width x Comparisons x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.storage.count == 1 && self.storage[0].isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public func signum() -> Int {
        Int(bit: !self.isZero)
    }
    
    @inlinable public var isPowerOf2: Bool {
        var nonzeroBitCountLowerBound = 0
        var index = self.storage.startIndex
        //=--------------------------------------=
        while index < self.storage.endIndex, nonzeroBitCountLowerBound < 2 {
            nonzeroBitCountLowerBound &+= self.storage[index].nonzeroBitCount
            self.storage.formIndex(after: &index)
        }
        //=--------------------------------------=
        return nonzeroBitCountLowerBound == 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        //=--------------------------------------=
        if  self.storage.count != other.storage.count {
            return self.storage.count < other.storage.count ? -1 : 1
        }
        //=--------------------------------------=
        for index in self.storage.indices.reversed() {
            let lhsWord: UInt = self .storage[index]
            let rhsWord: UInt = other.storage[index]
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return Int.zero
    }
}
