//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Bits
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func nonzeroBitCount(of limbs: some Collection<some NBKCoreInteger>) -> Int {
        limbs.reduce(Int.zero) { $0 + $1.nonzeroBitCount }
    }
    
    @inlinable public static func nonzeroBitCount(of limbs: some Collection<some NBKCoreInteger>, equals comparand: Int) -> Bool {
        var count = Int()
        var index = limbs.startIndex
        
        accumulate: while index < limbs.endIndex, count <= comparand {
            count += limbs[index].nonzeroBitCount
            limbs.formIndex(after: &index)
        }
        
        return count == comparand as Int
    }
}
