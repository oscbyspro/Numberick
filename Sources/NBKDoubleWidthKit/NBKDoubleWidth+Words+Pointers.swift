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
// MARK: * NBK x Double Width x Words x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    public typealias UnsafeWords = BitPattern._UnsafeWords
    
    public typealias UnsafeMutableWords = BitPattern._UnsafeMutableWords
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public static func fromUnsafeMutableWords(_ body: (UnsafeMutableWords) throws -> Void) rethrows -> Self {
        try Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress!
            try body(UnsafeMutableWords(pointer))
            return pointer.pointee
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public static func fromUnsafeMutableWordsAsOptional(_ body: (UnsafeMutableWords) -> Void?) -> Self? {
         Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress!
            guard let _ = body(UnsafeMutableWords(pointer)) else { return nil }
            return pointer.pointee
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public func withUnsafeWords<T>(_ body: (UnsafeWords) throws -> T) rethrows -> T {
        try withUnsafePointer(to: self) { pointer in
            try body(UnsafeWords(pointer))
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public mutating func withUnsafeMutableWords<T>(_ body: (UnsafeMutableWords) throws -> T) rethrows -> T {
        try withUnsafeMutablePointer(to: &self) { pointer in
            try body(UnsafeMutableWords(pointer))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func endianSensitiveIndex(_ index: Int) -> Int {
        assert(self.indices  ~= index, "index out of range")
        #if _endian(big)
        return self.lastIndex - index
        #else
        return index
        #endif
    }
    
    @inlinable internal static func endianSensitiveByteOffset(_ index: Int) -> Int {
        self.endianSensitiveIndex(index) * MemoryLayout<UInt>.size
    }
    
    //*========================================================================*
    // MARK: * Read
    //*========================================================================*

    /// An unsafe words pointer.
    @frozen public struct _UnsafeWords: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: UnsafeRawPointer
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: UnsafeRawPointer) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            NBKDoubleWidth.count
        }
        
        @inlinable public var startIndex: Int {
            NBKDoubleWidth.startIndex
        }
        
        @inlinable public var endIndex: Int {
            NBKDoubleWidth.endIndex
        }
        
        @inlinable public var lastIndex: Int {
            NBKDoubleWidth.lastIndex
        }
        
        @inlinable public var indices: Range<Int> {
            NBKDoubleWidth.indices
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var first: UInt {
            self[self.startIndex]
        }
        
        @inlinable public var last: UInt {
            self[self.lastIndex]
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            let offset: Int = NBKDoubleWidth.endianSensitiveByteOffset(index)
            return self.base.load(fromByteOffset: offset, as: UInt.self)
        }
    }
    
    //*========================================================================*
    // MARK: * Read & Write
    //*========================================================================*

    /// An unsafe, mutable, words pointer.
    @frozen public struct _UnsafeMutableWords: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base: UnsafeMutableRawPointer
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: UnsafeMutableRawPointer) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            NBKDoubleWidth.count
        }
        
        @inlinable public var startIndex: Int {
            NBKDoubleWidth.startIndex
        }
        
        @inlinable public var endIndex: Int {
            NBKDoubleWidth.endIndex
        }
        
        @inlinable public var lastIndex: Int {
            NBKDoubleWidth.lastIndex
        }
        
        @inlinable public var indices: Range<Int> {
            NBKDoubleWidth.indices
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var first: UInt {
            nonmutating get { self[self.startIndex] }
            nonmutating set { self[self.startIndex] = newValue }
        }
        
        @inlinable public var last: UInt {
            nonmutating get { self[self.lastIndex] }
            nonmutating set { self[self.lastIndex] = newValue }
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            get {
                let offset: Int = NBKDoubleWidth.endianSensitiveByteOffset(index)
                return self.base.load(fromByteOffset: offset, as: UInt.self)
            }
            
            nonmutating set {
                let offset: Int = NBKDoubleWidth.endianSensitiveByteOffset(index)
                self.base.storeBytes(of: newValue, toByteOffset: offset, as: UInt.self)
            }
        }
    }
}
