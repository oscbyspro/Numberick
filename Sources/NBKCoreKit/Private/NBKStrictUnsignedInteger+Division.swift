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
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base.first`.
    ///
    @inlinable public static func remainderReportingOverflow(
    _   base: Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.remainderReportingOverflow(base, dividingBy: divisor, in: range)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor` in the given `range`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func remainderReportingOverflow(
    _   base: Base, dividingBy divisor: Base.Element, in range: some RangeExpression<Base.Index>) -> PVO<Base.Element> {
        let range = range.relative(to: base) as Range<Base.Index>
        return self.remainderReportingOverflow(base, dividingBy: divisor, in: range)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor` in the given `range`,
    /// along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func remainderReportingOverflow(
    _   base: Base, dividingBy divisor: Base.Element, in range: Range<Base.Index>) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(range.isEmpty ? 0 as Base.Element : base[range.lowerBound], true)
        }
        //=--------------------------------------=
        return PVO(self.remainder(base, dividingBy: divisor, in: range), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x With Non Zero Divisor
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`.
    @inlinable public static func remainder(
    _   base: Base, dividingBy divisor: NBK.NonZero<Base.Element>) -> Base.Element {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.remainder(base, dividingBy: divisor, in: range)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor` in the given `range`.
    @inlinable public static func remainder(
    _   base: Base, dividingBy divisor: NBK.NonZero<Base.Element>, in range: some RangeExpression<Base.Index>) -> Base.Element {
        let range = range.relative(to: base) as Range<Base.Index>
        return self.remainder(base, dividingBy: divisor, in: range)
    }
    
    /// Returns the `remainder` of dividing the `base` by the `divisor` in the given `range`.
    @inlinable public static func remainder(
    _   base: Base, dividingBy divisor: NBK.NonZero<Base.Element>, in range: Range<Base.Index>) -> Base.Element {
        var remainder = 0 as Base.Element
        
        var index = range.upperBound; while index > range.lowerBound {
            base.formIndex(before: &index)
            remainder = divisor.value.dividingFullWidth(HL(high: remainder, low: base[index])).remainder
        }
        
        return remainder  as Base.Element
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and `base.first`.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    _   base: inout Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.formQuotientWithRemainderReportingOverflow(&base, dividingBy: divisor, in: range)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor` in the given `range`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    _   base: inout Base, dividingBy divisor: Base.Element, in range: some RangeExpression<Base.Index>) -> PVO<Base.Element> {
        let range = range.relative(to: base) as Range<Base.Index>
        return self.formQuotientWithRemainderReportingOverflow(&base, dividingBy: divisor, in: range)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor` in the given `range`,
    /// and returns the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    _   base: inout Base, dividingBy divisor: Base.Element, in range: Range<Base.Index>) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(range.isEmpty ? 0 as Base.Element : base[range.lowerBound], true)
        }
        //=--------------------------------------=
        return PVO(self.formQuotientWithRemainder(&base, dividingBy: divisor, in: range), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Non Zero
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`.
    @inlinable public static func formQuotientWithRemainder(
    _   base: inout Base, dividingBy divisor: NBK.NonZero<Base.Element>) -> Base.Element {
        let range = Range(uncheckedBounds:(base.startIndex, base.endIndex))
        return self.formQuotientWithRemainder(&base, dividingBy: divisor, in: range)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor` in the given `range`.
    @inlinable public static func formQuotientWithRemainder(
    _   base: inout Base, dividingBy divisor: NBK.NonZero<Base.Element>, in range: some RangeExpression<Base.Index>) -> Base.Element {
        let range = range.relative(to: base) as Range<Base.Index>
        return self.formQuotientWithRemainder(&base, dividingBy: divisor, in: range)
    }
    
    /// Forms the `quotient` of dividing the `base` by the `divisor` in the given `range`, and returns the `remainder`.
    @inlinable public static func formQuotientWithRemainder(
    _   base: inout Base, dividingBy divisor: NBK.NonZero<Base.Element>, in range: Range<Base.Index>) -> Base.Element {
        var remainder = 0 as Base.Element
        
        var index = range.upperBound; while index > range.lowerBound {
            base.formIndex(before: &index)
           (base[index], remainder) = divisor.value.dividingFullWidth(HL(high: remainder, low: base[index]))
        }
        
        return remainder  as Base.Element
    }
}
