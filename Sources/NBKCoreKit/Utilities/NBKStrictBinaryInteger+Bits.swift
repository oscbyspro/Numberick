//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Bits x Sub Sequence
//*============================================================================*

extension NBK.StrictBinaryInteger.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the leading zero bit count of `base`.
    ///
    /// - Note: The leading zero bit count is zero when `base` is empty.
    ///
    @inlinable public static func leadingZeroBitCount(of base: Base) -> Int {
        var index = base.endIndex
        var element = 0 as Base.Element
        
        while index > base.startIndex, element.isZero {
            base.formIndex(before: &index)
            element = base[index]
        }
        
        let product = base.distance(from: index, to: base.endIndex) * Base.Element.bitWidth
        return product - Base.Element.bitWidth + element.leadingZeroBitCount
    }
    
    /// Returns the trailing zero bit count of `base`.
    ///
    /// - Note: The trailing zero bit count is zero when `base` is empty.
    ///
    @inlinable public static func trailingZeroBitCount(of base: Base) -> Int {
        var index = base.startIndex
        var element = 0 as Base.Element
        
        while index < base.endIndex, element.isZero {
            element = base[index]
            base.formIndex(after: &index)
        }
        
        let product = base.distance(from: base.startIndex, to: index) * Base.Element.bitWidth
        return product - Base.Element.bitWidth + element.trailingZeroBitCount
    }
    
    /// Returns the most significant bit for the two's complement of `base`.
    ///
    /// - Note: The most significant bit does not exist when `base` is empty.
    ///
    @inlinable public static func mostSignificantBit(twosComplementOf base: Base) -> Bool? {
        //=--------------------------------------=
        guard let index = base.firstIndex(where:{ !$0.isZero }) else { return base.isEmpty ? nil : false }
        //=--------------------------------------=
        let lastIndex = base.index(before: base.endIndex)
        return base[lastIndex].twosComplementSubsequence(index == lastIndex).partialValue.mostSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Nonzero Bit Count
    //=------------------------------------------------------------------------=
    
    /// Returns the nonzero bit count of `base`.
    ///
    /// - Note: The nonzero bit count is zero when `base` is empty.
    ///
    @inlinable public static func nonzeroBitCount(of base: Base) -> Int {
        base.reduce(0 as Int) { $0 + $1.nonzeroBitCount }
    }
    
    /// Returns whether the nonzero bit count of `base` equals `comparand`.
    ///
    /// - Note: The nonzero bit count is zero when `base` is empty.
    ///
    @inlinable public static func nonzeroBitCount(of base: Base, equals comparand: Int) -> Bool {
        var nonzeroBitCount = 0 as Int
        var index: Base.Index = base.startIndex
        
        while index < base.endIndex, nonzeroBitCount <= comparand {
            nonzeroBitCount += base[index].nonzeroBitCount
            base.formIndex(after:  &index)
        }
        
        return (nonzeroBitCount == comparand) as Bool
    }
    
    /// Returns the nonzero bit count for the two's complement of `base`.
    ///
    /// - Note: The nonzero bit count is zero when `base` is empty.
    ///
    @inlinable public static func nonzeroBitCount(twosComplementOf base: Base)  -> Int {
        //=--------------------------------------=
        guard var index = base.firstIndex(where:{ !$0.isZero }) else { return 0 as Int }
        //=--------------------------------------=
        var nonzeroBitCount: Int = 1 - base[index].trailingZeroBitCount
        
        while index < base.endIndex {
            nonzeroBitCount += base[index].onesComplement().nonzeroBitCount
            base.formIndex(after:  &index)
        }
        
        return nonzeroBitCount as Int
    }
}
