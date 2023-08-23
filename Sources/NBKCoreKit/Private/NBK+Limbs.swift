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
        case  true: return Array(MinorLimbs(majorLimbs: source))
        case false: return Array(MajorLimbs(minorLimbs: source, isSigned: isSigned)) }
    }
    
    @inlinable public static func limbs<A, BE>(_ source: A, isSigned: Bool = false, as type: ContiguousArray<BE>.Type = ContiguousArray<BE>.self)
    ->  ContiguousArray<BE> where A: Collection, A.Element: NBKCoreInteger, BE: NBKCoreInteger {
        switch A.Element.bitWidth >= BE.bitWidth {
        case  true: return ContiguousArray(MinorLimbs(majorLimbs: source))
        case false: return ContiguousArray(MajorLimbs(minorLimbs: source, isSigned: isSigned)) }
    }
    
    //*========================================================================*
    // MARK: * Minor Limbs
    //*========================================================================*
    
    @frozen @usableFromInline struct MinorLimbs<MinorLimb,  MajorLimbs>: Sequence where
    MinorLimb: NBKCoreInteger, MajorLimbs: Sequence, MajorLimbs.Element: NBKCoreInteger {
                
        @usableFromInline typealias MajorLimb = MajorLimbs.Element
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let majorLimbs: MajorLimbs
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(majorLimbs: MajorLimbs, as type: MinorLimb.Type = MinorLimb.self) {
            //=--------------------------------------=
            precondition(MinorLimb.bitWidth.isPowerOf2)
            precondition(MajorLimb.bitWidth.isPowerOf2)
            precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
            //=--------------------------------------=
            self.majorLimbs = majorLimbs
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns the exact count when `minorLimbs.underestimatedCount` does.
        @inlinable var underestimatedCount: Int {
            MajorLimb.bitWidth / MinorLimb.bitWidth * self.majorLimbs.underestimatedCount
        }
        
        @inlinable func makeIterator() -> some IteratorProtocol<MinorLimb> {
            self.majorLimbs.lazy.flatMap({ MinorLimbsSubSequence(majorLimb: $0) }).makeIterator()
        }
    }
    
    //*========================================================================*
    // MARK: * Minor Limbs Sub Sequence
    //*========================================================================*
    
    @frozen @usableFromInline struct MinorLimbsSubSequence<MinorLimb, MajorLimb>:
    Sequence where MinorLimb: NBKCoreInteger, MajorLimb: NBKCoreInteger {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let majorLimb: MajorLimb
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(majorLimb: MajorLimb, as type: MinorLimb.Type = MinorLimb.self) {
            //=--------------------------------------=
            precondition(MinorLimb.bitWidth.isPowerOf2)
            precondition(MajorLimb.bitWidth.isPowerOf2)
            precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
            //=--------------------------------------=
            self.majorLimb = majorLimb
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Returns the exact count.
        @inlinable var underestimatedCount: Int {
            MajorLimb.bitWidth / MinorLimb.bitWidth
        }
        
        @inlinable func makeIterator() -> Iterator {
            Iterator(majorLimb: self.majorLimb)
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen @usableFromInline struct Iterator: IteratorProtocol {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline let majorLimb: MajorLimb
            @usableFromInline var majorLimbShift: Int
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(majorLimb: MajorLimb) {
                self.majorLimb = majorLimb
                self.majorLimbShift = Int.zero
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable mutating func next() -> MinorLimb? {
                guard  self.majorLimbShift <   MajorLimb.bitWidth else { return nil }
                defer{ self.majorLimbShift +=  MinorLimb.bitWidth }
                return MinorLimb(truncatingIfNeeded: self.majorLimb &>> self.majorLimbShift)
            }
        }
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
