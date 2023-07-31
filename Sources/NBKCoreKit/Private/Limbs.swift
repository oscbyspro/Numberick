//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Limbs
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limbs<A, B>(_ source: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        switch A.Element.bitWidth >= B.Element.bitWidth {
        case  true: return NBK.minorLimbs(majorLimbs: source, isSigned: isSigned)
        case false: return NBK.majorLimbs(minorLimbs: source, isSigned: isSigned) }
    }
    
    @inlinable static func minorLimbs<A, B>(majorLimbs: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth >= B.Element.bitWidth)
        //=--------------------------------------=
        let ratio: Int = A.Element.bitWidth / B.Element.bitWidth
        var minorLimbs = B(); minorLimbs.reserveCapacity(majorLimbs.count * ratio)
        //=--------------------------------------=
        for var majorLimb in majorLimbs {
            for _ in 0 ..< ratio {
                minorLimbs.append(B.Element(truncatingIfNeeded: majorLimb))
                majorLimb &>>= B.Element.bitWidth
            }
        }
        //=--------------------------------------=
        return (minorLimbs) as B
    }
    
    @inlinable static func majorLimbs<A, B>(minorLimbs: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth <= B.Element.bitWidth)
        //=--------------------------------------=
        let ratio: Int = B.Element.bitWidth / A.Element.bitWidth
        let count = minorLimbs.count.quotientAndRemainder(dividingBy: ratio)
        var majorLimbs = B(repeating: B.Element.zero, count: count.quotient + Int(bit: !count.remainder.isZero))
        //=--------------------------------------=
        var minorShift = Int.zero
        var majorIndex = majorLimbs.startIndex as B.Index
        
        for minorLimb in minorLimbs {
            majorLimbs[majorIndex] |= B.Element(truncatingIfNeeded: minorLimb.bitPattern) &<< minorShift
            minorShift += A.Element.bitWidth
            
            if  minorShift >= B.Element.bitWidth {
                minorShift -= B.Element.bitWidth
                majorLimbs.formIndex(after: &majorIndex)
            }
        }
        
        if !minorShift.isZero, isSigned {
            majorLimbs[majorIndex] |= B.Element(repeating: minorLimbs.last!.mostSignificantBit) &<< minorShift
        }
        //=--------------------------------------=
        return (majorLimbs) as B
    }
}
