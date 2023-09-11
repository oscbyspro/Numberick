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
        let sign = Sign(magnitude.last.mostSignificantBit)
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
        switch self.isLessThanZero {
        case  true: return !NBK.mostSignificantBit(twosComplementOf: self.magnitude.storage)!
        case false: return self.magnitude.storage.last.mostSignificantBit }
    }
    
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
            self.count += self.storage.count
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
            switch index < self.storage.endIndex {
            case  true: return self.storage[index]
            case false: return self.sign }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func distance(from start: Int, to end: Int) -> Int {
            self.storage.distance(from: start, to: end)
        }
        
        @inlinable public func index(after index: Int) -> Int {
            self.storage.index(after: index)
        }
        
        @inlinable public func formIndex(after index: inout Int) {
            self.storage.formIndex(after: &index)
        }
        
        @inlinable public func index(before index: Int) -> Int {
            self.storage.index(before: index)
        }
        
        @inlinable public func formIndex(before index: inout Int) {
            self.storage.formIndex(before: &index)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
            self.storage.index(index, offsetBy: distance)
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
            self.storage.index(index, offsetBy: distance, limitedBy: limit)
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
    
    @inlinable public var words: UIntXR.Words {
        _read { yield self.storage.words }
    }
}
