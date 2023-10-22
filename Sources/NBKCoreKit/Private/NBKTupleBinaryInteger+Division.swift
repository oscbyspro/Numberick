//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Division x Unsigned
//*============================================================================*

extension NBK.TupleBinaryInteger where High: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Forms the `remainder` of dividing the `dividend` by the `divisor`,
    /// then returns the `quotient`. The `divisor` must be normalized and
    /// the `quotient` must fit in one element.
    ///
    /// - Returns: The `quotient` is returned and the `remainder` replaces the `dividend`.
    ///
    /// ### Development 1
    ///
    /// Comparing is faster than overflow checking, according to time profiler.
    ///
    /// ### Development 2
    ///
    /// The approximation needs at most two corrections, but looping is faster.
    ///
    @_transparent public static func formRemainderWithQuotient3212MSBUnchecked(
    dividing dividend: inout Wide3, by divisor: Wide2) -> High {
        //=--------------------------------------=
        Swift.assert(divisor.high.mostSignificantBit,
        "the divisor must be normalized")
        
        Swift.assert(self.compare22S(Wide2(dividend.high, dividend.mid), to: divisor).isLessThanZero,
        "the quotient must fit in one element")
        //=--------------------------------------=
        var quotient: High = divisor.high == dividend.high
        ? High.max // the quotient must fit in one element
        : divisor.high.dividingFullWidth(Wide2(dividend.high, dividend.mid)).quotient
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        var product = self.multiplying213(divisor, by: quotient)
        
        while self.compare33S(dividend, to: product) == -1 {
            _ = quotient.subtractReportingOverflow(1 as High.Digit)
            _ = self.decrement32B(&product,  by: divisor)
        };  _ = self.decrement33B(&dividend, by: product)
        
        Swift.assert(self.compare33S(dividend, to: Wide3(0, divisor.high, divisor.low)).isLessThanZero)
        return quotient as High
    }
}
