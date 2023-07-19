//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Optimizations
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func initWithFastPaths<T, U>(truncating source: T, as type: U.Type = U.self) -> U where T: NBKFixedWidthInteger, U: NBKFixedWidthInteger {
        if  T.BitPattern.self == U.BitPattern.self {
            return U(bitPattern: Swift.unsafeBitCast(source.bitPattern, to: U.BitPattern.self))
        }   else {
            return U(truncatingIfNeeded: source)
        }
    }
}
