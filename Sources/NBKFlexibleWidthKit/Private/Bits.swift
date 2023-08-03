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
    
    /// Returns the nonzero bit count for the two's complement of `limbs`.
    @inlinable static func nonzeroBitCount(twosComplementOf limbs: some Collection<some NBKCoreInteger>) -> Int {
        guard let index = limbs.firstIndex(where:{ !$0.isZero }) else { return Int() }
        return limbs.indices[index...].reduce(1 - limbs[index].trailingZeroBitCount) { $0 + limbs[$1].onesComplement().nonzeroBitCount }
    }
}
