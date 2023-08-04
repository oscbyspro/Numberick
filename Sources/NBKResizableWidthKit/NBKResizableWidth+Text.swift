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
// MARK: * NBK x Resizable Width x Text x Signed
//*============================================================================*

extension NBKResizableWidth {

    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    /// The `description` of this type.
    ///
    /// ```
    /// ┌───────────── → ────────────┐
    /// │ self         │ description │
    /// ├───────────── → ────────────┤
    /// │  Int256.self │  "Int256"   │
    /// │ UInt512.self │ "UInt512"   │
    /// └───────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        "IntXR"
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Text x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    /// The `description` of this type.
    ///
    /// ```
    /// ┌───────────── → ────────────┐
    /// │ self         │ description │
    /// ├───────────── → ────────────┤
    /// │  Int256.self │  "Int256"   │
    /// │ UInt512.self │ "UInt512"   │
    /// └───────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        "UIntXR"
    }
}
