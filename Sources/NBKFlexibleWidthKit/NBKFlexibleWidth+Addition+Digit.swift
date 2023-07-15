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
// MARK: * NBK x Flexible Width x Addition x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: UInt) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: UInt) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: UInt, at index: Int) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        guard !other.isZero else { return }
        //=--------------------------------------=
        self.storage.resize(minLastIndex: index + 1)
        
        var index = index as Int
        let overflow = self.storage.addAsFixedWidthUnchecked(other, beforeEndIndex: &index)
        
        self.storage.normalizeAppend(UInt(bit: overflow))
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: UInt, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func addAsFixedWidthUnchecked(_ other: UInt, beforeEndIndex index: inout Int) -> Bool {
        assert(index < self.elements.endIndex)
        //=--------------------------------------=
        var carry = self.elements[index].addReportingOverflow(other)
        self.elements.formIndex(after: &index)
        //=--------------------------------------=
        carry = self.addAsFixedWidthUnchecked(carry, upToEndIndex: &index)
        //=--------------------------------------=
        return carry as Bool
    }
    
    @inlinable mutating func addAsFixedWidthUnchecked(_ other: Bool, upToEndIndex index: inout Int) -> Bool {
        assert(index <= self.elements.endIndex)
        //=--------------------------------------=
        var overflow = other
        
        while overflow && index < self.elements.endIndex {
            overflow = self.elements[index].addReportingOverflow(1 as UInt)
            self.elements.formIndex(after: &index)
        }
        
        return overflow as Bool
    }
}
