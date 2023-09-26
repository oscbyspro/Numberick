//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base.first`.
    ///
    @inlinable public static func remainderReportingOverflow(
    _ base: Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.remainderReportingOverflow(base, dividingBy: divisor, in: range)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor` in the given `range`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base.first`.
    ///
    @inlinable public static func remainderReportingOverflow(
    _ base: Base, dividingBy divisor: Base.Element, in range: Range<Base.Index>) -> PVO<Base.Element> {
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: base.first ?? remainder, overflow: true)
        }
        //=--------------------------------------=
        var   index = range.upperBound
        while index > range.lowerBound {
            base.formIndex(before: &index)
            remainder = divisor.dividingFullWidth(HL(high: remainder, low: base[index])).remainder
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    _ base: inout Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.formQuotientWithRemainderReportingOverflow(&base, dividingBy: divisor, in: range)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor` in the given `range`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    _   base: inout Base, dividingBy divisor: Base.Element, in range: Range<Base.Index>) -> PVO<Base.Element> {
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(partialValue: base.first ?? remainder, overflow: true)
        }
        //=--------------------------------------=
        var   index = range.upperBound
        while index > range.lowerBound {
            base.formIndex(before: &index)
           (base[index], remainder) = divisor.dividingFullWidth(HL(high: remainder, low: base[index]))
        }
        
        return PVO(partialValue: remainder, overflow: false)
    }
}
