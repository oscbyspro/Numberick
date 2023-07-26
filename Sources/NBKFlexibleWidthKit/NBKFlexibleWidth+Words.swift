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
// MARK: * NBK x Flexible Width x Words x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some RandomAccessCollection<UInt>) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: [UInt] {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some RandomAccessCollection<UInt>) {
        var storage = Storage(words)
        storage.normalize()
        self.init(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(magnitude: self)
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let magnitude: Magnitude
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(magnitude: Magnitude) {
            self.magnitude = magnitude
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            self.magnitude.storage.elements.count
        }
        
        @inlinable public var startIndex: Int {
            self.magnitude.storage.elements.startIndex
        }
        
        @inlinable public var endIndex: Int {
            self.magnitude.storage.elements.endIndex
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            switch index < self.magnitude.storage.elements.endIndex {
            case  true: return self.magnitude.storage.elements[index]
            case false: return UInt.zero }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func distance(from start: Int, to end: Int) -> Int {
            self.magnitude.storage.elements.distance(from: start, to: end)
        }
        
        @inlinable public func index(after index: Int) -> Int {
            self.magnitude.storage.elements.index(after: index)
        }
        
        @inlinable public func formIndex(after index: inout Int) {
            self.magnitude.storage.elements.formIndex(after: &index)
        }
        
        @inlinable public func index(before index: Int) -> Int {
            self.magnitude.storage.elements.index(before: index)
        }
        
        @inlinable public func formIndex(before index: inout Int) {
            self.magnitude.storage.elements.formIndex(before: &index)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
            self.magnitude.storage.elements.index(index, offsetBy: distance)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
            self.magnitude.storage.elements.index(index, offsetBy: distance, limitedBy: limit)
        }
    }
}
