//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !COCOAPODS
import NBKCoreKit
#endif

//*============================================================================*
// MARK: * NBK x Double Width x Subtraction x Digit
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: Digit) -> Bool {
        let minus: Bool = other.isLessThanZero
        var carry: Bool = self.first.subtractReportingOverflow(UInt(bitPattern: other))
        //=----------------------------------=
        if  carry == minus { return false }
        let extra =  UInt(bitPattern: minus ? -1 : 1)
        //=----------------------------------=
        for index in 1 ..< self.lastIndex {
            carry = self[index].subtractReportingOverflow(extra)
            if carry == minus { return false }
        }
        //=----------------------------------=
        return self.tail.subtractReportingOverflow(Digit(bitPattern: extra))
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: Digit) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other)
        return PVO(partialValue, overflow)
    }
}
