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
// MARK: * NBK x Flexible Width x IntXL or UIntXL
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger, ExpressibleByStringLiteral where Magnitude == UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    /// An instance that is equal to `0`.
    @inlinable static var zero: Self { get }
    
    /// An instance that is equal to `1`.
    @inlinable static var one:  Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    /// A three-way comparison between `self` and `other` at `index`.
    ///
    /// - Parameters:
    ///   - other: Another integer instance.
    ///   - index: The non-negative offset of `other` measured in `Digit` positions.
    ///
    @inlinable func compared(to other: Self, at index: Int) -> Int
    
    /// A three-way comparison between `self` and `other` at `index`.
    ///
    /// - Parameters:
    ///   - other: Another integer instance.
    ///   - index: The non-negative offset of `other` measured in `Digit` positions.
    ///
    @_disfavoredOverload @inlinable func compared(to other: Digit, at index: Int) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, at index: Int)
    
    @_disfavoredOverload @inlinable mutating func add(_ other: Digit, at index: Int)

    @inlinable func adding(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable func adding(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, at index: Int)
    
    @_disfavoredOverload @inlinable mutating func subtract(_ other: Digit, at index: Int)

    @inlinable func subtracting(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable func subtracting(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func bitShiftLeftSmart(by distance: Int)
    
    @inlinable func bitShiftedLeftSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitShiftLeft(by distance: Int)
    
    @inlinable func bitShiftedLeft(by distance: Int) -> Self
    
    @inlinable mutating func bitShiftLeft(major: Int, minor: Int)
    
    @inlinable func bitShiftedLeft(major: Int, minor: Int) -> Self
    
    @inlinable mutating func bitShiftLeft(major: Int)
    
    @inlinable func bitShiftedLeft(major: Int) -> Self
    
    @inlinable mutating func bitShiftRightSmart(by distance: Int)
    
    @inlinable func bitShiftedRightSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitShiftRight(by distance: Int)
    
    @inlinable func bitShiftedRight(by distance: Int) -> Self
    
    @inlinable mutating func bitShiftRight(major: Int, minor: Int)
    
    @inlinable func bitShiftedRight(major: Int, minor: Int) -> Self
    
    @inlinable mutating func bitShiftRight(major: Int)
    
    @inlinable func bitShiftedRight(major: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Update
    //=------------------------------------------------------------------------=
    
    /// Updates this instance in-place so it equals `value`.
    ///
    /// - Note: This operation is much more efficent than allocating new storage.
    ///
    @inlinable mutating func update(_ value: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Words
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to the words of this instance.
    ///
    /// ```
    /// ┌──────────────────────── = ───────────────────────────┐
    /// │ self                    │ words on a 64-bit machine  │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │  IntXL(           )     │ [ 0                      ] │
    /// │  IntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │  IntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1,  0] │
    /// │  IntXL( Int256.min)     │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │  IntXL( Int256.min) + 1 │ [~0, ~0, ~0, ~0/2 + 0, ~0] │
    /// │  IntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0,  0] │
    /// │  IntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │ UIntXL(           )     │ [ 0                      ] │
    /// │ UIntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │ UIntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │ UIntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0    ] │
    /// │ UIntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// └──────────────────────── = ───────────────────────────┘
    /// ```
    ///
    @inlinable func withUnsafeBufferPointer<T>(
    _ body: (UnsafeBufferPointer<UInt>) throws -> T) rethrows -> T
    
    /// Grants unsafe access to the mutable words of this instance.
    ///
    /// ```
    /// ┌──────────────────────── = ───────────────────────────┐
    /// │ self                    │ words on a 64-bit machine  │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │  IntXL(           )     │ [ 0                      ] │
    /// │  IntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │  IntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1,  0] │
    /// │  IntXL( Int256.min)     │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │  IntXL( Int256.min) + 1 │ [~0, ~0, ~0, ~0/2 + 0, ~0] │
    /// │  IntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0,  0] │
    /// │  IntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │ UIntXL(           )     │ [ 0                      ] │
    /// │ UIntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │ UIntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │ UIntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0    ] │
    /// │ UIntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// └──────────────────────── = ───────────────────────────┘
    /// ```
    ///
    /// - Note: The words of this instance will be normalized after this operation.
    ///
    @inlinable mutating func withUnsafeMutableBufferPointer<T>(
    _ body: (inout UnsafeMutableBufferPointer<UInt>) throws -> T) rethrows -> T
    
    /// Creates a new instance with unsafe access to its uninitialized words.
    ///
    /// The `init` is responsible for initializing all `count` words given to it.
    ///
    /// - Note: While the resulting instance may have a capacity larger than the
    /// requested amount, the buffer passed to `init` will cover exactly the requested
    /// number of words.
    ///
    /// - Note: This is a non-throwing convenience for `uninitialized(capacity:init:)`.
    ///
    /// ### Semantics when there is no initialized prefix
    ///
    /// It returns zero when there is no initialized prefix because the following
    /// expressions must return the same values:
    ///
    /// ```swift
    /// 1. Self.init(words:   words) // this is zero when words == []
    /// 2. Self.uninitialized(count:    words.count) {  _ = $0.initialize(from: words).index }
    /// 3. Self.uninitialized(capacity: words.count) { $1 = $0.initialize(from: words).index }
    /// ```
    ///
    @inlinable static func uninitialized(
    count: Int, init: (inout UnsafeMutableBufferPointer<UInt>) -> Void) -> Self
    
    /// Creates a new instance with unsafe access to its uninitialized words.
    ///
    /// The `init` is responsible for initializing up to `capacity` prefixing words.
    /// The `init` is given a buffer and an initialized prefix count. All words in
    /// the prefix must be initialized and all words after it must be uninitialized.
    /// This postcondition must hold even when the `init` throws an error.
    ///
    /// - Note: While the resulting instance may have a capacity larger than the
    /// requested amount, the buffer passed to `init` will cover exactly the requested
    /// number of words.
    ///
    /// ### Semantics when there is no initialized prefix
    ///
    /// It returns zero when there is no initialized prefix because the following
    /// expressions must return the same values:
    ///
    /// ```swift
    /// 1. Self.init(words:   words) // this is zero when words == []
    /// 2. Self.uninitialized(count:    words.count) {  _ = $0.initialize(from: words).index }
    /// 3. Self.uninitialized(capacity: words.count) { $1 = $0.initialize(from: words).index }
    /// ```
    ///
    @inlinable static func uninitialized(
    capacity: Int, init: (inout UnsafeMutableBufferPointer<UInt>, inout Int) throws -> Void) rethrows -> Self
}
