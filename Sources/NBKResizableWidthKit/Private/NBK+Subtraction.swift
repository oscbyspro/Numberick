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
// MARK: * NBK x Subtraction
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementAsUnsigned(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }

    @_transparent public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementAsUnsigned(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        NBK.decrementAsUnsigned(&limbs, by: Void(), at: &index, borrowing: &overflow)
    }
    
    @inlinable public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for subtrahendIndex in subtrahend.indices { // for-index-in >= for-element-in
            NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend[subtrahendIndex], at: &index, borrowing: &overflow)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Subtraction x Digit
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let (index, overflow) = NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend, at: index)
        return NBK.decrementAsUnsigned(&limbs, by: overflow, at: index) as IO
    }
    
    @_transparent public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let overflow = limbs[index].addReportingOverflow(subtrahend)
        return IO(limbs.index(after: index), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
        
    @inlinable public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var overflow = NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend, at: &index)
        NBK.decrementAsUnsigned(&limbs, by: Void(), at: &index, borrowing: &overflow)
        return overflow as Bool
    }
    
    @inlinable public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ limbs.formIndex(after: &index) }
        return limbs[index].addReportingOverflow(subtrahend)
    }
}

//*============================================================================*
// MARK: * NBK x Subtraction x Digit x Carry
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T.Element, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementAsUnsigned(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    @_transparent public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, plus overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementAsUnsignedInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        NBK.decrementAsUnsigned(&limbs, by: Void(), at: &index, borrowing: &overflow)
    }
    
    @inlinable public static func decrementAsUnsignedInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var subtrahend: T.Element = subtrahend
        
        if  overflow {
            overflow = subtrahend.addReportingOverflow(1 as T.Element.Digit)
        }
        
        if !overflow {
            overflow = limbs[index].subtractReportingOverflow(subtrahend)
        }
        
        limbs.formIndex(after: &index)
    }
}

//*============================================================================*
// MARK: * NBK x Subtraction x Bool
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = subtrahend
        NBK.decrementAsUnsigned(&limbs, by: Void(), at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by subtrahend: Void, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while overflow && index < limbs.endIndex {
            overflow = limbs[index].subtractReportingOverflow(1 as T.Element.Digit)
            limbs.formIndex(after: &index)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Subtraction x Product
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent public static func decrementAsUnsigned<T>(
    _ limbs: inout T, by other: T, times multiplicand: T.Element, plus subtrahend: T.Element,
    and overflow: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementAsUnsigned(&limbs, by: other, times: multiplicand, plus: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decrementAsUnsigned<T>(
    _  limbs: inout T, by other: T, times multiplicand: T.Element, plus subtrahend: T.Element,
    at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var last: T.Element = subtrahend
        
        for otherIndex in other.indices {
            var subproduct = other[otherIndex].multipliedFullWidth(by: multiplicand)
            last = T.Element(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            NBK.decrementAsUnsignedInIntersection(&limbs, by: subproduct.low, at: &index, borrowing: &overflow)
        }
        
        NBK.decrementAsUnsigned(&limbs, by: last, at: &index, borrowing: &overflow)
    }
}
