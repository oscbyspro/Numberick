//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Cyclic Iterator
//*============================================================================*

extension NBK {
    
    /// A cyclic iterator of some collection.
    @frozen public struct CyclicIterator<Base> where Base: Collection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base:  Base
        @usableFromInline var index: Base.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ base: Base) {
            guard !base.isEmpty else { return nil }
            self.base  = (base)
            self.index = (base).startIndex
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public mutating func reset() {
            self.index = self.base.startIndex
        }
        
        @inlinable public mutating func next() -> Base.Element {
            defer {
                self.base.formIndex(after: &self.index)
                if  self.index == self.base.endIndex {
                    self.reset()
                }
            }

            return self.base[self.index] as Base.Element
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Random Access Collection
//=----------------------------------------------------------------------------=

extension NBK.CyclicIterator where Base: RandomAccessCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    // TODO: Tests...
    @inlinable public mutating func set(distance: UInt) where Base: RandomAccessCollection {
        let  count = UInt(bitPattern: self.base.count)
        self.index = self.base.index(self.base.startIndex, offsetBy: Int(bitPattern: distance % count))
    }
}
