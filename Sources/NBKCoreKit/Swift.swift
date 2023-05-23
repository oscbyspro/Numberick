//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

// TODO: intuitive overloads
//*============================================================================*
// MARK: * NBK x Fixed Width Integer x Swift
//*============================================================================*

extension Swift.BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        String(self, radix: radix, uppercase: uppercase)
    }
}
