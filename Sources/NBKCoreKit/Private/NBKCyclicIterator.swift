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
        
        /// Creates a new cyclic iterator of the given `base`, if possible.
        ///
        /// - Requires: `!base.isEmpty`
        ///
        @inlinable public init?(_ base: Base) {
            guard !base.isEmpty else { return nil }
            self.base  = (base)
            self.index = (base).startIndex
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        /// Sets the current index to the first index.
        @inlinable public mutating func reset() {
            self.setIndex(unchecked: self.base.startIndex)
        }
        
        /// Sets the current index to the unchecked `index` in `base`.
        ///
        /// - Requires: `base.indices ~= index`
        ///
        @inlinable public mutating func setIndex(unchecked index: Base.Index) {
            Swift.assert(index >= self.base.startIndex && index < self.base.endIndex)
            self.index = index
        }
        
        /// Returns the element at the current index, then sets the next index.
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
    
    /// Sets the current index to the cyclic index at `iteration`.
    ///
    /// ```swift
    /// var iterator = NBK.CyclicIterator([111, 222, 333])
    /// iterator.formIteration(7) // 7 % 3 == 1
    /// iterator.next() // 222
    /// iterator.next() // 333
    /// iterator.next() // 111
    /// ```
    ///
    @inlinable public mutating func formIteration(_ iteration: UInt) {
        let remainder = Int(bitPattern: iteration % UInt(bitPattern: self.base.count))
        self.setIndex(unchecked: self.base.index(self.base.startIndex, offsetBy: remainder))
    }
}
