//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Stdlib x Text x Encode
//*============================================================================*

extension Swift.String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static func stdlib(_ source: some BinaryInteger, radix: Int = 10, uppercase: Bool = false) -> Self {
        Self(source, radix: radix, uppercase: uppercase)
    }
}
