//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

// TODO: Use input to output parameter order?
//*============================================================================*
// MARK: * NBK x Major Or Minor Integer Limbs
//*============================================================================*

/// A sequence that merges or splits another sequence of un/signed integer limbs.
///
/// ### Binary Integer Order
///
/// This sequence is binary integer ordered, so it merges or splits limbs
/// from least to most significant. You can reorder it by reversing the input,
/// the output, or both.
///
@frozen public struct NBKMajorOrMinorIntegerLimbs<Limb, Source>: Sequence where
Limb: NBKCoreInteger, Source: Sequence, Source.Element: NBKCoreInteger {
    
    public typealias Source = Source
    
    // TODO: with public models
    public typealias MajorLimbs = NBK.MajorLimbsSequence<Limb, Source>
    
    // TODO: with public models
    public typealias MinorLimbs = NBK.MinorLimbsSequence<Limb, Source>
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    // NOTE: Two parallel options appear to be faster than a combined enum.
    //=--------------------------------------------------------------------=
    
    @usableFromInline let minorLimbs: MinorLimbs?
    @usableFromInline let majorLimbs: MajorLimbs?
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    /// Creates a sequence of the given type, from an un/signed source.
    @inlinable public init(_ source: Source, isSigned: Bool = false, as limb: Limb.Type = Limb.self) {
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
