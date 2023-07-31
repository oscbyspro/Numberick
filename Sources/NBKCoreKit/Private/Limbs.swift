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
    
    @inlinable public static func limbs<A, B>(_ other: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        switch A.Element.bitWidth >= B.Element.bitWidth {
        case  true: return NBK.minorLimbs(majorLimbs: other, isSigned: isSigned)
        case false: return NBK.majorLimbs(minorLimbs: other, isSigned: isSigned) }
    }
    
    @inlinable static func minorLimbs<A, B>(majorLimbs: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth >= B.Element.bitWidth)
        //=--------------------------------------=
        let ratio: Int  = A.Element.bitWidth / B.Element.bitWidth
        var destination = B(); destination.reserveCapacity(majorLimbs.count * ratio)
        //=--------------------------------------=
        for var majorLimb in majorLimbs {
            for _ in 0 ..< ratio {
                destination.append(B.Element(truncatingIfNeeded: majorLimb))
                majorLimb &>>= B.Element.bitWidth
            }
        }
        //=--------------------------------------=
        return destination as B
    }
    
    @inlinable static func majorLimbs<A, B>(minorLimbs: A, isSigned: Bool = false, as type: B.Type = B.self) -> B where
    A:  RandomAccessCollection, A.Element: NBKCoreInteger, B: RangeReplaceableCollection & MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth <= B.Element.bitWidth)
        //=--------------------------------------=
        let ratio: Int = B.Element.bitWidth / A.Element.bitWidth
        let count = minorLimbs.count.quotientAndRemainder(dividingBy: ratio)
        var destination = B(repeating: B.Element.zero, count: count.quotient + Int(bit: !count.remainder.isZero))
        //=--------------------------------------=
        var major = Int.zero
        var minor = Int.zero
                
        for minorLimb in minorLimbs {
            let destinationIndex = destination.index(destination.startIndex, offsetBy: major)
            destination[destinationIndex] |= B.Element(truncatingIfNeeded: minorLimb.bitPattern) &<< minor
            minor += A.Element.bitWidth
            
            if  minor >= B.Element.bitWidth {
                minor -= B.Element.bitWidth
                major += 1
            }
        }
        
        if !minor.isZero, isSigned {
            let destinationIndex = destination.index(destination.startIndex, offsetBy: major)
            destination[destinationIndex] |= B.Element(repeating: minorLimbs.last!.mostSignificantBit) &<< minor
        }
        //=--------------------------------------=
        return destination as B
    }
}
