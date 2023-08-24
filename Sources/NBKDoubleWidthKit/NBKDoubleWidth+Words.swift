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
    
    /// The number of words.
    @inlinable public static var count: Int {
        assert(MemoryLayout<Self>.size / MemoryLayout<UInt>.stride >= 2)
        assert(MemoryLayout<Self>.size % MemoryLayout<UInt>.stride == 0)
        return MemoryLayout<Self>.size / MemoryLayout<UInt>.stride
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        Self.count
    }
    
    @inlinable public var words: Self {
        _read { yield self }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Indices
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The index of the least significant word.
    @inlinable public static var startIndex: Int {
        0
    }
    
    /// The index of the most significant word.
    @inlinable public static var lastIndex: Int {
        self.count - 1
    }
    
    /// The index after the last valid subscript argument.
    @inlinable public static var endIndex: Int {
        self.count
    }
    
    /// A collection of each valid subscript argument, in ascending order.
    @inlinable public static var indices: Range<Int> {
        0 ..< self.count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        Self.startIndex
    }
    
    @inlinable public var lastIndex: Int {
        Self.lastIndex
    }
    
    @inlinable public var endIndex: Int {
        Self.endIndex
    }
    
    @inlinable public var indices: Range<Int> {
        Self.indices
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index +  1
    }
    
    @inlinable public func formIndex(after index: inout Int) {
        index += 1
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index -  1
    }
    
    @inlinable public func formIndex(before index: inout Int) {
        index -= 1
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        let distanceLimit: Int = self.distance(from: index, to: limit)
        
        guard distance >= 0
        ? distance <= distanceLimit || distanceLimit < 0
        : distance >= distanceLimit || distanceLimit > 0
        else { return nil }
        
        return self.index(index, offsetBy: distance) as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Elements
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The least significant word.
    ///
    /// - Note: This member is required by `Swift.BinaryInteger`.
    ///
    @inlinable public var _lowWord: UInt {
        self.low._lowWord // same as first
    }
    
    /// The least significant word.
    @inlinable public var first: UInt {
        _read   { yield  self[unchecked: self.startIndex] }
        _modify { yield &self[unchecked: self.startIndex] }
    }
    
    /// The most significant word.
    @inlinable public var last: UInt {
        _read   { yield  self[unchecked: self.lastIndex] }
        _modify { yield &self[unchecked: self.lastIndex] }
    }
    
    /// The most significant word, reinterpreted as a ``Digit``.
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
    /// unsigned machine word. It contains at least two words, but the exact count
    /// depends on the platform's architecture. You should, therefore, use
    /// properties like `startIndex` and `endIndex` instead of hard-coded indices.
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
    /// unsigned machine word. It contains at least two words, but the exact count
    /// depends on the platform's architecture. You should, therefore, use
    /// properties like `startIndex` and `endIndex` instead of hard-coded indices.
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
    ///   significant performance problems.
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
            precondition(self.indices ~= index, NBK.callsiteOutOfBoundsInfo())
            yield  self[unchecked: index, as: T.self]
        }
        
        _modify {
            precondition(self.indices ~= index, NBK.callsiteOutOfBoundsInfo())
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
            let offset = BitPattern.endiannessSensitiveByteOffset(at: index)
            return Swift.withUnsafeBytes(of: self) { data in
                data.load(fromByteOffset: offset, as: T.self)
            }
        }
        
        set {
            let offset = BitPattern.endiannessSensitiveByteOffset(at: index)
            Swift.withUnsafeMutableBytes(of: &self) { data in
                data.storeBytes(of: newValue, toByteOffset: offset, as: T.self)
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Unsigned
//*============================================================================*

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// Returns the in-memory byte offset of the word at the given index.
    ///
    /// - Note: This operation is unchecked.
    ///
    @inlinable static func endiannessSensitiveByteOffset(at index: Int) -> Int {
        #if _endian(big)
        return MemoryLayout<UInt>.stride * ~index + MemoryLayout<Self>.size
        #else
        return MemoryLayout<UInt>.stride * (index)
        #endif
    }
}
