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
// MARK: * NBK x Double Width x Strides
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(to other: Self) -> Int {
        let distance = other.subtractingReportingOverflow(self)
        let distanceIsLessThanZero = distance.partialValue.isLessThanZero != distance.overflow
        return Int(words: distance.partialValue, isSigned: distanceIsLessThanZero)!
    }
    
    @inlinable public func advanced(by distance: Int) -> Self {
        if  Self.isSigned || distance >= 0  as Int {
            return self + Digit(bitPattern: distance)
        }   else {
            return self - Digit(bitPattern: distance.twosComplement())
        }
    }
}
