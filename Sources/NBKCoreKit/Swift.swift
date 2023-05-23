//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Binary Integer x Swift
//*============================================================================*

extension Swift.BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// Creates a string representing the this value, int the given format.
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        String(self, radix: radix, uppercase: uppercase)
    }
}
