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
        lhs.subtract(rhs, at: 0 as Int)
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        lhs.subtracting(rhs, at: 0 as Int)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self) -> Bool {
        self.subtractReportingOverflow(other, at: 0 as Int)
    }

    @inlinable public func subtractingReportingOverflow(_ other: Self) -> PVO<Self> {
        self.subtractingReportingOverflow(other, at: 0 as Int)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Index
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
    // MARK: Transformations x Index x Overflow
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self, at index: Int) -> Bool {
        //=--------------------------------------=
        if  other.isZero { return false }
        //=--------------------------------------=
        self.storage.resize(minCount: index + other.storage.elements.count)
        
        let overflow: Bool = self.storage.withUnsafeMutableBufferPointer(in: index...) { slice in
            other.storage.withUnsafeBufferPointer { other in
                NBK.SUISS.decrement(&slice, by: other).overflow
            }
        }
        
        self.storage.normalize()
        return overflow as Bool
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self, at index: Int) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other, at: index)
        return PVO(partialValue, overflow)
    }
}
