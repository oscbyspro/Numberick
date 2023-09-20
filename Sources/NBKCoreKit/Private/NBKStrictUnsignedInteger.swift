//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer
//*============================================================================*

extension NBK { public typealias StrictUnsignedInteger = _NBKStrictUnsignedInteger }

/// A nonempty collection view thing-y.
///
/// Use pointers to prevent excessive copying.
///
/// ### Development
///
/// The base needs `zero` to `count` indices for performance reasons.
///
@frozen public struct _NBKStrictUnsignedInteger<Base> where Base: NBKOffsetAccessCollection,
Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The base viewed as a strict bit pattern.
    public var bitPattern: NBK.StrictBitPattern<Base>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) {
        self.bitPattern = NBK.StrictBitPattern(base)
    }
    
    @inlinable public init(unchecked base: Base) {
        self.bitPattern = NBK.StrictBitPattern(unchecked: base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The base viewed through this instance.
    @inlinable public var base: Base {
        self.bitPattern.base as Base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Private
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Base {
        _read   { yield  self.bitPattern.storage }
        _modify { yield &self.bitPattern.storage }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: Base.Element {
        self.bitPattern.first
    }
    
    @inlinable public var last: Base.Element {
        self.bitPattern.last
    }
    
    @inlinable public var lastIndex: Base.Index {
        self.bitPattern.lastIndex
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Mutable
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: Base.Element {
        get { self.bitPattern.first }
        set { self.bitPattern.first = newValue }
    }
    
    @inlinable public var last: Base.Element {
        get { self.bitPattern.last }
        set { self.bitPattern.last = newValue }
    }
}
