//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Static Big Int
//*============================================================================*
#if SBI && swift(>=5.8)

/// It's like Swift.StaticBigInt, but a random access collection.
@frozen public struct NBKStaticBigInt: ExpressibleByIntegerLiteral, RandomAccessCollection, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ other: StaticBigInt) {
        self.base = other
    }
    
    @inlinable public init(integerLiteral other: StaticBigInt) {
        self.init(other)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison against zero.
    ///
    /// ```
    /// ┌────── → ────────┐
    /// │ self  │ signum  │
    /// ├────── → ────────┤
    /// │ -2    │ Int(-1) │ - less
    /// │  0    │ Int( 0) │ - same
    /// │  2    │ Int( 1) │ - more
    /// └────── → ────────┘
    /// ```
    ///
    @inlinable public func signum() -> Int {
        self.base.signum()
    }
    
    /// The number of bits in this value's binary representation.
    @inlinable public var bitWidth: Int {
        self.base.bitWidth
    }
    
    /// Accesses the word at the given index, from least significant to most.
    @inlinable public subscript(index: Int) -> UInt {
        self.base[index]
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKStaticBigInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        let width = NBK.ZeroOrMore(unchecked: self.bitWidth)
        let major = NBK .quotient(dividing: width, by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(dividing: width, by: NBK.PowerOf2(bitWidth: UInt.self))
        return major &+ Int(bit: minor.isMoreThanZero) as Int
    }
    
    @inlinable public var startIndex: Int {
        0 as Int
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
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

//*============================================================================*
// MARK: * NBK x Static Big Int x Swift
//*============================================================================*

extension Swift.StaticBigInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ other: NBKStaticBigInt) {
        self = other.base
    }
}

#endif
