//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

// TODO: consider a public NBKCoreKit/NBKFlexibleWidthInteger protocol
// TODO: consider a primary associated type similar to NBKCoreKit/NBKCoreInteger
//*============================================================================*
// MARK: * NBK x Flexible Width x Protocol
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    func compared(to other: Self, at index: Int) -> Int
}
