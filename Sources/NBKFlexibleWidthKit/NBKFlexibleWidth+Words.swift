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
    
    /// Creates an instance from the given two's complement machine words.
    ///
    /// - Note: An empty collection defaults to positive zero.
    ///
    @inlinable public init(words: some Collection<UInt>) {
        var magnitude = Magnitude.Storage(words: words)
        let sign = Sign(magnitude.elements.last!.mostSignificantBit)
        //=--------------------------------------=
        if  sign.bit {
            magnitude.formTwosComplement()
        }
        //=--------------------------------------=
        magnitude.normalize() // TODO: consuming
        //=--------------------------------------=
        self.init(sign: sign, magnitude: Magnitude(unchecked: magnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(source: self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable var storageNeedsOneMoreWord: Bool {
        if  self.isLessThanZero {
            return !self.magnitude.storage.withUnsafeBufferPointer({ NBK.mostSignificantBit(twosComplementOf: $0)! })
        }   else {
            return  self.magnitude.storage.elements.last!.mostSignificantBit
        }
    }
    
    // #warning("IntXL and UIntXL can share Words")
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public var count: Int
        @usableFromInline let sign: UInt
        @usableFromInline var storage: Magnitude.Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(source: NBKFlexibleWidth) {
            self.count = Int(bit: source.storageNeedsOneMoreWord)
            self.sign = UInt(repeating: source.isLessThanZero)
            self.storage = source.magnitude.storage
            //=----------------------------------=
            if !self.sign.isZero {
                self.storage.formTwosComplement()
            }
            //=----------------------------------=
            self.count += self.storage.elements.count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: Int {
            (0 as Int)
        }
        
        @inlinable public var endIndex: Int {
            self.count
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            switch index < self.storage.elements.endIndex {
            case  true: return self.storage.elements[index]
            case false: return self.sign }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func distance(from start: Int, to end: Int) -> Int {
            self.storage.elements.distance(from: start, to: end)
        }
        
        @inlinable public func index(after index: Int) -> Int {
            self.storage.elements.index(after: index)
        }
        
        @inlinable public func formIndex(after index: inout Int) {
            self.storage.elements.formIndex(after: &index)
        }
        
        @inlinable public func index(before index: Int) -> Int {
            self.storage.elements.index(before: index)
        }
        
        @inlinable public func formIndex(before index: inout Int) {
            self.storage.elements.formIndex(before: &index)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
            self.storage.elements.index(index, offsetBy: distance)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
            self.storage.elements.index(index, offsetBy: distance, limitedBy: limit)
        }
    }
}

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
