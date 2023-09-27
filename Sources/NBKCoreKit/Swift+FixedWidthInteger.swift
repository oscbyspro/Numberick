//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Swift x Fixed Width Integer
//*============================================================================*

extension Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Type Meta Data
    //=------------------------------------------------------------------------=
    
    /// A value indicating whether this is a fixed-width integer type.
    ///
    /// - Fixed-width integers always use their maximum bit width.
    /// - Non-fixed-width integers use at most their maximum bit width.
    ///
    @inlinable public static var isFixedWidth: Bool { true }
}
