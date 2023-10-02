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
// MARK: * NBK x Double Width x Words x Collection
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Elements
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    /// The least significant word.
    ///
    /// - Note: This member is required by `Swift.BinaryInteger`.
    ///
    @inlinable public var _lowWord: UInt {
        self.first as UInt
    }
    
    /// The least significant word.
    @inlinable public var first: UInt {
        self.withUnsafeBufferPointer({ $0[0] })
    }
    
    /// The most significant word.
    @inlinable public var last: UInt {
        self.withUnsafeBufferPointer({ $0[$0.count - 1] })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements x Subscripts
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable public subscript(index: Int) -> UInt {
        index < self.storage.elements.endIndex ? self.storage.elements[index] : 0 as UInt
    }
}
