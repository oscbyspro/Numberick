//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Words
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var count: Int {
        assert(Self.bitWidth / UInt.bitWidth >= 2, "invalid memory layout")
        assert(Self.bitWidth % UInt.bitWidth == 0, "invalid memory layout")
        return Self.bitWidth / UInt.bitWidth
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
// MARK: * NBK x Double Width x Words x Pointers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    ///
    /// - Warning: In addition to being unsafe, this collection also provides
    ///   unchecked subscript access and wrapping index arithmetic. So, don't
    ///   do stupid stuff. Understood? Cool. Let's go!
    ///
    @inlinable public func withUnsafeWords<T>(
    _ body: (NBKUnsafeWordsPointer<BitPattern>) throws -> T) rethrows -> T {
        try self._withUnsafeUIntPointer { start in
            try body(NBKUnsafeWordsPointer(start))
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    ///
    /// - Warning: In addition to being unsafe, this collection also provides
    ///   unchecked subscript access and wrapping index arithmetic. So, don't
    ///   do stupid stuff. Understood? Cool. Let's go!
    ///
    @inlinable public mutating func withUnsafeMutableWords<T>(
    _ body: (NBKUnsafeMutableWordsPointer<BitPattern>) throws -> T) rethrows -> T {
        try self._withUnsafeMutableUIntPointer { start in
            try body(NBKUnsafeMutableWordsPointer(start))
        }
    }
    
    /// Grants unsafe access to the integer's words, from least significant to most.
    ///
    /// - Warning: In addition to being unsafe, this collection also provides
    ///   unchecked subscript access and wrapping index arithmetic. So, don't
    ///   do stupid stuff. Understood? Cool. Let's go!
    ///
    @inlinable public static func fromUnsafeMutableWords(
    _ body: (NBKUnsafeMutableWordsPointer<BitPattern>) throws -> Void) rethrows -> Self {
        try Swift.withUnsafeTemporaryAllocation(of: Self.self, capacity: 1) { alloc in
            let SELF = alloc.baseAddress.unsafelyUnwrapped
            try SELF.withMemoryRebound(to: UInt.self, capacity: Self.count) { words in
                try body(NBKUnsafeMutableWordsPointer(words))
            }
            
            return SELF.pointee
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Contiguous UInt Sequence
    //=------------------------------------------------------------------------=
    
    @inlinable public func withContiguousStorageIfAvailable<T>(
    _ body: (UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T? {
        #if _endian(big)
        var base: Self { self._wordSwapped }
        #else
        var base: Self { self }
        #endif
        return try base._withUnsafeUIntBufferPointer(body)
    }
    
    @inlinable public mutating func withContiguousMutableStorageIfAvailable<T>(
    _ body: (inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T? {
        #if _endian(big)
        do    { self = self._wordSwapped }
        defer { self = self._wordSwapped }
        #endif
        return try self._withUnsafeMutableUIntBufferPointer(body)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Trivial UInt Collection
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable func _withUnsafeUIntPointer<T>(
    _ body: (UnsafePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafePointer(to: self) { start in
            try start.withMemoryRebound(to: UInt.self, capacity: Self.count, body)
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable func _withUnsafeUIntBufferPointer<T>(
    _ body: (UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T {
        try self._withUnsafeUIntPointer { start in
            try body(UnsafeBufferPointer(start: start, count: Self.count))
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable mutating func _withUnsafeMutableUIntPointer<T>(
    _ body: (UnsafeMutablePointer<UInt>) throws -> T) rethrows -> T {
        try Swift.withUnsafeMutablePointer(to: &self) { start in
            try start.withMemoryRebound(to: UInt.self, capacity: Self.count, body)
        }
    }
    
    /// Grants unsafe access to the integer's in-memory representation.
    ///
    /// - Note: The order of the integer's words depends on the platform's endianness.
    ///
    @inlinable mutating func _withUnsafeMutableUIntBufferPointer<T>(
    _ body: (inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T {
        try self._withUnsafeMutableUIntPointer { START in
            var BUFFER = UnsafeMutableBufferPointer<UInt>(start: START, count: Self.count)
            return try body(&BUFFER)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Full Width x Words x Pointers x Custom
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
    
    @inlinable static var count: Int {
        assert(MemoryLayout<Layout>.size / MemoryLayout<UInt>.size >= 2, "invalid memory layout")
        assert(MemoryLayout<Layout>.size % MemoryLayout<UInt>.size == 0, "invalid memory layout")
        return MemoryLayout<Layout>.size / MemoryLayout<UInt>.size
    }
    
    @inlinable static var startIndex: Int {
        0
    }
    
    @inlinable static var endIndex: Int {
        self.count
    }
    
    @inlinable static var lastIndex: Int {
        self.count &- 1
    }
    
    @inlinable static var indices: Range<Int> {
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
// MARK: * NBK x Full Width x Words x Pointers x Custom x Read
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
        @inlinable get {
            self[self.startIndex]
        }
    }
    
    @inlinable public var last: UInt {
        @inlinable get {
            self[self.lastIndex]
        }
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        @inlinable get {
            self.base[self.endianSensitiveIndex(index)]
        }
    }
}

//*============================================================================*
// MARK: * NBK x Full Width x Words x Pointers x Custom x Read & Write
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
