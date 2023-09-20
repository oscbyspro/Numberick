//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base.first`.
    ///
    @inlinable public func remainderReportingOverflow(
    dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: self.first, overflow: true)
        }
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        
        for index in self.storage.indices.reversed() {
            remainder = divisor.dividingFullWidth(HL(high: remainder, low: self.storage[index])).remainder
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public mutating func formQuotientWithRemainderReportingOverflow(
    dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: self.first, overflow: true)
        }
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        
        for index in self.storage.indices.reversed() {
            (self.storage[index], remainder) = divisor.dividingFullWidth(HL(high: remainder, low: self.storage[index]))
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
}
