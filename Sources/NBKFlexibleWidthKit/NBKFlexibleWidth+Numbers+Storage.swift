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
// MARK: * NBK x Numbers x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable init(truncating source: StaticBigInt) {
        //=--------------------------------------=
        let bitWidth = source.bitWidth
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let count = major + Int(bit: !minor.isZero)
        //=--------------------------------------=
        self = Self.uninitialized(count: count) { storage in
            for index in storage.indices {
                storage[index] = source[index]
            }
        }
    }
}
