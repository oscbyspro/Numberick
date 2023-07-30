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
    @inlinable public init(words: some RandomAccessCollection<UInt>) {
        //=--------------------------------------=
        // default to zero by nil coalescing
        //=--------------------------------------=
        let last = words.last ?? UInt()
        //=--------------------------------------=
        self.init(sign: Sign.plus, magnitude: Magnitude(words: words))
        //=--------------------------------------=
        if  last.mostSignificantBit {
            self.sign.toggle()
            self.magnitude.formTwosComplement()
        }
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
    
    @inlinable var wordsNeedsOneMoreWord: Bool {
        guard !self.magnitude.isZero else { return true }
        let index = self.magnitude.storage.elements.count - 1
        let comparison = self.magnitude.compared(to: UInt(bitPattern: Int.min), at: index)
        return comparison >= Int(bit: self.sign.bit)
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
            self.count   = Int(bit: source.wordsNeedsOneMoreWord)
            self.sign    = UInt(repeating: source.isLessThanZero)
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
    
    @inlinable public init(words: some RandomAccessCollection<UInt>) {
        var storage = Storage(words)
        storage.normalize()
        self.init(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(source: self)
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let storage: Magnitude.Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(source: Magnitude) {
            self.storage = source.storage
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            self.storage.elements.count
        }
        
        @inlinable public var startIndex: Int {
            (0 as Int)
        }
        
        @inlinable public var endIndex: Int {
            self.count
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            switch index < self.storage.elements.endIndex {
            case  true: return self.storage.elements[index]
            case false: return UInt.zero }
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

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable static func withUnsafeWords<T>(of digit: Digit, perform body: (NBK.UnsafeWords) -> T) -> T {
        Swift.withUnsafePointer(to: digit) {
            body(NBK.UnsafeWords(start: $0, count: Int(bit: !digit.isZero)))
        }
    }
}
