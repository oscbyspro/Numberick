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
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        self.init(decoding: description, radix: 10)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The description of this value.
    ///
    /// ```swift
    /// Int256( 123).description //  "123"
    /// Int256(-123).description // "-123"
    /// ```
    ///
    @inlinable public var description: String {
        String(encoding: self, radix: 10)
    }
    
    /// The description of this type.
    ///
    /// ```swift
    /// NBKDoubleWidth< Int128>.description //  "Int256"
    /// NBKDoubleWidth<UInt256>.description // "UInt512"
    /// ```
    ///
    @inlinable public static var description: String {
        let signedness = !Self.isSigned ? "U" : ""
        return "\(signedness)Int\(Self.bitWidth)"
    }
}
