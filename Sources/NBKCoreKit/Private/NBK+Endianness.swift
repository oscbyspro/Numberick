//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Endianess
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @_transparent public static var isBigEndian: Bool {
        #if _endian(big)
        return true
        #else
        return false
        #endif
    }
    
    @_transparent public static var isLittleEndian: Bool {
        #if _endian(little)
        return true
        #else
        return false
        #endif
    }
}
