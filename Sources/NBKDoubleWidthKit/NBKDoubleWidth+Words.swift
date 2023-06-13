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
    /// - Note: This member is required by `Swift.BinaryInteger`.
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
        assert(MemoryLayout<Self>.size / MemoryLayout<UInt>.stride >= 2)
        assert(MemoryLayout<Self>.size % MemoryLayout<UInt>.stride == 0)
        return MemoryLayout<Self>.size / MemoryLayout<UInt>.stride
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
    
    /// The least significant word of this integer.
    @inlinable public var first: UInt {
        _read   { yield  self[unchecked: self.startIndex] }
        _modify { yield &self[unchecked: self.startIndex] }
    }
    
    /// The most significant word of this integer.
    @inlinable public var last: UInt {
        _read   { yield  self[unchecked: self.lastIndex] }
        _modify { yield &self[unchecked: self.lastIndex] }
    }
    
    /// The most significant word of this integer, reinterpreted as a ``Digit``.
    @inlinable public var tail: Digit {
        _read   { yield  self[unchecked: self.lastIndex, as: Digit.self] }
        _modify { yield &self[unchecked: self.lastIndex, as: Digit.self] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Accesses the word at the given index, from least significant to most.
    ///
    /// ``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
    /// unsigned machine word. It contains at least two words, and its word count
    /// is always a power of two. This layout enables direct machine word access.
    /// The exact count depends on the platform's architecture. You should, therefore,
    /// use properties like `startIndex` and `endIndex` instead of hard-coded indices.
    ///
    /// ```
    /// // Int256 and UInt256, as constructed on a 64-bit platform:
    /// ┌───────────────────────────┐ ┌───────────────────────────┐
    /// │           Int256          │ │          UInt256          │
    /// ├─────────────┬─────────────┤ ├─────────────┬─────────────┤
    /// │    Int128   │   UInt128   │ │   UInt128   │   UInt128   │
    /// ├──────┬──────┼──────┬──────┤ ├──────┬──────┼──────┬──────┤
    /// │  Int │ UInt │ UInt │ UInt │ │ UInt │ UInt │ UInt │ UInt │
    /// └──────┴──────┴──────┴──────┘ └──────┴──────┴──────┴──────┘
    /// ```
    ///
    @inlinable public subscript(index: Int) -> UInt {
        _read   { yield  self[index, as: UInt.self] }
        _modify { yield &self[index, as: UInt.self] }
    }
    
    /// Accesses the word at the given index, from least significant to most.
    ///
    /// ``NBKDoubleWidth`` models a trivial `UInt` collection, where `UInt` is an
    /// unsigned machine word. It contains at least two words, and its word count
    /// is always a power of two. This layout enables direct machine word access.
    /// The exact count depends on the platform's architecture. You should, therefore,
    /// use properties like `startIndex` and `endIndex` instead of hard-coded indices.
    ///
    /// ```
    /// // Int256 and UInt256, as constructed on a 64-bit platform:
    /// ┌───────────────────────────┐ ┌───────────────────────────┐
    /// │           Int256          │ │          UInt256          │
    /// ├─────────────┬─────────────┤ ├─────────────┬─────────────┤
    /// │    Int128   │   UInt128   │ │   UInt128   │   UInt128   │
    /// ├──────┬──────┼──────┬──────┤ ├──────┬──────┼──────┬──────┤
    /// │  Int │ UInt │ UInt │ UInt │ │ UInt │ UInt │ UInt │ UInt │
    /// └──────┴──────┴──────┴──────┘ └──────┴──────┴──────┴──────┘
    /// ```
    ///
    /// - Warning: This subscript provides unchecked read and write access. Use
    ///   it only when you know the index is valid and that bounds-checking poses
    ///   significant problems. Writing to an index out of bounds is unsafe.
    ///
    @inlinable public subscript(unchecked index: Int) -> UInt {
        _read   { yield  self[unchecked: index, as: UInt.self] }
        _modify { yield &self[unchecked: index, as: UInt.self] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Private
    //=------------------------------------------------------------------------=
    
    /// Accesses the word at the given index, from least significant to most.
    ///
    /// - Parameter index: The machine word index.
    /// - Parameter type:  The machine word type, which is `Int` or `UInt`.
    ///
    @inlinable subscript<T>(_ index: Int, as type: T.Type) -> T where T: NBKCoreInteger<UInt> {
        _read {
            precondition(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            yield  self[unchecked: index, as: T.self]
        }
        
        _modify {
            precondition(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
            yield &self[unchecked: index, as: T.self]
        }
    }
        
    /// Accesses the word at the given index, from least significant to most.
    ///
    /// - Parameter index: The machine word index.
    /// - Parameter type:  The machine word type, which is `Int` or `UInt`.
    ///
    @inlinable subscript<T>(unchecked index: Int, as type: T.Type) -> T where T: NBKCoreInteger<UInt> {
        get {
            let offset = BitPattern.endiannessSensitiveByteOffset(unchecked: index)
            return Swift.withUnsafeBytes(of: self) { $0.load(fromByteOffset: offset, as: T.self) }
        }
        
        set {
            let offset = BitPattern.endiannessSensitiveByteOffset(unchecked: index)
            Swift.withUnsafeMutableBytes(of: &self) { $0.storeBytes(of: newValue, toByteOffset: offset, as: T.self) }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable static func endiannessSensitiveIndex(unchecked index: Int) -> Int {
        assert(self.indices ~= index, NBK.callsiteIndexOutOfBoundsInfo())
        #if _endian(big)
        return self.lastIndex - index
        #else
        return index
        #endif
    }
    
    @inlinable static func endiannessSensitiveByteOffset(unchecked index: Int) -> Int {
        self.endiannessSensitiveIndex(unchecked: index) * MemoryLayout<UInt>.stride
    }
}
