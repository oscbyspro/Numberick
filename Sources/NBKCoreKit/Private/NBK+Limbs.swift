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
        case false: return Array(MajorLimbs(minorLimbs: source, isSigned: isSigned, as: BE.self)) }
    }
    
    @inlinable public static func limbs<A, BE>(_ source: A, isSigned: Bool = false, as type: ContiguousArray<BE>.Type = ContiguousArray<BE>.self)
    ->  ContiguousArray<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        switch A.Element.bitWidth >= BE.bitWidth {
        case  true: return NBK.minorLimbs(majorLimbs: source, isSigned: isSigned, as: type)
        case false: return ContiguousArray(MajorLimbs(minorLimbs: source, isSigned: isSigned, as: BE.self)) }
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
    
    //*========================================================================*
    // MARK: * Major Limbs
    //*========================================================================*
    
    @frozen @usableFromInline struct MajorLimbs<MajorLimb,  MinorLimbs>: Sequence where
    MajorLimb: NBKCoreInteger, MinorLimbs: Sequence, MinorLimbs.Element: NBKCoreInteger {
        
        @usableFromInline typealias MinorLimb = MinorLimbs.Element
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let minorLimbs: MinorLimbs
        @usableFromInline let isSigned: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(minorLimbs: MinorLimbs, isSigned: Bool, as type: MajorLimb.Type = MajorLimb.self) {
            //=--------------------------------------=
            precondition(MinorLimb.bitWidth.isPowerOf2)
            precondition(MajorLimb.bitWidth.isPowerOf2)
            precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
            //=--------------------------------------=
            self.isSigned   = isSigned
            self.minorLimbs = minorLimbs
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns the exact count when `minorLimbs.underestimatedCount` does.
        @inlinable var underestimatedCount: Int {
            let ratio = MajorLimb.bitWidth / MinorLimb.bitWidth
            let division = minorLimbs.underestimatedCount.quotientAndRemainder(dividingBy: ratio)
            return division.quotient + Int(bit: !division.remainder.isZero)
        }
        
        @inlinable func makeIterator() -> Iterator {
            Iterator(minorLimbs: self.minorLimbs, isSigned: self.isSigned)
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen @usableFromInline struct Iterator: IteratorProtocol {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline var minorLimbs: MinorLimbs.Iterator
            @usableFromInline let isSigned: Bool
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(minorLimbs: MinorLimbs, isSigned: Bool) {
                self.isSigned = isSigned
                self.minorLimbs = minorLimbs.makeIterator()
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable mutating func next() -> MajorLimb? {
                var majorLimb = MajorLimb.zero
                var minorLimb = MinorLimb.Magnitude.zero
                var minorLimbsShift = Int.zero
                
                while let next = self.minorLimbs.next() {
                    minorLimb  = MinorLimb.Magnitude(bitPattern: next)
                    majorLimb |= MajorLimb(truncatingIfNeeded: minorLimb) &<< minorLimbsShift
                    
                    do{ minorLimbsShift += MinorLimb.bitWidth }
                    if  minorLimbsShift == MajorLimb.bitWidth {
                        return majorLimb
                    }
                }
                
                guard !minorLimbsShift.isZero else { return nil }
                majorLimb |= (MajorLimb(repeating: self.isSigned && minorLimb.mostSignificantBit) &<< minorLimbsShift)
                return majorLimb as MajorLimb
            }
        }
    }
}
