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
    
    @inlinable public init(words: some Collection<UInt>) {
        self.init(storage: Storage(words: words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    // TODO: do not expose the actual type
    @inlinable public var words: ContiguousArray<UInt> {
        _read { yield self.storage.elements }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(words: some Collection<UInt>) {
        self.init(elements: Elements(words))
    }
    
    @inlinable init(repeating word: UInt, count: Int) {
        self.init(elements: Elements(repeating: word, count: count))
    }
}
