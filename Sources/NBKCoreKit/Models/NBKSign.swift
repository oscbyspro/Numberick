//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Sign
//*============================================================================*

/// The sign of a numeric value.
@frozen public enum NBKSign: CustomStringConvertible, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The sign of a positive value.
    case plus
    
    /// The sign of a negative value.
    case minus
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit.
    @_transparent public init(_ bit: Bool) {
        self = unsafeBitCast(bit, to: Self.self)
    }
    
    /// Creates a new instance from the given sign.
    @_transparent public init(_ sign: FloatingPointSign) {
        self = unsafeBitCast(sign, to: Self.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The bit representation of this value.
    ///
    /// ```swift
    /// plus .bit // false
    /// minus.bit // true
    /// ```
    ///
    @_transparent public var bit: Bool {
        unsafeBitCast(self, to: Bool.self)
    }
    
    /// The in-memory representation of this value.
    ///
    /// ```swift
    /// plus .data // 0x00
    /// minus.data // 0x01
    /// ```
    ///
    @_transparent @usableFromInline var data: UInt8 {
        unsafeBitCast(self, to: UInt8.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the opposite sign.
    ///
    /// Use this method to toggle from ``NBKSign/plus`` to ``NBKSign/minus`` or from ``NBKSign/minus`` to ``NBKSign/plus``.
    ///
    @_transparent public mutating func toggle() {
        self = ~self
    }
    
    /// Returns the opposite sign.
    ///
    /// Use this method to toggle from ``NBKSign/plus`` to ``NBKSign/minus`` or from ``NBKSign/minus`` to ``NBKSign/plus``.
    ///
    @_transparent public func toggled() -> Self {
        ~self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @_transparent public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.data == rhs.data
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// The description of this value.
    ///
    /// ```swift
    /// plus .description // "+"
    /// minus.description // "-"
    /// ```
    ///
    @_transparent public var description: String {
        self.bit ? "-" : "+"
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Bitwise
//=----------------------------------------------------------------------------=

extension NBKSign {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the opposite sign.
    ///
    /// Use this method to toggle from ``NBKSign/plus`` to ``NBKSign/minus`` or from ``NBKSign/minus`` to ``NBKSign/plus``.
    ///
    @_transparent public static prefix func ~(x: Self) -> Self {
        x ^ minus
    }
    
    /// Forms ``NBKSign/minus`` if both signs are ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  & plus  // plus
    /// plus  & minus // plus
    /// minus & plus  // plus
    /// minus & minus // minus
    /// ```
    ///
    @_transparent public static func &=(lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
    
    /// Returns ``NBKSign/minus`` if both signs are ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  & plus  // plus
    /// plus  & minus // plus
    /// minus & plus  // plus
    /// minus & minus // minus
    /// ```
    ///
    @_transparent public static func &(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(lhs.data & rhs.data, to: Self.self)
    }
    
    /// Forms ``NBKSign/minus`` if at least one sign is ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  | plus  // plus
    /// plus  | minus // minus
    /// minus | plus  // minus
    /// minus | minus // minus
    /// ```
    ///
    @_transparent public static func |=(lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    /// Returns ``NBKSign/minus`` if at least one sign is ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  | plus  // plus
    /// plus  | minus // minus
    /// minus | plus  // minus
    /// minus | minus // minus
    /// ```
    ///
    @_transparent public static func |(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(lhs.data | rhs.data, to: Self.self)
    }
    
    /// Forms ``NBKSign/minus`` if exactly one sign is ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  ^ plus  // plus
    /// plus  ^ minus // minus
    /// minus ^ plus  // minus
    /// minus ^ minus // plus
    /// ```
    ///
    @_transparent public static func ^=(lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
    
    /// Returns ``NBKSign/minus`` if exactly one sign is ``NBKSign/minus``, and ``NBKSign/plus`` otherwise.
    ///
    /// ```swift
    /// plus  ^ plus  // plus
    /// plus  ^ minus // minus
    /// minus ^ plus  // minus
    /// minus ^ minus // plus
    /// ```
    ///
    @_transparent public static func ^(lhs: Self, rhs: Self) -> Self {
        unsafeBitCast(lhs.data ^ rhs.data, to: Self.self)
    }
}
