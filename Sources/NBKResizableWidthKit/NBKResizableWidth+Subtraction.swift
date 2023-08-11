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
// MARK: * NBK x Resizable Width x Subtraction x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self) -> Bool {
        fatalError("TODO")
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self) -> PVO<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    // TODO: rename
    @inlinable public mutating func subtract(_ other: Self, plus borrow: Bool, at index: Int) -> Bool {
        NBK.decrementSufficientUnsignedInteger(&self, by: other, plus: borrow, at: index).overflow
    }
    
    // TODO: rename
    @inlinable public mutating func subtract(_ other: Self, times multiplicand: UInt, plus  subtrahend: UInt, plus borrow: Bool, at index: Int) -> Bool {
        NBK.decrementSufficientUnsignedInteger(&self, by: other, times: multiplicand, plus: subtrahend, plus: borrow, at: index).overflow
    }
}
