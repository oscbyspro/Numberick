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
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    func compared(to other: Self,  at index: Int) -> Int
        
    func compared(to other: Digit, at index: Int) -> Int
    
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
