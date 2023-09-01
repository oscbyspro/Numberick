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
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

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
