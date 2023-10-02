//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Swift
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the given `value` as some `Swift.BinaryInteger`.
    @inlinable public static func someSwiftBinaryInteger<T>(
    _   value: T) -> some Swift.BinaryInteger where T: Swift.BinaryInteger {
        value
    }
    
    /// Returns the given `value` as some `Swift.FixedWidthInteger`.
    @inlinable public static func someSwiftFixedWidthInteger<T>(
    _   value: T) -> some Swift.FixedWidthInteger where T: Swift.FixedWidthInteger {
        value
    }
}
