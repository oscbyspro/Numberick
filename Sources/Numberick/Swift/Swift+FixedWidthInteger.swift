//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Fixed Width Integer
//*============================================================================*

extension Swift.FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    @inlinable public var isFull: Bool {
        self == ~(0 as Self)
    }
    
    @inlinable public var isZero: Bool {
        self ==  (0 as Self)
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self & ((1 as Self) &<< (Self.bitWidth &- 1)) != (0 as Self)
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self & ((1 as Self)) != (0 as Self)
    }
}
