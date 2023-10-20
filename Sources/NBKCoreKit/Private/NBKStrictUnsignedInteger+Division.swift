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
// MARK: + Long Division Algorithms
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `remainder` of dividing the `dividend` by the `divisor`,
    /// then returns the `quotient`. Its arguments must match the arguments
    /// of one long division iteration.
    ///
    /// - Parameters:
    ///   - dividend: The current iteration's `remainder` slice from the `quotient`
    ///   element's index. It must be exactly one element wider than the `divisor`.
    ///
    ///   - divisor: The normalized `divisor`. Its last element's most significant
    ///   bit must be set to ensure that the initial `quotient` approximation does
    ///   not exceed the real `quotient` by more than 2.
    ///
    /// ## Example Usage in Long Division Algorithm
    ///
    /// ```swift
    /// //  try fast path
    /// //  normalization
    ///
    /// var quotient = uninitialized(remainder.count - divisor.count) { quotient in
    ///     for index in quotient.indices.reversed() {
    ///         let digit = formRemainderWithQuotientAsLong211MSBUnchecked(
    ///         dividing: &remainder[index ..< index + divisor.count + 1], by: divisor)
    ///         quotient.baseAddress!.advanced(by: index).initialize(to: digit)
    ///     }
    /// }
    ///
    /// // normalization
    /// // return values
    /// ```
    ///
    @inlinable public static func formRemainderWithQuotientAsLong211MSBUnchecked(
    dividing dividend: inout Base, by divisor: some RandomAccessCollection<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(divisor.last!.mostSignificantBit,
        "the divisor must be normalized")
        
        Swift.assert(dividend.count == divisor.count + 1,
        "the dividend must be exactly one element wider than the divisor")
        
        Swift.assert(NBK.SUISS.compare(dividend, to: divisor,
        at:  dividend.dropFirst().startIndex).isLessThanZero,
        "the quotient of each iteration must fit in one element")
        //=--------------------------------------=
        let numerator   = NBK.TBI<Base.Element>.suffix2(dividend)
        let denominator = NBK.TBI<Base.Element>.suffix1(divisor )
        //=--------------------------------------=
        var quotient : Base.Element; if denominator == numerator.high {
            quotient = Base.Element.max
        }   else {
            quotient = denominator.dividingFullWidth(numerator).quotient
        }
        //=--------------------------------------=
        if  quotient.isZero { return quotient }
        //=--------------------------------------=
        var overflow = (NBK).SUISS.decrement(&dividend, by: divisor, times: quotient).overflow
        
        decrementQuotientAtMostTwice: while overflow {
            quotient = quotient &- 1 as Base.Element
            overflow = !NBK .SUISS.increment(&dividend, by: divisor).overflow
        }
        
        Swift.assert(NBK.SUISS.compare(dividend, to: divisor).isLessThanZero)
        return quotient as Base.Element
    }
}

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
    /// - Note: In the case of `overflow`, the result is the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func remainderReportingOverflow(
    dividing base: Base, by divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(base.first ?? 000 as Base.Element, true)
        }
        //=--------------------------------------=
        return PVO(self.remainder(dividing: base, by: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x With Non Zero Divisor
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`.
    @inlinable public static func remainder(
    dividing base: Base, by divisor: NBK.NonZero<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        var index = base.endIndex as Base.Index
        //=--------------------------------------=
        backwards: while index > base.startIndex {
            base.formIndex(before: &index)
            remainder = divisor.value.dividingFullWidth(HL(high: remainder, low: base[index])).remainder
        }
        //=--------------------------------------=
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
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`, and returns
    /// the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is `base` and the first element in the given `range`
    /// or zero if it the given `range` is empty.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow(
    dividing base: inout Base, by divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(base.first ?? 000 as Base.Element, true)
        }
        //=--------------------------------------=
        return PVO(self.formQuotientWithRemainder(dividing: &base, by: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Non Zero
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`, and returns the `remainder`.
    @inlinable public static func formQuotientWithRemainder(
    dividing base: inout Base, by divisor: NBK.NonZero<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        var remainder = 0 as Base.Element
        var index = base.endIndex as Base.Index
        //=--------------------------------------=
        backwards: while index > base.startIndex {
            base.formIndex(before: &index)
           (base[index], remainder) = divisor.value.dividingFullWidth(HL(high: remainder, low: base[index]))
        }
        //=--------------------------------------=
        return remainder  as Base.Element
    }
}
