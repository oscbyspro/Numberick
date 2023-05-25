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
// MARK: * NBK x Double Width x Negation
//*============================================================================*

extension NBKDoubleWidth where High: NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        let msb0: Bool = self.isLessThanZero
        self.formTwosComplement()
        let msb1: Bool = self.isLessThanZero
        return msb0 && msb1
    }
    
    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.negateReportingOverflow()
        return PVO(partialValue, overflow)
    }
}
