//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Bit Pattern
//*============================================================================*

extension NBK {
    
    /// A nonempty collection view thing-y.
    ///
    /// Use it with pointers to prevent excessive copying.
    ///
    @frozen public struct StrictBitPattern<Base> where Base: RandomAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: Base
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: Base) {
            self.storage = base
            precondition(!base.isEmpty)
        }
        
        @inlinable public init(unchecked base: Base) {
            self.storage = base
            Swift.assert(!base.isEmpty)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var base: Base {
            self.storage
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: Base.Element {
        self.storage[self.storage.startIndex]
    }
    
    @inlinable public var last: Base.Element {
        self.storage[self.lastIndex]
    }
    
    @inlinable public var lastIndex: Base.Index {
        self.storage.index(before: self.storage.endIndex)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Mutable
//=----------------------------------------------------------------------------=

extension NBK.StrictBitPattern where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: Base.Element {
        get { self.storage[self.storage.startIndex] }
        set { self.storage[self.storage.startIndex] = newValue }
    }
    
    @inlinable public var last: Base.Element {
        get { self.storage[self.lastIndex] }
        set { self.storage[self.lastIndex] = newValue }
    }
}
