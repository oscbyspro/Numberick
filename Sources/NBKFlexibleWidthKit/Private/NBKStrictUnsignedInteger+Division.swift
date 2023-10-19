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
// MARK: + Long Division Algorithms
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` element of one long division iteration, then subtracts
    /// the product of `divisor` and `quotient` from the `remainder` at the `quotient`
    /// element's position (which matches the `remainder's` start index).
    ///
    /// - Parameters:
    ///
    ///   - remainder: The `remainder` from the `quotient` element's index up to
    ///   the last zero. It must be exactly one element wider than the `divisor`.
    ///
    ///   - divisor: The normalized divisor. Its most significant bit must be set.
    ///   This ensures that the initial `quotient` approximation will only exceed 
    ///   the real value by at most 2.
    ///
    /// - Returns: The `quotient` element at the `remainder`'s start index.
    ///
    @inlinable static func quotientFromLongDivisionIteration2111MSBUnchecked(
    dividing remainder: inout Base, by divisor: some RandomAccessCollection<Base.Element>) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(divisor.last!.mostSignificantBit, 
        "the divisor must be normalized")
        
        Swift.assert(remainder.count == divisor.count + 1,
        "the remainder must be exactly one element wider than the divisor")
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
        guard !quotient.isZero else { return quotient }
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
