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
// MARK: * NBK x Flexible Width x Subtraction
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs, at: Int.zero)
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs, at: Int.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtract(_ other: Self, at index: Int) {
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
        var borrow   = false
        var lhsIndex = index
        var rhsIndex = other.storage.elements.startIndex
        //=--------------------------------------=
        while rhsIndex != other.storage.elements.endIndex {
            var lhsElement = self .storage.elements[lhsIndex]
            let rhsElement = other.storage.elements[rhsIndex]
            
            let a  = lhsElement.subtractReportingOverflow(rhsElement)
            let b  = lhsElement.subtractReportingOverflow(UInt(bit: borrow))
            borrow = a || b
            
            self .storage.elements[lhsIndex] = lhsElement
            self .storage.elements.formIndex(after: &lhsIndex)
            other.storage.elements.formIndex(after: &rhsIndex)
        }
        //=--------------------------------------=
        if  borrow != rhsIsLessThanZero {
            let predicate = borrow
            let decrement = UInt(bitPattern: borrow ? 1 : -1)
            
            while lhsIndex != self.storage.elements.endIndex && borrow == predicate {
                borrow = self.storage.elements[lhsIndex].subtractReportingOverflow(decrement)
                self.storage.elements.formIndex(after: &lhsIndex)
            }
        }
        //=--------------------------------------=
        self.storage.normalize(appending: lhsSign &- rhsSign &- UInt(bit: borrow))
    }
    
    @inlinable public func subtracting(_ other: Self, at index: Int) -> Self {
        var result = self; result.subtract(other, at: index); return result
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtract(_ other: Self, at index: Int) {
        let overflow: Bool = self.subtractReportingOverflow(other, at: index)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public func subtracting(_ other: Self, at index: Int) -> Self {
        let pvo: PVO<Self> = self.subtractingReportingOverflow(other, at: index)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self) -> Bool {
        self.subtractReportingOverflow(other, at: Int.zero)
    }

    @inlinable public func subtractingReportingOverflow(_ other: Self) -> PVO<Self> {
        self.subtractingReportingOverflow(other, at: Int.zero)
    }
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self, at index: Int) -> Bool {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero { return false }
        //=--------------------------------------=
        self.storage.resize(minCount: other.storage.elements.count + index)
        defer{ self.storage.normalize() }
        return self.storage.subtract(other.storage, plus: false, at: index)
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self, at index: Int) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other, at: index)
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x UIntXL x Storage
//*============================================================================*

extension UIntXL.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, plus borrow: Bool, at index: Int) -> Bool {
        NBK.decrementSufficientUnsignedInteger(&self.elements, by: other.elements, plus: borrow, at: index).overflow
    }
    
    @inlinable mutating func subtract(_ other: Self, times multiplicand: UInt,
    plus subtrahend: UInt, plus borrow: Bool, at index: Int) -> Bool {
        NBK.decrementSufficientUnsignedInteger(&self.elements, by: other .elements,
        times: multiplicand,  plus: subtrahend, plus: borrow,  at: index).overflow
    }
}
