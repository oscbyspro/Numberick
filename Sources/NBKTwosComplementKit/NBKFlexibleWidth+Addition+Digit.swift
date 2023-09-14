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
// MARK: * NBK x Flexible Width x Addition x Digit
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Digit) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Digit) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: Digit, at index: Int) {
        if  other.isZero { return }
        //=--------------------------------------=
        let lhsIsLessThanZero = self .isLessThanZero
        let rhsIsLessThanZero = other.isLessThanZero
        let lhsSign = UInt(repeating: lhsIsLessThanZero)
        let rhsSign = UInt(repeating: rhsIsLessThanZero)
        //=--------------------------------------=
        self.storage.resize(minCount: index + 1)
        var carry = self.storage.elements[index].addReportingOverflow(UInt(bitPattern: other))
        var index = self.storage.elements.index(after: index)
        //=-------------------------------------=
        if  carry != rhsIsLessThanZero {
            let predicate = carry
            let increment = UInt(bitPattern: carry ? 1 : -1)
            
            while index != self.storage.elements.endIndex && carry == predicate {
                carry = self.storage.elements[index].addReportingOverflow(increment)
                self.storage.elements.formIndex(after: &index)
            }
        }
        //=--------------------------------------=
        self.storage.normalize(appending: lhsSign &+ rhsSign &+ UInt(bit: carry))
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: Digit, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: UInt, at index: Int) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: index + 1)
        let overflow = self.storage.add(other, plus: false, at: index)
        if  overflow { self.storage.append(1 as UInt) }
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: UInt, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x UIntXL x Storage
//*============================================================================*

extension UIntXL.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func add(_ other: UInt, plus carry: Bool, at  index: Int) -> Bool {
        NBK.incrementSufficientUnsignedInteger(&self.elements, by: other, plus: carry, at: index).overflow
    }
}
