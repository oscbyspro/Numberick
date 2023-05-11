//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Bit Pattern Convertible
//*============================================================================*

/// A type that can be converted to and from a bit pattern representation.
///
/// ``init(bitPattern:)`` is a type-safe alternative to `unsafeBitCast(_:to:)`.
///
public protocol NBKBitPatternConvertible<BitPattern> {
    
    /// The bit pattern of this type.
    ///
    /// Types with compatible bit patterns should have the same bit pattern type.
    ///
    associatedtype BitPattern: NBKBitPatternConvertible<BitPattern> & Sendable
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit pattern.
    ///
    /// ```swift
    /// Int8(bitPattern: UInt8(255)) // Int8(-1)
    /// Int8(bitPattern: UInt8(254)) // Int8(-2)
    /// Int8(bitPattern: UInt8(253)) // Int8(-3)
    /// ```
    ///
    @inlinable init(bitPattern source: some NBKBitPatternConvertible<BitPattern>)
    
    /// The bit pattern of this value.
    ///
    /// ```swift
    /// Int8(-1).bitPattern // UInt8(255)
    /// Int8(-2).bitPattern // UInt8(254)
    /// Int8(-3).bitPattern // UInt8(253)
    /// ```
    ///
    @inlinable var bitPattern: BitPattern { get }
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Bit Pattern is Self
//=----------------------------------------------------------------------------=

extension NBKBitPatternConvertible where BitPattern == Self {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit pattern.
    ///
    /// ```swift
    /// Int8(bitPattern: UInt8(255)) // Int8(-1)
    /// Int8(bitPattern: UInt8(254)) // Int8(-2)
    /// Int8(bitPattern: UInt8(253)) // Int8(-3)
    /// ```
    ///
    @inlinable public init(bitPattern source: some NBKBitPatternConvertible<BitPattern>) {
        self = source.bitPattern
    }
    
    /// The bit pattern of this value.
    ///
    /// ```swift
    /// Int8(-1).bitPattern // UInt8(255)
    /// Int8(-2).bitPattern // UInt8(254)
    /// Int8(-3).bitPattern // UInt8(253)
    /// ```
    ///
    @inlinable public var bitPattern: BitPattern {
        self
    }
}
