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
        Self.remainderReportingOverflowCodeBlock(self.storage, dividingBy: divisor)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public mutating func formQuotientWithRemainderReportingOverflow(
    dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        Self.formQuotientWithRemainderReportingOverflowCodeBlock(&self.storage, dividingBy: divisor)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms (pointerless performance)
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base.first`.
    ///
    @inlinable public static func remainderReportingOverflowCodeBlock(
    _ base: Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        Swift.assert(!base.isEmpty)
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: base.first!, overflow: true)
        }
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        
        for index in base.indices.reversed() {
            remainder = divisor.dividingFullWidth(HL(high: remainder, low: base[index])).remainder
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflowCodeBlock(
    _ base: inout Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        Swift.assert(!base.isEmpty)
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: base.first!, overflow: true)
        }
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        
        for index in base.indices.reversed() {
            (base[index], remainder) = divisor.dividingFullWidth(HL(high: remainder, low: base[index]))
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
}
