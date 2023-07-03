//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Messages
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A message describing the location of an overflow occurrence.
    @inlinable public static func callsiteOverflowInfo(
    function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> String {
        "overflow in \(function) at \(file):\(line)"
    }
    
    /// A message describing the location of an index-out-of-bounds occurrence.
    @inlinable public static func callsiteIndexOutOfBoundsInfo(
    function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> String {
        "index out of bounds in \(function) at \(file):\(line)"
    }
    
    /// A message describing the location of a shift-out-of-bounds occurrence.
    @inlinable public static func callsiteShiftOutOfBoundsInfo(
    function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> String {
        "shift out of bounds in \(function) at \(file):\(line)"
    }
    
    /// A message describing the location of a rotation-out-of-bounds occurrence.
    @inlinable public static func callsiteRotationOutOfBoundsInfo(
    function: StaticString = #function, file: StaticString = #file, line: UInt = #line) -> String {
        "rotation out of bounds in \(function) at \(file):\(line)"
    }
}
