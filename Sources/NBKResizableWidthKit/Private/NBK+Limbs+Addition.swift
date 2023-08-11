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
// MARK: * NBK x Limbs x Addition
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T, at index: T.Index, carrying overflow: Bool) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementSufficientUnsignedInteger(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    /// Partially increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T, at index: T.Index, carrying overflow: Bool) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementSufficientUnsignedInteger(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        NBK.incrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, carrying: &overflow)
    }
    
    /// Partially increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for addendIndex in addend.indices { // for-index-in >= for-element-in
            NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend[addendIndex], at: &index, carrying: &overflow)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Digit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by `addend` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let (index, overflow) = NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend, at: index)
        return NBK.incrementSufficientUnsignedInteger(&limbs, by: Void(), at: index, carrying: overflow) as IO
    }
    
    /// Partially increments `limbs` by `addend` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        let overflow = limbs[index].addReportingOverflow(addend)
        return IO(limbs.index(after: index), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by `addend` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var overflow = NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend, at: &index)
        NBK.incrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, carrying: &overflow)
        return overflow as Bool
    }
    
    /// Partially increments `limbs` by `addend` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ limbs.formIndex(after: &index) }
        return limbs[index].addReportingOverflow(addend)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Digit x Carry
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index, carrying overflow: Bool) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementSufficientUnsignedInteger(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    /// Partially increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: T.Index, carrying overflow: Bool) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementSufficientUnsignedIntegerInIntersection(&limbs, by: addend, at: &index, carrying: &overflow)
        NBK.incrementSufficientUnsignedInteger(&limbs, by: Void(), at: &index, carrying: &overflow)
    }
    
    /// Partially increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ limbs: inout T, by addend: T.Element, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var addend: T.Element = addend
        
        if  overflow {
            overflow = addend.addReportingOverflow(1 as T.Element.Digit)
        }
        
        if !overflow {
            overflow = limbs[index].addReportingOverflow(addend)
        }
        
        limbs.formIndex(after: &index)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Void
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `limbs`.
    ///
    @_transparent public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: Void, at index: T.Index, carrying overflow: Bool) -> IO<T.Index>
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, overflow: Bool = overflow
        NBK.incrementSufficientUnsignedInteger(&limbs, by: addend, at: &index, carrying: &overflow)
        return IO(index: index as T.Index, overflow: overflow as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `limbs` by the sum of `addend` and `overflow` at `index`.
    ///
    /// - This operation must not overflow the `limbs` subsequence by more than one bit.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ limbs: inout T, by addend: Void, at index: inout T.Index, carrying overflow: inout Bool)
    where T: MutableCollection,  T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while overflow && index < limbs.endIndex {
            overflow = limbs[index].addReportingOverflow(1 as T.Element.Digit)
            limbs.formIndex(after: &index)
        }
    }
}
