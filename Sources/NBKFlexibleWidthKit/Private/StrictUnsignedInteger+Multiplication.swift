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
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Multiplies `base` by `multiplier` then adds `digit` from `index` up to `limit`.
    ///
    /// - Returns: The `low` and `high` product: (high: `digit`, low: `base`).
    ///
    @inlinable public static func multiply(
    _   base: inout Base, by multiplier: Base.Element, add digit: inout Base.Element, at index: inout Base.Index, upTo limit: Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= limit)
        Swift.assert(limit <= base.endIndex  )
        //=--------------------------------------=
        forwards: while index < limit {
            var wide = base[index].multipliedFullWidth(by: multiplier)
            wide.high &+= Base.Element(bit: wide.low.addReportingOverflow(digit))
            (digit, base[index]) = (wide)
            base.formIndex(after: &index)
        }
    }
}
