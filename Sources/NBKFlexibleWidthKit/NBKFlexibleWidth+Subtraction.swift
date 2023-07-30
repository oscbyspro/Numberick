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

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs, at: Int.zero)
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs, at: Int.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtract(_ other: Self, at index: Int) {
        fatalError("TODO")
    }
    
    @inlinable public func subtracting(_ other: Self, at index: Int) -> Self {
        var result = self; result.subtract(other, at: index); return result
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        lhs.subtract(rhs, at: Int.zero)
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs, at: Int.zero)
    }
    
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
