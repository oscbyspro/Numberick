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
    
    //*========================================================================*
    // MARK: * Major Or Minor Limbs Sequence
    //*========================================================================*
    
    @frozen public struct MajorOrMinorLimbsSequence<Limb, Source>: Sequence where
    Limb: NBKCoreInteger, Source: Sequence, Source.Element: NBKCoreInteger {
        
        @usableFromInline typealias MinorLimbs = NBK.MinorLimbsSequence<Limb, Source>
        
        @usableFromInline typealias MajorLimbs = NBK.MajorLimbsSequence<Limb, Source>
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        // note: parallel optionals appears to be faster than a combined enum
        //=--------------------------------------------------------------------=
        
        @usableFromInline let minorLimbs: MinorLimbs?
        @usableFromInline let majorLimbs: MajorLimbs?
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ source: Source, isSigned: Bool = false) {
            if  Limb.bitWidth < Source.Element.bitWidth {
                self.minorLimbs = MinorLimbs(majorLimbs: source)
                self.majorLimbs = nil
            }   else {
                self.minorLimbs = nil
                self.majorLimbs = MajorLimbs(minorLimbs: source, isSigned: isSigned)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var underestimatedCount: Int {
            if  Limb.bitWidth < Source.Element.bitWidth {
                return self.minorLimbs!.underestimatedCount
            }   else {
                return self.majorLimbs!.underestimatedCount
            }
        }
        
        @inlinable public func makeIterator() -> Iterator {
            if  Limb.bitWidth < Source.Element.bitWidth {
                return Iterator(minorLimbs: self.minorLimbs!.makeIterator())
            }   else {
                return Iterator(majorLimbs: self.majorLimbs!.makeIterator())
            }
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen public struct Iterator: IteratorProtocol {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline var minorLimbs: MinorLimbs.Iterator?
            @usableFromInline var majorLimbs: MajorLimbs.Iterator?
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(minorLimbs: MinorLimbs.Iterator? = nil, majorLimbs: MajorLimbs.Iterator? = nil) {
                self.minorLimbs = minorLimbs
                self.majorLimbs = majorLimbs
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable public mutating func next() -> Limb? {
                if  Limb.bitWidth < Source.Element.bitWidth {
                    return self.minorLimbs!.next()
                }   else {
                    return self.majorLimbs!.next()
                }
            }
        }
    }
    
    //*========================================================================*
    // MARK: * Major Limbs Sequence
    //*========================================================================*
    
    @frozen public struct MajorLimbsSequence<MajorLimb, MinorLimbs>: Sequence
    where MajorLimb: NBKCoreInteger, MinorLimbs: Sequence,  MinorLimbs.Element: NBKCoreInteger {
        
        @usableFromInline typealias MinorLimb = MinorLimbs.Element
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let minorLimbs: MinorLimbs
        @usableFromInline let isSigned: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(minorLimbs: MinorLimbs, isSigned: Bool = false, as majorLimb: MajorLimb.Type = MajorLimb.self) {
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
        @inlinable public var underestimatedCount: Int {
            let ratio = MajorLimb.bitWidth / MinorLimb.bitWidth
            let division = minorLimbs.underestimatedCount.quotientAndRemainder(dividingBy: ratio)
            return division.quotient + Int(bit: !division.remainder.isZero)
        }
        
        @inlinable public func makeIterator() -> Iterator {
            Iterator(minorLimbs: self.minorLimbs, isSigned: self.isSigned)
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen public struct Iterator: IteratorProtocol {
            
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
            
            @inlinable public mutating func next() -> MajorLimb? {
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
    
    //*========================================================================*
    // MARK: * Minor Limbs
    //*========================================================================*
    
    @frozen public struct MinorLimbsSequence<MinorLimb, MajorLimbs>: Sequence where
    MinorLimb: NBKCoreInteger, MajorLimbs: Sequence, MajorLimbs.Element: NBKCoreInteger {
                
        public typealias MajorLimb = MajorLimbs.Element
        
        public typealias MinorLimbsSubSequence = NBK.MinorLimbsSubSequence<MinorLimb, MajorLimbs.Element>
        
        public typealias Iterator = FlattenSequence<LazyMapSequence<MajorLimbs, MinorLimbsSubSequence>>.Iterator
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let majorLimbs: MajorLimbs
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(majorLimbs: MajorLimbs, as minorLimb: MinorLimb.Type = MinorLimb.self) {
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
        
        /// Returns the exact count when `majorLimbs.underestimatedCount` does.
        @inlinable public var underestimatedCount: Int {
            MajorLimb.bitWidth / MinorLimb.bitWidth * self.majorLimbs.underestimatedCount
        }
        
        @inlinable public func makeIterator()  -> Iterator {
            // this type is not opaque because the type inferance seeems to fail otherwise :(
            self.majorLimbs.lazy.flatMap({ MinorLimbsSubSequence(majorLimb: $0) }).makeIterator()
        }
    }
    
    //*========================================================================*
    // MARK: * Minor Limbs Sub Sequence
    //*========================================================================*
    
    @frozen public struct MinorLimbsSubSequence<MinorLimb, MajorLimb>:
    Sequence where MinorLimb: NBKCoreInteger, MajorLimb: NBKCoreInteger {
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let majorLimb: MajorLimb
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(majorLimb: MajorLimb, as minorLimb: MinorLimb.Type = MinorLimb.self) {
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
        @inlinable public var underestimatedCount: Int {
            MajorLimb.bitWidth / MinorLimb.bitWidth
        }
        
        @inlinable public func makeIterator() -> Iterator {
            Iterator(majorLimb: self.majorLimb)
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen public struct Iterator: IteratorProtocol {
            
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
            
            @inlinable public mutating func next() -> MinorLimb? {
                guard  self.majorLimbShift <  MajorLimb.bitWidth else { return nil }
                defer{ self.majorLimbShift += MinorLimb.bitWidth }
                return MinorLimb(truncatingIfNeeded: self.majorLimb &>> self.majorLimbShift)
            }
        }
    }
}
