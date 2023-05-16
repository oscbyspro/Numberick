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
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

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
        _read   { yield  self[unchecked: self.startIndex] }
        _modify { yield &self[unchecked: self.startIndex] }
    }
    
    @inlinable public var last: UInt {
        _read   { yield  self[unchecked: self.lastIndex] }
        _modify { yield &self[unchecked: self.lastIndex] }
    }
    
    @inlinable subscript(unchecked index: Int) -> UInt {
        _read { yield  self.withUnsafeWords({ $0[index]            }) }
         set  { self.withUnsafeMutableWords({ $0[index] = newValue }) }
    }

    @inlinable public subscript(index: Int) -> UInt {
        _read {
            precondition(self.indices ~= index, "index out of range")
            yield  self[unchecked: index]
        }
        _modify {
            precondition(self.indices ~= index, "index out of range")
            yield &self[unchecked: index]
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Min Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public func minLastIndexReportingIsZeroOrMinusOne() -> (minLastIndex: Int, isZeroOrMinusOne: Bool) {
        let sign  = UInt(repeating: self.isLessThanZero)
        let index = self.lastIndex(where:{ $0 != sign })
        return index.map({( $0, false )}) ?? (0, true)
    }
}
