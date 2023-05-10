//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width Integer x Shifts
//*============================================================================*

extension DoubleWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError()
    }
    
    @inlinable public static func <<(lhs: Self, rhs: some BinaryInteger) -> Self {
        fatalError()
    }
    
    @inlinable public static func &<<=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError()
    }
    
    @inlinable public static func &<<(lhs: Self, rhs: some BinaryInteger) -> Self {
        fatalError()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func >>=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError()
    }
    
    @inlinable public static func >>(lhs: Self, rhs: some BinaryInteger) -> Self {
        fatalError()
    }
    
    @inlinable public static func &>>=(lhs: inout Self, rhs: some BinaryInteger) {
        fatalError()
    }
    
    @inlinable public static func &>>(lhs: Self, rhs: some BinaryInteger) -> Self {
        fatalError()
    }
}
