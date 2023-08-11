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
// MARK: * NBK x Limbs x Subtraction
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T, at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedInteger(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    /// Partially decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by subtrahend: T, at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedInteger(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        NBK.decrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, borrowing: &overflow)
    }
    
    /// Partially decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by subtrahend: T, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for subtrahendIndex in subtrahend.indices { // for-index-in >= for-element-in
            NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend[subtrahendIndex], at: &index, borrowing: &overflow)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Digit
//*============================================================================*

extension NBK {
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by `subtrahend` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let (index, overflow) = NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend, at: index)
        return NBK.decrementSufficientUnsignedInteger(&limbs, by: Void(), at: index, borrowing: overflow) as IO
    }
    
    /// Partially decrements `limbs` by `subtrahend` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let overflow = limbs[index].subtractReportingOverflow(subtrahend)
        return IO(limbs.index(after: index), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by `subtrahend` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var overflow = NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend, at: &index)
        NBK.decrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, borrowing: &overflow)
        return overflow as Bool
    }
    
    /// Partially decrements `limbs` by `subtrahend` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ limbs.formIndex(after: &index) }
        return limbs[index].subtractReportingOverflow(subtrahend)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Digit x Carry
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedInteger(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    /// Partially decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: T.Element, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subtrahend, at: &index, borrowing: &overflow)
        NBK.decrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, borrowing: &overflow)
    }
    
    /// Partially decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
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
// MARK: * NBK x Limbs x Subtraction x Void
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: Void, at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of `subtrahend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by subtrahend: Void, at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while overflow && index < limbs.endIndex {
            overflow = limbs[index].subtractReportingOverflow(1 as T.Element.Digit)
            limbs.formIndex(after: &index)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Product
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of the `subtrahend`, the `overflow`, and
    /// the product of `other` and `multiplicand` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func decrementSufficientUnsignedInteger<T>(
    _  limbs: inout T, by other: T, times multiplicand: T.Element, plus subtrahend: T.Element,
    at index: T.Index, borrowing overflow: Bool) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.decrementSufficientUnsignedInteger(&limbs, by: other, times: multiplicand, plus: subtrahend, at: &index, borrowing: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `limbs` by the sum of the `subtrahend`, the `overflow`, and
    /// the product of `other` and `multiplicand` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _  limbs: inout T, by other: T, times multiplicand: T.Element, plus subtrahend: T.Element,
    at index: inout T.Index, borrowing overflow: inout Bool)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var last: T.Element = subtrahend
        
        for otherIndex in other.indices {
            var subproduct = other[otherIndex].multipliedFullWidth(by: multiplicand)
            last = T.Element(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            NBK.decrementSufficientUnsignedIntegerInIntersection(&limbs, by: subproduct.low, at: &index, borrowing: &overflow)
        }
        
        NBK.decrementSufficientUnsignedInteger(&limbs, by: last, at: &index, borrowing: &overflow)
    }
}
