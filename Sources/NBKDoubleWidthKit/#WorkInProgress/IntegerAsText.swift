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
// MARK: * NBK x Double With x Integer As Text
//*============================================================================*

extension NBKDoubleWidth {
    
    #warning("WIP")
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        self.magnitude.description(radix: radix, uppercase: uppercase, minus: self.isLessThanZero)
    }
}

//*============================================================================*
// MARK: * NBK x Double With x Integer As Text x String
//*============================================================================*

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(encoding integer: NBKDoubleWidth<T>, radix: Int = 10, uppercase: Bool = false) {
        self = integer.description(radix: radix, uppercase: uppercase)
    }
}
