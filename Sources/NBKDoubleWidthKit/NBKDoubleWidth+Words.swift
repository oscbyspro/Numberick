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
    
    @inlinable public var words: Self {
        _read { yield self }
    }
    
    /// The least significant word of this value.
    ///
    /// - Note: This member is required by Swift.BinaryInteger.
    ///
    @inlinable public var _lowWord: UInt {
        self.low._lowWord
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
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
    
    /// The least significant word in this integer.
    @inlinable public var first: UInt {
        get { self[unchecked: self.startIndex] }
        set { self[unchecked: self.startIndex] = newValue }
    }
    
    /// The most significant word in this integer.
    @inlinable public var last: UInt {
        get { self[unchecked: self.lastIndex] }
        set { self[unchecked: self.lastIndex] = newValue }
    }
    
    /// The most significant word in this integer, reinterpreted as a ``Digit``.
    @inlinable public var tail: Digit {
        get { Digit(bitPattern: self.last) }
        set { self.last = UInt(bitPattern: newValue) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Int) -> UInt {
        get {
            precondition(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            return self[unchecked: index]
        }
        set {
            precondition(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            self[unchecked: index] = newValue
        }
    }
    
    @inlinable public subscript(unchecked index: Int) -> UInt {
        get {
            Swift.assert(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            let offset = BitPattern.endiannessSensitiveByteOffset(unchecked: index)
            return Swift.withUnsafeBytes(of: self) {
                return $0.load(fromByteOffset: offset, as: UInt.self)
            }
        }
        
        set {
            Swift.assert(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            let offset = BitPattern.endiannessSensitiveByteOffset(unchecked: index)
            Swift.withUnsafeMutableBytes(of: &self) {
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
    
    @inlinable static func endiannessSensitiveIndex(unchecked index: Int) -> Int {
        assert(self.indices  ~= index, NBK.callsiteIndexOutOfBoundsInfo())
        #if _endian(big)
        return self.lastIndex - index
        #else
        return index
        #endif
    }
    
    @inlinable static func endiannessSensitiveByteOffset(unchecked index: Int) -> Int {
        self.endiannessSensitiveIndex(unchecked: index) * MemoryLayout<UInt>.size
    }
}
