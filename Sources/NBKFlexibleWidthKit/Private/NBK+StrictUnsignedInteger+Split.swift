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
// MARK: * NBK x Strict Unsigned Integer x Sub Sequence x Split
//*============================================================================*

extension NBK.StrictUnsignedInteger.SubSequence  {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Splits `base` at `index` then trims all trailing zeros from each sequence.
    @inlinable public static func partitionTrimmingRedundantZeros<T>(
    _   base: Base, at index: Base.Index) -> HL<Base, Base> where Base == UnsafeBufferPointer<T> {
        let partition = Swift.min(base.count, index)
        let low  = Base(start: base.baseAddress!,  /*------*/ count: NBK.dropLast(from: base[..<partition], while:{ $0.isZero }).count)
        let high = Base(start: base.baseAddress! + partition, count: NBK.dropLast(from: base[partition...], while:{ $0.isZero }).count)
        return HL(high: high,  low: low)
    }
}
