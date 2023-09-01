//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Major Or Minor Integer
//*============================================================================*

/// A sequence that merges or splits components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorOrMinorInteger<Limb, Source>: Sequence where
Limb: NBKCoreInteger, Source: Sequence, Source.Element: NBKCoreInteger {
    
    public typealias Source = Source
    
    public typealias MajorLimbs = NBKMajorInteger<Limb, Source>
    
    public typealias MinorLimbs = NBKMinorInteger<Limb, Source>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    // NOTE: Two parallel options appear to be faster than a combined enum.
    //=------------------------------------------------------------------------=
    
    @usableFromInline let minorLimbs: MinorLimbs?
    @usableFromInline let majorLimbs: MajorLimbs?
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type, from an un/signed source.
    @inlinable public init(_ source: Source, isSigned: Bool = false, as limb: Limb.Type = Limb.self) {
        if  Limb.bitWidth < Source.Element.bitWidth {
            self.minorLimbs = MinorLimbs(source)
            self.majorLimbs = nil
        }   else {
            self.minorLimbs = nil
            self.majorLimbs = MajorLimbs(source, isSigned: isSigned)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
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
    
    // TODO: documentation
    @frozen public struct Iterator: IteratorProtocol {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline var minorLimbs: MinorLimbs.Iterator?
        @usableFromInline var majorLimbs: MajorLimbs.Iterator?
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(minorLimbs: MinorLimbs.Iterator? = nil, majorLimbs: MajorLimbs.Iterator? = nil) {
            self.minorLimbs = minorLimbs
            self.majorLimbs = majorLimbs
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Limb? {
            if  Limb.bitWidth < Source.Element.bitWidth {
                return self.minorLimbs!.next()
            }   else {
                return self.majorLimbs!.next()
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Major Integer
//*============================================================================*

/// A sequence that merges components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorInteger<MajorLimb, MinorLimbs>: Sequence where
MajorLimb: NBKCoreInteger, MinorLimbs: Sequence, MinorLimbs.Element: NBKCoreInteger {
    
    public typealias MajorLimb = MajorLimb
            
    public typealias MinorLimb = MinorLimbs.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let minorLimbs: MinorLimbs
    @usableFromInline let minorLimbsIsSigned: Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public init(_ minorLimbs: MinorLimbs, isSigned: Bool = false, as majorLimb: MajorLimb.Type = MajorLimb.self) {
        //=--------------------------------------=
        precondition(MinorLimb.bitWidth.isPowerOf2)
        precondition(MajorLimb.bitWidth.isPowerOf2)
        precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
        //=--------------------------------------=
        self.minorLimbs = minorLimbs
        self.minorLimbsIsSigned = isSigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the exact count when `minorLimbs.underestimatedCount` does.
    @inlinable public var underestimatedCount: Int {
        let ratio = MajorLimb.bitWidth / MinorLimb.bitWidth
        let division = minorLimbs.underestimatedCount.quotientAndRemainder(dividingBy: ratio)
        return division.quotient + Int(bit: !division.remainder.isZero)
    }
    
    @inlinable public func makeIterator() ->  Iterator  {
        Iterator(self.minorLimbs.makeIterator(), isSigned: self.minorLimbsIsSigned)
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    // TODO: documentation
    @frozen public struct Iterator: IteratorProtocol {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline var minorLimbs: MinorLimbs.Iterator
        @usableFromInline let minorLimbsIsSigned: Bool
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ minorLimbs: MinorLimbs.Iterator, isSigned: Bool) {
            self.minorLimbs = minorLimbs
            self.minorLimbsIsSigned = isSigned
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> MajorLimb? {
            var majorLimb = MajorLimb.zero
            var majorLimbShift = 0 as Int
            var minorLimb = MinorLimb.Magnitude.zero
            
            while let next = self.minorLimbs.next() {
                minorLimb  = MinorLimb.Magnitude(bitPattern: next)
                majorLimb |= MajorLimb(truncatingIfNeeded: minorLimb) &<< majorLimbShift
                
                do {  majorLimbShift += MinorLimb.bitWidth }
                guard majorLimbShift <  MajorLimb.bitWidth else { return  majorLimb }
            }
            
            guard !majorLimbShift.isZero else { return nil }
            let bit: Bool = self.minorLimbsIsSigned && minorLimb.mostSignificantBit
            return majorLimb | MajorLimb(repeating: bit) &<< majorLimbShift
        }
    }
}

//*============================================================================*
// MARK: * NBK x Minor Integer
//*============================================================================*

/// A sequence that splits components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMinorInteger<MinorLimb, MajorLimbs>: Sequence where
MinorLimb: NBKCoreInteger, MajorLimbs: Sequence, MajorLimbs.Element: NBKCoreInteger {
    
    public typealias MajorLimb = MajorLimbs.Element
    
    public typealias MinorLimb = MinorLimb
    
    @usableFromInline typealias MinorLimbsOfOne = NBKMinorIntegerOfOne<MinorLimb, MajorLimb>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let majorLimbs: MajorLimbs
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public init(_ majorLimbs: MajorLimbs, as minorLimb: MinorLimb.Type = MinorLimb.self) {
        //=--------------------------------------=
        precondition(MinorLimb.bitWidth.isPowerOf2)
        precondition(MajorLimb.bitWidth.isPowerOf2)
        precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
        //=--------------------------------------=
        self.majorLimbs = majorLimbs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the exact count when `majorLimbs.underestimatedCount` does.
    @inlinable public var underestimatedCount: Int {
        MajorLimb.bitWidth / MinorLimb.bitWidth * self.majorLimbs.underestimatedCount
    }
    
    @inlinable public func makeIterator() -> Iterator {
        Iterator(self.majorLimbs.makeIterator())
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    // TODO: documentation
    @frozen public struct Iterator: IteratorProtocol {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline var majorLimbs: MajorLimbs.Iterator
        @usableFromInline var minorLimbs: MinorLimbsOfOne.Iterator?
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ majorLimbs: MajorLimbs.Iterator) {
            self.majorLimbs = majorLimbs
            self.minorLimbs = nil
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable mutating public func next() -> MinorLimb? {
            repeat {
                                    
                if  let minorLimb = self.minorLimbs?.next() {
                    return minorLimb
                }   else if let majorLimb = self.majorLimbs.next() {
                    self.minorLimbs = MinorLimbsOfOne(majorLimb).makeIterator()
                }   else {
                    return nil
                }
                
            } while true
        }
    }
}

//*============================================================================*
// MARK: * NBK x Minor Integer Of One
//*============================================================================*

/// A sequence that splits components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMinorIntegerOfOne<MinorLimb, MajorLimb>:
Sequence where MinorLimb: NBKCoreInteger, MajorLimb: NBKCoreInteger {
    
    public typealias MajorLimb = MajorLimb
    
    public typealias MinorLimb = MinorLimb
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let majorLimb: MajorLimb
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public init(_ majorLimb: MajorLimb, as minorLimb: MinorLimb.Type = MinorLimb.self) {
        //=--------------------------------------=
        precondition(MinorLimb.bitWidth.isPowerOf2)
        precondition(MajorLimb.bitWidth.isPowerOf2)
        precondition(MinorLimb.bitWidth <= MajorLimb.bitWidth)
        //=--------------------------------------=
        self.majorLimb = majorLimb
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the exact count.
    @inlinable public var underestimatedCount: Int {
        MajorLimb.bitWidth / MinorLimb.bitWidth
    }
    
    @inlinable public func makeIterator() -> Iterator {
        Iterator(self.majorLimb)
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    // TODO: documentation
    @frozen public struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let majorLimb: MajorLimb
        @usableFromInline var majorLimbShift: Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ majorLimb: MajorLimb) {
            self.majorLimb = majorLimb
            self.majorLimbShift = 0 as Int
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> MinorLimb? {
            guard  self.majorLimbShift <  MajorLimb.bitWidth else { return nil }
            defer{ self.majorLimbShift += MinorLimb.bitWidth }
            return MinorLimb(truncatingIfNeeded: self.majorLimb &>> self.majorLimbShift)
        }
    }
}
