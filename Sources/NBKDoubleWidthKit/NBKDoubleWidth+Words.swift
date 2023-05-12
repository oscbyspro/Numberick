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
        let sign: UInt = UInt(repeating: self.isLessThanZero)
        var result = (minLastIndex: Int.zero, isZeroOrMinusOne: true)
        //=--------------------------------------=
        self.withUnsafeWords { words in
            if  let minLastIndex = words.lastIndex(where:{ $0 != sign }) {
                result = (minLastIndex: minLastIndex, isZeroOrMinusOne: false)
            }
        }
        //=--------------------------------------=
        return result
    }
    
    @inlinable public func minWordCountReportingIsZeroOrMinusOne() -> (minWordCount: Int, isZeroOrMinusOne: Bool) {
        let info = self.minLastIndexReportingIsZeroOrMinusOne()
        return (info.minLastIndex &+ 1, info.isZeroOrMinusOne)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Collection
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
        self.count &- 1
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
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Collection x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public func withUnsafeWords<T>(_ body: (NBKUnsafeWordsPointer<BitPattern>) throws -> T) rethrows -> T {
        try withUnsafePointer(to: self) { pointer in
            try pointer.withMemoryRebound(to: UInt.self, capacity: Self.count) { words in
                try body(NBKUnsafeWordsPointer(words))
            }
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public mutating func withUnsafeMutableWords<T>(_ body: (NBKUnsafeMutableWordsPointer<BitPattern>) throws -> T) rethrows -> T {
        try withUnsafeMutablePointer(to: &self) { pointer in
            try pointer.withMemoryRebound(to: UInt.self, capacity: Self.count) { words in
                try body(NBKUnsafeMutableWordsPointer(words))
            }
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    @inlinable public static func fromUnsafeMutableWords(_ body: (NBKUnsafeMutableWordsPointer<BitPattern>) throws -> Void) rethrows -> Self {
        try Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { buffer in
            let pointer = buffer.baseAddress!
            try pointer.withMemoryRebound(to: UInt.self, capacity: Self.count) { words in
                try body(NBKUnsafeMutableWordsPointer(words))
            }
            
            return pointer.pointee
        }
    }
}

//*============================================================================*
// MARK: * NBK x Full Width x Words x Collection x Pointers x Custom
//*============================================================================*

/// A double-width, unsafe words pointer.
///
/// ### Requirements
///
/// ```swift
/// MemoryLayout<Layout>.size / MemoryLayout<UInt>.size >= 2
/// MemoryLayout<Layout>.size % MemoryLayout<UInt>.size == 0
/// ```
///
@usableFromInline protocol NBKDoubleWidthUnsafeWordsPointer: RandomAccessCollection where Element == UInt, Index == Int {
    
    associatedtype Layout: NBKBitPatternConvertible<Layout>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKDoubleWidthUnsafeWordsPointer {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        assert(MemoryLayout<Layout>.size /   MemoryLayout<UInt>.size >= 2, "invalid memory layout")
        assert(MemoryLayout<Layout>.size %   MemoryLayout<UInt>.size == 0, "invalid memory layout")
        return MemoryLayout<Layout>.size &>> MemoryLayout<UInt>.size.trailingZeroBitCount
    }
    
    @inlinable public var startIndex: Int {
        0
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public var lastIndex: Int {
        self.count &- 1
    }
    
    @inlinable public var indices: Range<Int> {
        0 ..< self.count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        assert(self.startIndex ... self.endIndex ~= start, "index out of range")
        assert(self.startIndex ... self.endIndex ~= end  , "index out of range")
        return end &- start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        let value = index &+ 1
        assert(self.startIndex ... self.endIndex ~= index, "index out of range")
        assert(self.startIndex ... self.endIndex ~= value, "index out of range")
        return value  as Index
    }
    
    @inlinable public func index(before index: Int) -> Int {
        let value = index &- 1
        assert(self.startIndex ... self.endIndex ~= index, "index out of range")
        assert(self.startIndex ... self.endIndex ~= value, "index out of range")
        return value  as Index
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        let value = index &+ distance
        assert(self.startIndex ... self.endIndex ~= index, "index out of range")
        assert(self.startIndex ... self.endIndex ~= value, "index out of range")
        return value  as Index
    }
    
    @inlinable func endianSensitiveIndex(_ index: Int) -> Int {
        assert(self.indices ~= index, "index out of range")
        #if _endian(big)
        return self.lastIndex &- index
        #else
        return index
        #endif
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Collection x Pointers x Read
//*============================================================================*

/// An unsafe words pointer.
///
/// - Warning: In addition to being unsafe, this collection also provides
///   unchecked subscript access and wrapping index arithmetic. So, don't
///   do stupid stuff. Understood? Cool. Let's go!
///
@frozen public struct NBKUnsafeWordsPointer<Layout>: NBKDoubleWidthUnsafeWordsPointer where Layout: NBKBitPatternConvertible<Layout> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: UnsafePointer<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: UnsafePointer<UInt>) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var first: UInt {
        self[self.startIndex]
    }
    
    @inlinable public var last: UInt {
        self[self.lastIndex]
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        self.base[self.endianSensitiveIndex(index)]
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Collection x Pointers x Read & Write
//*============================================================================*

/// An unsafe, mutable, words pointer.
///
/// - Warning: In addition to being unsafe, this collection also provides
///   unchecked subscript access and wrapping index arithmetic. So, don't
///   do stupid stuff. Understood? Cool. Let's go!
///
@frozen public struct NBKUnsafeMutableWordsPointer<Layout>: NBKDoubleWidthUnsafeWordsPointer where Layout: NBKBitPatternConvertible<Layout> {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: UnsafeMutablePointer<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: UnsafeMutablePointer<UInt>) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
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
            self.base[self.endianSensitiveIndex(index)]
        }
        
        nonmutating set {
            self.base[self.endianSensitiveIndex(index)] = newValue
        }
    }
}
