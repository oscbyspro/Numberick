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
    // MARK: Details
    //=------------------------------------------------------------------------=
    
    @inlinable public static func limbs<A, BE>(_ source: A, isSigned: Bool = false, as type: Array<BE>.Type = Array<BE>.self)
    ->  Array<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        switch A.Element.bitWidth >= BE.bitWidth {
        case  true: return NBK.minorLimbs(majorLimbs: source, isSigned: isSigned, as: type)
        case false: return NBK.majorLimbs(minorLimbs: source, isSigned: isSigned, as: type) }
    }
    
    @inlinable public static func limbs<A, BE>(_ source: A, isSigned: Bool = false, as type: ContiguousArray<BE>.Type = ContiguousArray<BE>.self)
    ->  ContiguousArray<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        switch A.Element.bitWidth >= BE.bitWidth {
        case  true: return NBK.minorLimbs(majorLimbs: source, isSigned: isSigned, as: type)
        case false: return NBK.majorLimbs(minorLimbs: source, isSigned: isSigned, as: type) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Minor
    //=------------------------------------------------------------------------=
    
    @inlinable static func minorLimbs<A, BE>(majorLimbs: A, isSigned: Bool, as type: Array<BE>.Type)
    ->  Array<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        Array(unsafeUninitializedCapacity: A.Element.bitWidth / BE.bitWidth * majorLimbs.count) {
            $1 = NBK.minorLimbs(&$0, majorLimbs: majorLimbs, isSigned: isSigned)
        }
    }
    
    @inlinable static func minorLimbs<A, BE>(majorLimbs: A, isSigned: Bool, as type: ContiguousArray<BE>.Type)
    ->  ContiguousArray<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        ContiguousArray(unsafeUninitializedCapacity: A.Element.bitWidth / BE.bitWidth * majorLimbs.count) {
            $1 = NBK.minorLimbs(&$0, majorLimbs: majorLimbs, isSigned: isSigned)
        }
    }
    
    // TODO: trivial type de/init is req.
    @discardableResult @inlinable static func minorLimbs<A, B>(_ minorLimbs: inout B, majorLimbs: A, isSigned: Bool)
    ->  B.Index where A: Collection, A.Element: NBKCoreInteger, B: MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(B.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth >= B.Element.bitWidth)
        //=--------------------------------------=
        var minorLimbsIndex = minorLimbs.startIndex
        for majorLimb in majorLimbs {
            for majorLimbsShift in stride(from: Int.zero, to: A.Element.bitWidth, by:  B.Element.bitWidth) {
                minorLimbs[minorLimbsIndex] = B.Element(truncatingIfNeeded: majorLimb &>> majorLimbsShift)
                minorLimbs.formIndex(after: &minorLimbsIndex)
            }
        }
        
        return (minorLimbsIndex) as B.Index
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Major
    //=------------------------------------------------------------------------=
        
    @inlinable static func majorLimbs<A, BE>(minorLimbs: A, isSigned: Bool, as type: Array<BE>.Type)
    ->  Array<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        let count = minorLimbs.count.quotientAndRemainder(dividingBy: BE.bitWidth / A.Element.bitWidth)
        return Array(unsafeUninitializedCapacity: count.quotient + Int(bit: !count.remainder.isZero)) {
            $1 = NBK.majorLimbs(&$0, minorLimbs: minorLimbs, isSigned: isSigned)
        }
    }
    
    @inlinable static func majorLimbs<A, BE>(minorLimbs: A, isSigned: Bool, as type: ContiguousArray<BE>.Type)
    ->  ContiguousArray<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        let count = minorLimbs.count.quotientAndRemainder(dividingBy: BE.bitWidth / A.Element.bitWidth)
        return ContiguousArray(unsafeUninitializedCapacity: count.quotient + Int(bit: !count.remainder.isZero)) {
            $1 = NBK.majorLimbs(&$0, minorLimbs: minorLimbs, isSigned: isSigned)
        }
    }
    
    // TODO: trivial type de/init is req.
    @discardableResult @inlinable static func majorLimbs<A, B>(_ majorLimbs: inout B, minorLimbs: A, isSigned: Bool)
    ->  B.Index where A: Collection, A.Element: NBKCoreInteger, B: MutableCollection, B.Element: NBKCoreInteger {
        precondition(A.Element.bitWidth.isPowerOf2)
        precondition(B.Element.bitWidth.isPowerOf2)
        precondition(A.Element.bitWidth <= B.Element.bitWidth)
        //=--------------------------------------=
        var majorLimb = B.Element.zero
        var minorLimb = A.Element.Magnitude.zero
        var minorLimbsShift =  Int.zero
        var majorLimbsIndex =  majorLimbs.startIndex
        for minorLimbsIndex in minorLimbs.indices {
            minorLimb  = A.Element.Magnitude(bitPattern: minorLimbs[minorLimbsIndex])
            majorLimb |= B.Element(truncatingIfNeeded: minorLimb) &<< minorLimbsShift
            
            do{ minorLimbsShift += A.Element.bitWidth }
            if  minorLimbsShift == B.Element.bitWidth {
                majorLimbs[majorLimbsIndex] = majorLimb
                majorLimbs.formIndex(after: &majorLimbsIndex)
                majorLimb = B.Element.zero
                minorLimbsShift = Int.zero
            }
        }
        
        if !minorLimbsShift.isZero {
            let sign   = B.Element(repeating: isSigned && minorLimb.mostSignificantBit)
            majorLimb |= (sign &<< minorLimbsShift)
            majorLimbs[majorLimbsIndex] = majorLimb
            majorLimbs.formIndex(after: &majorLimbsIndex)
        }
        
        return (majorLimbsIndex) as B.Index
    }
}
