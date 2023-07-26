//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

// TODO: consider moving this to complements as the additive inverse
//*============================================================================*
// MARK: * NBK x Flexible Width x Negation x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        fatalError("TODO")
    }
    
    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        fatalError("TODO")
    }
}
