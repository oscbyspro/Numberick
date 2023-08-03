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
// MARK: * NBK x Bits
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the most significant bit for the two's complement of `limbs`.
    @inlinable public static func mostSignificantBit(twosComplementOf limbs: some BidirectionalCollection<some NBKCoreInteger>) -> Bool {
        guard let index = limbs.firstIndex(where:{ !$0.isZero }) else { return false }
        return limbs.last!.twosComplementSubsequence(limbs.index(after: index) == limbs.endIndex).partialValue.mostSignificantBit
    }
}
