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
// MARK: * NBK x Double Width x Text
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The description of this type.
    ///
    /// ```swift
    /// DoubleWidth< Int128>.description //  "Int256"
    /// DoubleWidth<UInt256>.description // "UInt512"
    /// ```
    ///
    @inlinable public static var description: String {
        let signedness = !Self.isSigned ? "U" : ""
        return "\(signedness)Int\(Self.bitWidth)"
    }
}
