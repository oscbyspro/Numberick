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
    
    @inlinable public var isZero: Bool {
        self.low.isZero && self.high.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        self.high.isLessThanZero
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !(self.isLessThanZero || self.isZero)
    }
    
    @inlinable public func signum() -> Int {
        self.isLessThanZero ? -1 : self.isZero ? 0 : 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.low )
        hasher.combine(self.high)
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
    
    @inlinable public func compared(to other: Self) -> Int {
        backwards: do {
            let lhsWord: Digit = self .tail
            let rhsWord: Digit = other.tail
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        backwards: for index in (0 ..< self.lastIndex).reversed() {
            let lhsWord: UInt = self [index]
            let rhsWord: UInt = other[index]
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return 0 as Int
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        let environment = UInt(repeating: other.isLessThanZero)
        
        backwards: do {
            let lhsWord: Digit = self.tail
            let rhsWord: Digit = Digit(bitPattern: environment)
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        backwards: for index in (1 ..< self.lastIndex).reversed() {
            let lhsWord: UInt = self[index]
            let rhsWord: UInt = environment
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return self.first.compared(to: UInt(bitPattern: other))
    }
}
