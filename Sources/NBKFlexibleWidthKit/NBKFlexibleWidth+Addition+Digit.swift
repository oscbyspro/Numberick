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
// MARK: * NBK x Flexible Width x Addition x Digit x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Int) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Int) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    #warning("tests")
    @_disfavoredOverload @inlinable public mutating func add(_ other: Int, at index: Int) {
        //=--------------------------------------=
        if  self.sign ==  Sign(other.isLessThanZero) {
            self.magnitude.add(other.magnitude, at: index)
            return
        }
        //=--------------------------------------=
        //  TODO: func compared(to: Digit)
        //  TODO: Magnitude.init(digit, at: index)
        let extended = Magnitude(digit: other.magnitude).bitshiftedLeft(by: index)
        if  self.magnitude >= extended {
            self.magnitude.subtract(extended, at: Int.zero)
        //=--------------------------------------=
        }   else {
            self.sign.toggle()
            self.magnitude = extended.subtracting(self.magnitude, at: Int.zero)
        }
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: Int, at index: Int) -> Self {
        var result = self; result.add(other, at: index); return result
    }
}

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
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount:   index + 1)
        let overflow = self.storage.add(other, plus: false, at: index)
        if  overflow {
            self.storage.elements.append(1)
        }
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: UInt, at index: Int) -> Self {
        var result = self; result.add(other, at: index); return result
    }
}
