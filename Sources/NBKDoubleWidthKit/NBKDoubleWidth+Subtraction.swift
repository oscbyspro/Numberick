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
// MARK: * NBK x Double Width x Subtraction
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self) -> Bool {
        var overflow = self.low.subtractReportingOverflow(other.low) as Bool
        overflow = overflow && self.high.subtractReportingOverflow(1 as Digit)
        return overflow != self.high.subtractReportingOverflow(other.high)
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other)
        return PVO(partialValue, overflow)
    }
}
