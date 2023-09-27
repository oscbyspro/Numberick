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
    
    /// The minimum number of bits in its binary representation.
    ///
    /// - Note: This member is positive and nonzero.
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    @inlinable public static var minBitWidth: Int {
        Self.bitWidth as Int
    }
    
    /// The maximum number of bits in its binary representation.
    ///
    /// - Note: This member is positive and nonzero.
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    @inlinable public static var maxBitWidth: Int {
        Self.bitWidth as Int
    }
}
