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
    // MARK: Details
    //=------------------------------------------------------------------------=
    
    /// Returns the leading zero bit count of `limbs`.
    ///
    /// - Note: The leading zero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func leadingZeroBitCount<T: NBKFixedWidthInteger>(of limbs: some BidirectionalCollection<T>) -> Int {
        var index = limbs.endIndex
        var element = T.zero
        
        while index > limbs.startIndex, element.isZero {
            limbs.formIndex(before: &index)
            element = limbs[index]
        }
        
        return limbs.distance(from: index, to: limbs.endIndex) * T.bitWidth - T.bitWidth + element.leadingZeroBitCount
    }
}
