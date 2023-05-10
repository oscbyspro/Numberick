//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Binary Integer
//*============================================================================*

extension Swift.BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self < (0 as Self)
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self > (0 as Self)
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self < other ? -1 : self == other ? 0 : 1
    }
}
