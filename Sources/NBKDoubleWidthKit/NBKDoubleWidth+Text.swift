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
    // MARK: Details x Description
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given string.
    ///
    /// The description may contain a plus or minus sign (+ or -), followed
    /// by one or more decimal digits (0-9). If the description uses an invalid
    /// format, or it's value cannot be represented, the result is nil.
    ///
    /// ```swift
    /// Int256( "123") //  123
    /// Int256("+123") //  123
    /// Int256("-123") // -123
    /// Int256(" 123") //  nil
    /// ```
    ///
    /// - Note: This method is required by `Swift.LosslessStringConvertible`.
    ///
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    /// The description of this value.
    ///
    /// ```swift
    /// Int256( 123).description //  "123"
    /// Int256(-123).description // "-123"
    /// ```
    ///
    @inlinable public var description: String {
        String(self, radix: 10, uppercase: false)
    }
    
    /// The description of this type.
    ///
    /// ```swift
    ///  Int256.description //  "Int256"
    /// UInt512.description // "UInt512"
    /// ```
    ///
    @inlinable public static var description: String {
        let signedness = Self.isSigned ? "" : "U"
        return "\(signedness)Int\(Self.bitWidth)"
    }
}
