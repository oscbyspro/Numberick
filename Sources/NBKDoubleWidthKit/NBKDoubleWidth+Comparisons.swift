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
// MARK: * NBK x Double Width x Comparisons
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isFull: Bool {
        self.low.isFull && self.high.isFull
    }
    
    @inlinable public var isZero: Bool {
        self.low.isZero && self.high.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        self.high.isLessThanZero
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isLessThanZero && !self.isZero
    }
    
    @inlinable public func signum() -> Int {
        self.isLessThanZero ? -1 : self.isZero ? 0 : 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.low == rhs.low && lhs.high == rhs.high
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.low )
        hasher.combine(self.high)
    }
    
    @inlinable public func compared(to that: Self) -> Int {
        backwards: do {
            let lhsWord  = Digit(bitPattern: self.last)
            let rhsWord  = Digit(bitPattern: that.last)
            if  lhsWord != rhsWord { return  lhsWord < rhsWord ? -1 : 1 }
        }
        
        backwards: for index in self.indices.dropLast().reversed() {
            let lhsWord  = self[index]
            let rhsWord  = that[index]
            if  lhsWord != rhsWord { return  lhsWord < rhsWord ? -1 : 1 }
        }

        return Int.zero
    }
}
