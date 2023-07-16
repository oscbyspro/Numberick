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
// MARK: * NBK x Flexible Width x Subtraction x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.subtractReportingOverflow(rhs, at: Int.zero)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs, at: Int.zero)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self, at index: Int) -> Bool {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero { return false }
        //=--------------------------------------=
        self.storage.resize(minCount: index + other.storage.elements.count)
        
        var index    = index
        var overflow = false
        
        self.storage.subtractAsFixedWidth(other.storage, at: &index, borrowing: &overflow)
        
        self.storage.normalize()
        return overflow as Bool
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self, at index: Int) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other, at: index)
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtractAsFixedWidth(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        self.subtractAsFixedWidthWithoutGoingBeyond(other, at: &index, borrowing: &overflow)
        self.subtractAsFixedWidth(Void(), at: &index, borrowing: &overflow)
    }
    
    @inlinable mutating func subtractAsFixedWidthWithoutGoingBeyond(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        for otherIndex in other.elements.indices {
            var lhsWord = self .elements[index]
            let rhsWord = other.elements[otherIndex]
            
            if !overflow {
                overflow = lhsWord.subtractReportingOverflow(rhsWord)
            }   else if    rhsWord != UInt.max {
                overflow = lhsWord.subtractReportingOverflow(rhsWord &+ 1)
            }
            
            self.elements[index] = lhsWord
            self.elements.formIndex(after: &index)
        }
    }
}
