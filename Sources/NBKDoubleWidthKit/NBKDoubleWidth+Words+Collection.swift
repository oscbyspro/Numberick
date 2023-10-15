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
// MARK: * NBK x Double Width x Words x Collection
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Indices
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Checks whether this collection is empty.
    ///
    /// - Note: `NBKDoubleWidth` contains at least two elements.
    ///
    @inlinable public var isEmpty: Bool {
        false
    }
    
    /// The index of the least significant word.
    @inlinable public var startIndex: Int {
        0 as Int
    }
    
    /// The index of the most significant word.
    @inlinable public var lastIndex: Int {
        self.count - 1 as Int
    }
    
    /// The index after the last valid subscript argument.
    @inlinable public var endIndex: Int {
        self.count
    }
    
    /// A collection of each valid subscript argument, in ascending order.
    @inlinable public var indices: Range<Int> {
        0 as Int ..< self.count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index + 1 as Int
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index - 1 as Int
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        NBK.arrayIndex(index, offsetBy: distance, limitedBy: limit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements
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
}

//=----------------------------------------------------------------------------=
// MARK: + Elements x Subscripts
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {
    
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
            let byteOffset = BitPattern.endiannessSensitiveByteOffset(of: T.BitPattern.self, at: index)
            assert(0 <= byteOffset && byteOffset <= MemoryLayout<Self>.size - MemoryLayout<T>.stride, NBK.callsiteOutOfBoundsInfo())
            return Swift.withUnsafePointer(to: self) { pointer in
                UnsafeRawPointer(pointer).load(fromByteOffset: byteOffset, as: T.self)
            }
        }
        
        set {
            let byteOffset = BitPattern.endiannessSensitiveByteOffset(of: T.BitPattern.self, at: index)
            assert(0 <= byteOffset && byteOffset <= MemoryLayout<Self>.size - MemoryLayout<T>.stride, NBK.callsiteOutOfBoundsInfo())
            Swift.withUnsafeMutablePointer(to: &self) { pointer in
                UnsafeMutableRawPointer(pointer).storeBytes(of: newValue, toByteOffset: byteOffset, as: T.self)
            }
        }
    }
}
