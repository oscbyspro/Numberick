//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Maybe Two's Complement
//*============================================================================*

extension NBK {
    
    /// A dynamic, lazy, two's complement sequence.
    ///
    /// ### Development
    ///
    /// It is private for performance reasons, mostly.
    ///
    @frozen public struct MaybeTwosComplement<Base>: RandomAccessCollection where
    Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: Base
        @usableFromInline let mask: Base.Element
        @usableFromInline let stop: Base.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(twosComplementOf base: Base) {
            self.init(base, formTwosComplement: true)
        }
        
        @inlinable public init(magnitudeOf base: Base, isSigned: Bool) {
            let isLessThanZero: Bool = isSigned && base.last?.mostSignificantBit == true
            self.init(base, formTwosComplement: isLessThanZero)
        }
        
        @inlinable public init(_ base: Base, formTwosComplement: Bool) {
            self.base = base
            self.mask = Base.Element(repeating: formTwosComplement)
            
            if  formTwosComplement {
                self.stop = self.base.firstIndex(where:{ !$0.isZero }).map(self.base.index(after:)) ?? self.base.endIndex
            }   else {
                self.stop = self.base.startIndex
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public subscript(index:  Base.Index) -> Base.Element {
            self.base[index] ^ self.mask &+ Base.Element(bit: index < self.stop)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBK.MaybeTwosComplement {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        self.base.count
    }
    
    @inlinable public var startIndex: Base.Index {
        self.base.startIndex
    }
    
    @inlinable public var endIndex: Base.Index {
        self.base.endIndex
    }
    
    @inlinable public var indices: Base.Indices {
        self.base.indices
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Base.Index, to end: Base.Index) -> Int {
        self.base.distance(from: start, to: end)
    }
    
    @inlinable public func index(after index: Base.Index) -> Base.Index {
        self.base.index(after: index)
    }
    
    @inlinable public func index(before index: Base.Index) -> Base.Index {
        self.base.index(before: index)
    }
    
    @inlinable public func index(_ index: Base.Index, offsetBy distance: Int) -> Base.Index {
        self.base.index(index, offsetBy: distance)
    }
    
    @inlinable public func index(_ index: Base.Index, offsetBy distance: Int, limitedBy limit: Base.Index) -> Base.Index? {
        self.base.index(index, offsetBy: distance, limitedBy: limit)
    }
}
