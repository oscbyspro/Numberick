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
// MARK: * NBK x Pointers
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static func merge<T>(into result: UnsafeMutableBufferPointer<T>,
    from x0: UnsafeBufferPointer<T>, _ x1: UnsafeBufferPointer<T>, each element: (T, T) -> T) {
        //=--------------------------------------=
        precondition(result.count == x0.count, NBK.callsiteOutOfBoundsInfo())
        precondition(result.count == x1.count, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        for index in result.indices {
            result[index] = element(x0[index], x1[index])
        }
    }
}
