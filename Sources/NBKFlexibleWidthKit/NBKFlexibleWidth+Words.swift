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
// MARK: * NBK x Flexible Width x Words x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some Sequence<UInt>) {
        self.init(normalizing: Storage(nonemptying: Elements(words)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: ContiguousArray<UInt> {
        _read { yield self.storage.elements }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var first: UInt {
        get { self.elements[self.elements.startIndex] }
        set { self.elements[self.elements.startIndex] = newValue }
    }
    
    @inlinable var last: UInt {
        get { self.elements[self.lastIndex] }
        set { self.elements[self.lastIndex] = newValue }
    }
    
    @inlinable var lastIndex: Int {
        self.elements.index(before: self.elements.endIndex)
    }
}
