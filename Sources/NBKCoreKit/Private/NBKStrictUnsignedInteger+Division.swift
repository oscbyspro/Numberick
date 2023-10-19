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
    
    /// Returns the `quotient` element of one long division iteration, then subtracts
    /// the product of `divisor` and `quotient` from the `remainder` at the `quotient`
    /// element's index (which must match the `remainder`'s start index).
    ///
    /// - Parameters:
    ///   - remainder: The `remainder` suffix from the `quotient` element's index.
    ///   It must be exactly one element wider than the `divisor`.
    ///   - divisor: The normalized `divisor`. Its last element's most significant
    ///   bit must be set to ensure that the initial `quotient` approximation will 
    ///   exceed the real `quotient` by at most 2.
    ///
    /// - Returns: The `quotient` element at the `remainder`'s start index.
    ///
    /// ## Example Usage in Long Division Algorithm
    ///
    /// ```swift
    /// //  use fast path
    /// //  normalization
    ///
    /// var quotient = uninitialized(remainder.count - divisor.count) { quotient in
    ///     for index in quotient.indices.reversed() {
    ///         let digit = quotientFromLongDivisionIteration2111MSBUnchecked(
    ///         dividing: &remainder[index ..< index + divisor.count + 1], by: divisor)
    ///         quotient.baseAddress!.advanced(by: index).initialize(to: digit)
    ///     }
    /// }
    ///
    /// // normalization
    /// // return values
    /// ```
    ///
    @inlinable public static func quotientFromLongDivisionIteration2111MSBUnchecked(
    dividing remainder: inout Base, by divisor: some RandomAccessCollection<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(divisor.last!.mostSignificantBit,
        "the divisor must be normalized")
        
        Swift.assert(remainder.count == divisor.count + 1,
        "the remainder must be exactly one element wider than the divisor")
        //=--------------------------------------=
        let numerator   = NBK.TBI<Base.Element>.suffix2(remainder)
        let denominator = NBK.TBI<Base.Element>.suffix1((divisor))
        //=--------------------------------------=
        var quotient : Base.Element; if denominator == numerator.high { // await Swift 5.9
            quotient = Base.Element.max
        }   else {
            quotient = denominator.dividingFullWidth(numerator).quotient
        }
        //=--------------------------------------=
        if  quotient.isZero { return quotient }
        //=--------------------------------------=
        var overflow = (NBK).SUISS.decrement(&remainder, by: divisor, times: quotient).overflow
        
        decrementQuotientAtMostTwice: while overflow {
            quotient = quotient &- 1 as Base.Element
            overflow = !NBK .SUISS.increment(&remainder, by: divisor).overflow
        }
        
        Swift.assert(NBK.SUISS.compare(remainder, to: divisor).isLessThanZero)
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
    _   base: Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(base.first ?? 000 as Base.Element, true)
        }
        //=--------------------------------------=
        return PVO(self.remainder(base, dividingBy: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x With Non Zero Divisor
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing the `base` by the `divisor`.
    @inlinable public static func remainder(
    _   base: Base, dividingBy divisor: NBK.NonZero<Base.Element>) -> Base.Element {
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
    _   base: inout Base, dividingBy divisor: Base.Element) -> PVO<Base.Element> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(base.first ?? 000 as Base.Element, true)
        }
        //=--------------------------------------=
        return PVO(self.formQuotientWithRemainder(&base, dividingBy: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Non Zero
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing the `base` by the `divisor`, and returns the `remainder`.
    @inlinable public static func formQuotientWithRemainder(
    _   base: inout Base, dividingBy divisor: NBK.NonZero<Base.Element>) -> Base.Element {
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
