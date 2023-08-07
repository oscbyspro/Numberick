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
// MARK: * NBK x Resizable Width x IntXR or UIntXR
//*============================================================================*

public protocol IntXROrUIntXR: NBKBinaryInteger, LosslessStringConvertible, MutableCollection,
RandomAccessCollection where Element == UInt, Index == Int, Indices == Range<Int> {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Size
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ word: UInt)
    
    @inlinable mutating func resize(minCount: Int)
    
    @inlinable mutating func resize(maxCount: Int)
    
    @inlinable mutating func reserveCapacity(_ minCapacity: Int)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    func compared(to other: Self,  at index: Int) -> Int
        
    func compared(to other: Digit, at index: Int) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func bitshiftLeftSmart(by distance: Int)
    
    @inlinable func bitshiftedLeftSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(by distance: Int)
    
    @inlinable func bitshiftedLeft(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int, bits: Int)
    
    @inlinable func bitshiftedLeft(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int)
    
    @inlinable func bitshiftedLeft(words: Int) -> Self
    
    @inlinable mutating func bitshiftRightSmart(by distance: Int)
    
    @inlinable func bitshiftedRightSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(by distance: Int)
    
    @inlinable func bitshiftedRight(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int, bits: Int)
    
    @inlinable func bitshiftedRight(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int)
    
    @inlinable func bitshiftedRight(words: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func updateZeroValue()
    
    @inlinable mutating func update(repeating bit:  Bool)
    
    @inlinable mutating func update(repeating word: UInt)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Words
    //=------------------------------------------------------------------------=
    
    @inlinable var first: UInt { get set }
    
    @inlinable var last:  UInt { get set }
    
    @inlinable var tail: Digit { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Words x Pointers
    //=------------------------------------------------------------------------=
    
    @inlinable func withContiguousStorage<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T
        
    @inlinable func withContiguousStorageIfAvailable<T>(_ body: (NBK.UnsafeWords) throws -> T) rethrows -> T?
    
    @inlinable mutating func withContiguousMutableStorage<T>(_ body: (inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T
    
    @inlinable mutating func withContiguousMutableStorageIfAvailable<T>(_ body: (inout NBK.UnsafeMutableWords) throws -> T) rethrows -> T?
}
