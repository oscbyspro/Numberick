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
// MARK: * NBK x Double Width x Multiplication x Private
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal func multipliedFullWidthByHalf(_ amount: Low) -> DoubleWidth {
        var a = self.low .multipliedFullWidth(by: amount)
        var b = self.high.multipliedFullWidth(by: amount)
        b.low &+= UInt(bit: a.high.addReportingOverflow(b.low))
        return DoubleWidth(Self(0, b.high), Self(a))
    }
}
