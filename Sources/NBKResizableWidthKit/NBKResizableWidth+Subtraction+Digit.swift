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
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: UInt) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: UInt) -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: UInt) -> Bool {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: UInt) -> PVO<Self> {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    // TODO: rename
    @_disfavoredOverload @inlinable public mutating func subtract(_ other: UInt, plus subtrahend: Bool, at index: Int) -> Bool {
        NBK.decrementUnsignedInteger(&self, by: other, plus: subtrahend, at: index).overflow
    }
}
