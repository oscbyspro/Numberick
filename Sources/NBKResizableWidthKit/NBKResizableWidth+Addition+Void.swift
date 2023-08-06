//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Resizable Width x Addition x Unsigned x Void
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Void, at index: inout Int, carrying overflow: inout Bool) {
        while overflow && index < self.storage.endIndex {
            overflow = self.storage[index].addReportingOverflow(1 as UInt)
            self.storage.formIndex(after: &index)
        }
    }
}