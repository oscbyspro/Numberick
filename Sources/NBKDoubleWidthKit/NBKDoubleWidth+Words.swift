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
// MARK: * NBK x Double Width x Words
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var count: Int {
        assert(MemoryLayout<Self>.size /   MemoryLayout<UInt>.size >= 2, "invalid memory layout")
        assert(MemoryLayout<Self>.size %   MemoryLayout<UInt>.size == 0, "invalid memory layout")
        return MemoryLayout<Self>.size &>> MemoryLayout<UInt>.size.trailingZeroBitCount
    }
    
    @inlinable public static var startIndex: Int {
        0
    }
    
    @inlinable public static var endIndex: Int {
        self.count
    }
    
    @inlinable public static var lastIndex: Int {
        self.count - 1
    }
    
    @inlinable public static var indices: Range<Int> {
        0 ..< self.count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        Self.count
    }
    
    @inlinable public var startIndex: Int {
        Self.startIndex
    }
    
    @inlinable public var endIndex: Int {
        Self.endIndex
    }
    
    @inlinable public var lastIndex: Int {
        Self.lastIndex
    }
    
    @inlinable public var indices: Range<Int> {
        Self.indices
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: UInt {
        @inlinable _read {
            yield  self[unchecked: self.startIndex]
        }
        
        @inlinable _modify {
            yield &self[unchecked: self.startIndex]
        }
    }
    
    @inlinable public var last: UInt {
        @inlinable _read {
            yield  self[unchecked: self.lastIndex]
        }
        
        @inlinable _modify {
            yield &self[unchecked: self.lastIndex]
        }
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        @inlinable _read {
            precondition(self.indices ~= index, "index out of range")
            yield  self[unchecked: index]
        }
        @inlinable _modify {
            precondition(self.indices ~= index, "index out of range")
            yield &self[unchecked: index]
        }
    }
    
    @inlinable subscript(unchecked index: Int) -> UInt {
        @inlinable _read {
            yield  self.withUnsafeWords({ $0[index] })
        }
        
        @inlinable set {
            self.withUnsafeMutableWords({ $0[index] = newValue })
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: BitPattern {
        self.bitPattern
    }
    
    /// The least significant word of this value.
    ///
    /// This is a top-secret™ requirement of [BinaryInteger][].
    ///
    /// []: https://github.com/apple/swift/blob/main/stdlib/public/core/Integers.swift
    ///
    @inlinable public var _lowWord: UInt {
        self.low._lowWord
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Min Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public func minLastIndexReportingIsZeroOrMinusOne() -> (minLastIndex: Int, isZeroOrMinusOne: Bool) {
        let sign: UInt  = UInt(repeating: self.isLessThanZero)
        let index: Int? = self.withUnsafeWords({ $0.lastIndex(where:{ $0 != sign }) })
        return index.map({( $0, false )}) ?? (0, true)
    }
    
    @inlinable public func minWordCountReportingIsZeroOrMinusOne() -> (minWordCount: Int, isZeroOrMinusOne: Bool) {
        let info = self.minLastIndexReportingIsZeroOrMinusOne()
        return (info.minLastIndex + 1, info.isZeroOrMinusOne)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Collection x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    public typealias UnsafeWords = BitPattern._UnsafeWords
    
    public typealias UnsafeMutableWords = BitPattern._UnsafeMutableWords
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
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
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public static func fromUnsafeMutableWords(_ body: (UnsafeMutableWords) throws -> Void) rethrows -> Self {
        try Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress!
            try body(UnsafeMutableWords(pointer))
            return pointer.pointee
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
    // MARK: * Unsafe Words
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
    // MARK: * Unsafe Words x Mutable
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
            get {
                self[self.startIndex]
            }
            
            nonmutating set {
                self[self.startIndex] = newValue
            }
        }
        
        @inlinable public var last: UInt {
            get {
                self[self.lastIndex]
            }
            
            nonmutating set {
                self[self.lastIndex] = newValue
            }
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
