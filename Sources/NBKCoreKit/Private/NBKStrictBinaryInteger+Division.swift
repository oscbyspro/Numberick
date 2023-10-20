//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Division
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit where Base is Mutable Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictBinaryInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing `base` by `other`, and returns
    /// the `remainder` along with an `overflow` indicator.
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or,
    /// if undefined, the `base` and `base.first`.
    ///
    @inlinable public static func formQuotientWithRemainderReportingOverflow<Digit>(
    dividing base: inout Base, by other: Base.Element, signedness: Digit.Type) -> PVO<Base.Element> where Digit: NBKCoreInteger<Base.Element> {
        //=--------------------------------------=
        var other = other as Base.Element
        let lhsIsLessThanZero: Bool = Digit.isSigned && base.last!.mostSignificantBit
        let rhsIsLessThanZero: Bool = Digit.isSigned && other/*-*/.mostSignificantBit
        //=--------------------------------------=
        if  lhsIsLessThanZero {
            SubSequence.formTwosComplement(&base)
        }
        
        if  rhsIsLessThanZero {
            other.formTwosComplement()
        }
        //=--------------------------------------=
        var remainder = Unsigned.SubSequence.formQuotientWithRemainderReportingOverflow(dividing: &base, by: other)
        //=--------------------------------------=
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            SubSequence.formTwosComplement(&base)
        }
        
        if  lhsIsLessThanZero {
            remainder.partialValue.formTwosComplement()
        }
        
        if  lhsIsLessThanZero && rhsIsLessThanZero && base.last!.mostSignificantBit {
            remainder.overflow = true
        }
        //=--------------------------------------=
        return remainder as PVO<Base.Element>
    }
}
