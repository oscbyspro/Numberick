//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Digit x Sub Sequence
//*============================================================================*

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
    // MARK: Transformations x Non Zero Divisor
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
// MARK: + where Base is Mutable Collection
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
    // MARK: Transformations x Non Zero Divisor
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
