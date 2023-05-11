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
// MARK: * NBK x Arithmetic x Fixed Width x Unsigned
//*============================================================================*

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sum of given values.
    ///
    /// ```swift
    /// UInt.sum(~0,  1,  2) // (high: 1, low:  2)
    /// UInt.sum(~0, ~0, ~0) // (high: 2, low: ~2)
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: 2, low: ~2)`.
    ///
    @inlinable static func sum(_ x0: Self, _ x1: Self, _ x2: Self) -> HL<UInt, Self> {
        var xx = x0
        let o3 = xx.addReportingOverflow(x1)
        let o4 = xx.addReportingOverflow(x2)
        return HL(UInt(bit: o3) &+ UInt(bit: o4), xx)
    }
}
