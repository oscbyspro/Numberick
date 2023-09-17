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
// MARK: * NBK x Strict Unsigned Integer
//*============================================================================*

@frozen public struct NBKStrictUnsignedInteger<Base: RandomAccessCollection> where
Base.Element: NBKCoreInteger & NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) {
        self.base = base
        precondition(Self.validate(self.base))
    }
    
    @inlinable public init(unchecked base: Base) {
        self.base = base
        Swift.assert(Self.validate(self.base))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func validate(_ base: Base) -> Bool {
        !base.isEmpty
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var first: Base.Element {
        self.base[self.base.startIndex]
    }
    
    @inlinable var last: Base.Element {
        self.base[self.lastIndex]
    }
    
    @inlinable var lastIndex: Base.Index {
        self.base.index(before: self.base.endIndex)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Mutable
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var first: Base.Element {
        @available(*, unavailable)
        get { self.base[self.base.startIndex] }
        set { self.base[self.base.startIndex] = newValue }
    }
    
    @inlinable var last: Base.Element {
        @available(*, unavailable)
        get { self.base[self.lastIndex] }
        set { self.base[self.lastIndex] = newValue }
    }
}
