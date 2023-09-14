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
// MARK: * NBK x Flexible Width x Addition
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: Self) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func add(_ other: Self, at index: Int) {
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        let lhsIsLessThanZero = self .isLessThanZero
        let rhsIsLessThanZero = other.isLessThanZero
        let lhsSign = UInt(repeating: lhsIsLessThanZero)
        let rhsSign = UInt(repeating: rhsIsLessThanZero)
        //=--------------------------------------=
        self.storage.resize(minCount: other.storage.elements.count + index)
        //=--------------------------------------=
        var carry    = false
        var lhsIndex = index
        var rhsIndex = other.storage.elements.startIndex
        //=----------------------------------=
        while rhsIndex < other.storage.elements.endIndex {
            var lhsElement = self .storage.elements[lhsIndex]
            let rhsElement = other.storage.elements[rhsIndex]
            
            let a = lhsElement.addReportingOverflow(rhsElement)
            let b = lhsElement.addReportingOverflow(UInt(bit: carry))
            carry = a || b
            
            self .storage.elements[lhsIndex] = lhsElement
            self .storage.elements.formIndex(after: &lhsIndex)
            other.storage.elements.formIndex(after: &rhsIndex)
        }
        //=--------------------------------------=
        if  carry != rhsIsLessThanZero {
            let predicate = carry
            let increment = UInt(bitPattern: carry ? 1 : -1)
            
            while lhsIndex < self.storage.elements.endIndex && carry == predicate {
                carry = self.storage.elements[lhsIndex].addReportingOverflow(increment)
                self.storage.elements.formIndex(after: &lhsIndex)
            }
        }
        //=--------------------------------------=
        self.storage.normalize(appending: lhsSign &+ rhsSign &+ UInt(bit: carry))
    }
    
    @inlinable public func adding(_ other: Self, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func add(_ other: Self, at index: Int) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount:   other.storage.elements.count  + index)
        let overflow = self.storage.add(other.storage, plus: false, at: index)
        if  overflow { self.storage.append(1 as UInt) }
    }
    
    @inlinable public func adding(_ other: Self, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x UIntXL x Storage
//*============================================================================*

extension UIntXL.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, plus carry: Bool, at index: Int) -> Bool {
        NBK.incrementSufficientUnsignedInteger(&self.elements, by: other.elements, plus: carry, at: index).overflow
    }
}
