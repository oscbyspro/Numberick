//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//=----------------------------------------------------------------------------=
// TODO: see whether consuming arguments removes need for inout versions in 5.9
//*============================================================================*
// MARK: * NBK x Limbs x Addition x Limbs
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by limbs: T, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.incrementSufficientUnsignedInteger(&pointee, by: limbs, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by limbs: T, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by limbs: T, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs, plus: &bit, at: &index)
        NBK.incrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
    }
    
    /// Partially increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by limbs: T, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for limbsIndex in limbs.indices {
            NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs[limbsIndex], plus: &bit, at: &index)
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
    
    /// Increments `pointee` by `digit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool
        bit =  NBK.incrementSufficientUnsignedInteger(&pointee, by: digit, at: &index)
        return IO(index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially increments `pointee` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool
        bit =  NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, at: &index)
        return IO(index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by `digit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var bit = NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, at: &index)
        NBK.incrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
        return bit as Bool
    }
    
    /// Partially increments `pointee` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ pointee.formIndex(after: &index) }
        return pointee[index].addReportingOverflow(digit)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Digit + Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.incrementSufficientUnsignedInteger(&pointee, by: digit, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit, digit: T.Element = digit
        NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.incrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, plus: &bit, at: &index)
        NBK.incrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
    }
    
    /// Partially increments `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var digit: T.Element = digit
        
        if  bit {
            bit = digit.addReportingOverflow(1 as T.Element.Digit)
        }
        
        if !bit {
            bit = pointee[index].addReportingOverflow(digit)
        }
        
        pointee.formIndex(after: &index)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.incrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformationsx x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `pointee` by `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func incrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while bit && index < pointee.endIndex {
            bit = pointee[index].addReportingOverflow(1 as T.Element.Digit)
            pointee.formIndex(after: &index)
        }
    }
}
