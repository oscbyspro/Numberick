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
// MARK: * NBK x Double Width x Addition
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func addReportingOverflow(_ amount: Self) -> Bool {
        let a: Bool = self.low .addReportingOverflow(amount.low )
        let b: Bool = self.high.addReportingOverflow(amount.high)
        let c: Bool = a && self.high.addReportingOverflow(1)
        return b || c
    }
    
    @inlinable public func addingReportingOverflow(_ amount: Self) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.addReportingOverflow(amount)
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Addition x Digit
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func addReportingOverflow(_ amount: Digit) -> Bool {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func addingReportingOverflow(_ amount: Digit) -> PVO<Self> {
        fatalError("TODO")
    }
}
