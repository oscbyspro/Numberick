//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Addition
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func addReportingOverflow(_ amount: Self) -> Bool {
        let a: Bool = self.low .addReportingOverflow(amount.low )
        let b: Bool = a && self.high.addReportingOverflow(1)
        let c: Bool = self.high.addReportingOverflow(amount.high)
        return b || c
    }
    
    @inlinable public func addingReportingOverflow(_ amount: Self) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.addReportingOverflow(amount)
        return PVO(partialValue, overflow)
    }
    
    @inlinable public mutating func subtractReportingOverflow(_ amount: Self) -> Bool {
        let a: Bool = self.low .subtractReportingOverflow(amount.low )
        let b: Bool = a && self.high.subtractReportingOverflow(1)
        let c: Bool = self.high.subtractReportingOverflow(amount.high)
        return b || c
    }
    
    @inlinable public func subtractingReportingOverflow(_ amount: Self) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(amount)
        return PVO(partialValue, overflow)
    }
}
