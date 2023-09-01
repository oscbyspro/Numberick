//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Offset Indexed
//*============================================================================*

/// A random access collection with indices from `zero` to `count`.
///
/// ### Defaults
///
/// The defaults provided depend on an independent `count` accessor.
///
public protocol NBKOffsetIndexed: RandomAccessCollection where Indices == Range<Int> { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKOffsetIndexed {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        Int.zero
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public var indices: Range<Int> {
        Range(uncheckedBounds:(Int.zero, self.count))
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
        NBK.offset(index, by: distance, limit: limit)
    }
}

//*============================================================================*
// MARK: * NBK x Offset Indexed x Algorithms
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the array-like result of  `index(_:offsetBy:limitedBy:)`.
    @inlinable public static func offset(_ index: Int, by distance: Int, limit: Int) -> Int? {
        let distanceLimit = limit - index
        
        guard distance >= Int.zero
        ? distance <= distanceLimit || distanceLimit < Int.zero
        : distance >= distanceLimit || distanceLimit > Int.zero
        else { return nil }
        
        return index + distance as Int
    }
}

//*============================================================================*
// MARK: * NBK x Offset Indexed x Swift
//*============================================================================*

extension Array:                      NBKOffsetIndexed { }
extension ContiguousArray:            NBKOffsetIndexed { }
extension UnsafeBufferPointer:        NBKOffsetIndexed { }
extension UnsafeMutableBufferPointer: NBKOffsetIndexed { }
