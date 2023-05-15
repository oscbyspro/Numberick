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
// MARK: * NBK x Double Width x Addition x Private
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal mutating func addReportingOverflowByHalf(_ amount: Low) -> Bool {
        let o = self.low .addReportingOverflow(amount)
        if !o { return false }
        return  self.high.addReportingOverflow(1 as UInt)
    }
    
    @inlinable internal func addingReportingOverflowByHalf(_ amount: Low) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.addReportingOverflowByHalf(amount)
        return PVO(partialValue, overflow)
    }
}
