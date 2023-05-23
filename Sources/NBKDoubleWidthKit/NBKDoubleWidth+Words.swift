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
        let sign  = UInt(repeating: self.isLessThanZero)
        let index = self.lastIndex(where:{ $0 != sign })
        return index.map({( $0, false )}) ?? (0, true)
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
        assert(MemoryLayout<Self>.size / MemoryLayout<UInt>.size >= 2)
        assert(MemoryLayout<Self>.size % MemoryLayout<UInt>.size == 0)
        return MemoryLayout<Self>.size / MemoryLayout<UInt>.size
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
    
    @inlinable public subscript(index: Int) -> UInt {
        _read {
            BitPattern.preconditionIndexIsValid(index)
            yield  self[unchecked: index]
        }
        _modify {
            BitPattern.preconditionIndexIsValid(index)
            yield &self[unchecked: index]
        }
    }
    
    @inlinable public subscript(unchecked index: Int) -> UInt {
        get {
            withUnsafeBytes(of: self) {
                let offset = BitPattern.endiannessSensitiveByteOffset(index)
                return $0.load(fromByteOffset: offset, as: UInt.self)
            }
        }
        
        set {
            withUnsafeMutableBytes(of: &self) {
                let offset = BitPattern.endiannessSensitiveByteOffset(index)
                $0.storeBytes(of: newValue, toByteOffset: offset, as: UInt.self)
            }
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
    
    @_transparent @usableFromInline internal static func preconditionIndexIsValid(_ index: Int) {
        precondition(self.indices ~= index, "invalid binary integer word index")
    }
    
    @_transparent @usableFromInline internal static func endiannessSensitiveIndex(_ index: Int) -> Int {
        assert(self.indices  ~= index)
        #if _endian(big)
        return self.lastIndex - index
        #else
        return index
        #endif
    }
    
    @_transparent @usableFromInline internal static func endiannessSensitiveByteOffset(_ index: Int) -> Int {
        self.endiannessSensitiveIndex(index) * MemoryLayout<UInt>.size
    }
}
