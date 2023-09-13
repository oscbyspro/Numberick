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
// MARK: * NBK x Flexible Width x Subtraction x Digit
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: Digit) {
        lhs.subtract(rhs, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: Digit) -> Self {
        lhs.subtracting(rhs, at: Int.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Digit x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtract(_ other: Int, at index: Int) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func subtracting(_ other: Int, at index: Int) -> Self {
        var result = self; result.subtract(other, at: index); return result
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Digit x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtract(_ other: UInt, at index: Int) {
        let overflow: Bool = self.subtractReportingOverflow(other, at: index)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }

    @_disfavoredOverload @inlinable public func subtracting(_ other: UInt, at index: Int) -> Self {
        let pvo: PVO<Self> = self.subtractingReportingOverflow(other, at: index)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: UInt) -> Bool {
        self.subtractReportingOverflow(other, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: UInt) -> PVO<Self> {
        self.subtractingReportingOverflow(other, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: UInt, at index: Int) -> Bool {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: UInt, at index: Int) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other, at: index)
        return PVO(partialValue, overflow)
    }
}