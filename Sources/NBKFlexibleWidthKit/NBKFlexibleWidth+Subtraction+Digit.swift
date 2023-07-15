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
// MARK: * NBK x Flexible Width x Subtraction x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: UInt) {
        let overflow: Bool = lhs.subtractReportingOverflow(rhs, at: Int.zero)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: UInt) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs, at: Int.zero)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: UInt, at index: Int) -> Bool {
        defer {
            assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        guard !other.isZero else { return false }
        //=--------------------------------------=
        self.storage.resize(minLastIndex: index)
        
        var index = index as Int
        let overflow = self.storage.subtractAsFixedWidthUnchecked(other, beforeEndIndex: &index)
        
        self.storage.normalize()
        return overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: UInt, at index: Int) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.subtractReportingOverflow(other, at: index)
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Digit x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtractAsFixedWidthUnchecked(_ other: UInt, beforeEndIndex index: inout Int) -> Bool {
        assert(index < self.elements.endIndex)
        //=--------------------------------------=
        var overflow = self.elements[index].subtractReportingOverflow(other)
        self.elements.formIndex(after: &index)
        //=--------------------------------------=
        overflow = self.subtractAsFixedWidthUnchecked(overflow, upToEndIndex: &index)
        //=--------------------------------------=
        return overflow as Bool
    }
        
    @inlinable mutating func subtractAsFixedWidthUnchecked(_ other: Bool, upToEndIndex index: inout Int) -> Bool {
        assert(index <= self.elements.endIndex)
        //=--------------------------------------=
        var overflow = other
        
        forwards: while overflow, index < self.elements.endIndex {
            overflow = self.elements[index].subtractReportingOverflow(1 as UInt)
            self.elements.formIndex(after: &index)
        }
        
        return overflow as Bool
    }
}
