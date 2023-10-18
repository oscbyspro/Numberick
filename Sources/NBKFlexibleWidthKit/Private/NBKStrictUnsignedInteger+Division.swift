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
// MARK: * NBK x Strict Unsigned Integer x Division
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Elements where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the quotient element of one long division iteration, then decrements the remainder accordingly.
    ///
    /// - TODO: Remainder and divisor comparisons in DEBUG mode.
    /// - TODO: It would not need pointers slices if it took the last remainder index.
    ///
    @inlinable static func quotientFromLongDivisionIteration211MSBUnchecked(
    dividing remainder: inout Base, by divisor: some RandomAccessCollection<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(divisor.last!.mostSignificantBit, "the divisor must be normalized")
        Swift.assert(remainder.count >  divisor.count, "the remainder must be wider than the divisor")
        //=--------------------------------------=
        var index: Base.Index = remainder.endIndex
        
        let numerator: NBK.Wide2<Base.Element>
        remainder.formIndex(before: &index); numerator.high = remainder[index]
        remainder.formIndex(before: &index); numerator.low  = remainder[index]
        
        let denominator = divisor[divisor.index(before: divisor.endIndex)] as Base.Element
        //=--------------------------------------=
        var quotient : Base.Element; if denominator == numerator.high { // await Swift 5.9
            quotient = Base.Element.max
        }   else {
            quotient = denominator.dividingFullWidth(numerator).quotient
        }
        //=--------------------------------------=
        if  quotient.isZero { return quotient }
        //=--------------------------------------=
        let position = remainder.index(remainder.endIndex, offsetBy:  divisor.count.onesComplement())
        var overflow = (NBK).SUISS.decrement(&remainder, by: divisor, times: quotient, at: position).overflow
        
        correctQuotientApproximationAtMostTwice: while overflow {
            quotient  = quotient &- 1 as Base.Element
            overflow = !NBK .SUISS.increment(&remainder, by: divisor, at: position).overflow
        }
        
        return quotient as Base.Element
    }
}
