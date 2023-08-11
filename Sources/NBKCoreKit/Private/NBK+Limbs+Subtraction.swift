//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//=----------------------------------------------------------------------------=
// TODO: see whether consuming arguments removes need for inout versions in 5.9
//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Limbs + Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by limbs: T, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedInteger(&pointee, by: limbs, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially decrements `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by limbs: T, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by limbs: T, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs, plus: &bit, at: &index)
        NBK.decrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
    }
    
    /// Partially decrements `pointee` by the sum of `limbs` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by limbs: T, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        for limbsIndex in limbs.indices {
            NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: limbs[limbsIndex], plus: &bit, at: &index)
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
    
    /// Decrements `pointee` by `digit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool
        bit =  NBK.decrementSufficientUnsignedInteger(&pointee, by: digit, at: &index)
        return IO(index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially decrements `pointee` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool
        bit =  NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, at: &index)
        return IO(index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by `digit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var bit = NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, at: &index)
        NBK.decrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
        return bit as Bool
    }
    
    /// Partially decrements `pointee` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, at index: inout T.Index) -> Bool
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        defer{ pointee.formIndex(after: &index) }
        return pointee[index].subtractReportingOverflow(digit)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Digit + Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedInteger(&pointee, by: digit, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    /// Partially decrements `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee, by: digit, plus: &bit, at: &index)
        NBK.decrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
    }
    
    /// Partially decrements `pointee` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedIntegerInIntersection<T>(
    _ pointee: inout T, by digit: T.Element, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var digit: T.Element = digit

        if  bit {
            bit = digit.addReportingOverflow(1 as T.Element.Digit)
        }
        
        if !bit {
            bit = pointee[index].subtractReportingOverflow(digit)
        }
        
        pointee.formIndex(after: &index)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedInteger(&pointee, by: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _ pointee: inout T, by bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        while bit && index < pointee.endIndex {
            bit = pointee[index].subtractReportingOverflow(1 as T.Element.Digit)
            pointee.formIndex(after: &index)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Limbs × Digit + Digit + Bit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the product of `limbs` and `multiplicand` at `index`,
    /// and the sum of `subtrahend` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @_transparent @discardableResult public static func decrementSufficientUnsignedInteger<T>(
    _  pointee: inout T, by limbs: T, times multiplicand: T.Element, plus subtrahend: T.Element, plus bit: Bool, at index: T.Index) -> IO<T.Index>
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var index: T.Index = index, bit: Bool = bit
        NBK.decrementSufficientUnsignedInteger(&pointee, by: limbs, times: multiplicand, plus: subtrahend, plus: &bit, at: &index)
        return IO(index: index as T.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `pointee` by the product of `limbs` and `multiplicand` at `index`,
    /// and the sum of `subtrahend` and `bit` at `index`.
    ///
    /// - This operation must not overflow the `pointee` subsequence by more than one bit.
    ///
    /// - Returns: An overflow indicator and its index in `pointee`.
    ///
    @inlinable public static func decrementSufficientUnsignedInteger<T>(
    _  pointee: inout T, by limbs: T, times multiplicand: T.Element, plus subtrahend: T.Element, plus bit: inout Bool, at index: inout T.Index)
    where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var last: T.Element = subtrahend
        
        for limbsIndex in limbs.indices {
            var subproduct = limbs[limbsIndex].multipliedFullWidth(by: multiplicand)
            last = T.Element(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            NBK.decrementSufficientUnsignedIntegerInIntersection(&pointee,  by: subproduct.low, plus: &bit, at: &index)
        }
        
        NBK.decrementSufficientUnsignedInteger(&pointee, by: last, plus: &bit, at: &index)
    }
}
