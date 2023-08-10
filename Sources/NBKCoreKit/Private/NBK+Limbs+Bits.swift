//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Limbs x Bits
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details
    //=------------------------------------------------------------------------=
    
    /// Returns the leading zero bit count of `limbs`.
    ///
    /// - Note: The leading zero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func leadingZeroBitCount<T: NBKFixedWidthInteger>(of limbs: some BidirectionalCollection<T>) -> Int {
        var index = limbs.endIndex
        var element = T.zero
        
        while index > limbs.startIndex, element.isZero {
            limbs.formIndex(before: &index)
            element = limbs[index]
        }
        
        return limbs.distance(from: index, to: limbs.endIndex) * T.bitWidth - T.bitWidth + element.leadingZeroBitCount
    }
    
    /// Returns the trailing zero bit count of `limbs`.
    ///
    /// - Note: The trailing zero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func trailingZeroBitCount<T: NBKFixedWidthInteger>(of limbs: some Collection<T>) -> Int {
        var index = limbs.startIndex
        var element = T.zero
        
        while index < limbs.endIndex, element.isZero {
            element = limbs[index]
            limbs.formIndex(after: &index)
        }
        
        return limbs.distance(from: limbs.startIndex, to: index) * T.bitWidth - T.bitWidth + element.trailingZeroBitCount
    }
    
    /// Returns the most significant bit for the two's complement of `limbs`.
    ///
    /// - Note: The most significant bit does not exist when `limbs` is empty.
    ///
    @inlinable public static func mostSignificantBit(twosComplementOf limbs: some BidirectionalCollection<some NBKFixedWidthInteger>) -> Bool? {
        guard let index = limbs.firstIndex(where:{ !$0.isZero }) else { return limbs.isEmpty ? nil : false }
        let lastIndex = limbs.index(before: limbs.endIndex)
        return limbs[lastIndex].twosComplementSubsequence(index == lastIndex).partialValue.mostSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Nonzero Bit Count
    //=------------------------------------------------------------------------=
    
    /// Returns the nonzero bit count of `limbs`.
    ///
    /// - Note: The nonzero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func nonzeroBitCount(of limbs: some Collection<some NBKFixedWidthInteger>) -> Int {
        limbs.reduce(Int.zero) { $0 + $1.nonzeroBitCount }
    }
    
    /// Returns whether the nonzero bit count of `limbs` equals `comparand`.
    ///
    /// - Note: The nonzero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func nonzeroBitCount(of limbs: some Collection<some NBKFixedWidthInteger>, equals comparand: Int) -> Bool {
        var count = Int()
        var index = limbs.startIndex
        
        accumulate: while index < limbs.endIndex, count <= comparand {
            count += limbs[index].nonzeroBitCount
            limbs.formIndex(after: &index)
        }
        
        return (count == comparand) as Bool
    }
    
    /// Returns the nonzero bit count for the two's complement of `limbs`.
    ///
    /// - Note: The nonzero bit count is zero when `limbs` is empty.
    ///
    @inlinable public static func nonzeroBitCount(twosComplementOf limbs: some Collection<some NBKFixedWidthInteger>) -> Int {
        guard let index = limbs.firstIndex(where:{ !$0.isZero }) else { return Int.zero }
        return limbs.indices[index...].reduce(1 - limbs[index].trailingZeroBitCount) { $0 + limbs[$1].onesComplement().nonzeroBitCount }
    }
}
