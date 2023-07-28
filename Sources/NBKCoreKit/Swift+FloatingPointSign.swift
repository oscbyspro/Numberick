//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Swift x Floating Point Sign
//*============================================================================*

extension Swift.FloatingPointSign {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `bit`.
    ///
    /// ```
    /// ┌────── → ──────────┐
    /// │ bit   │ sign      │
    /// ├────── → ───── = ──┤
    /// │ false │ plus  │ 0 │
    /// │ true  │ minus │ 1 │
    /// └────── → ───── = ──┘
    /// ```
    ///
    @_transparent public init(_ bit: Bool) {
        self = Swift.unsafeBitCast(bit, to: Self.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The `bit` representation of this value.
    ///
    /// ```
    /// ┌────────── → ──────┐
    /// │ sign      │ bit   │
    /// ├────── = ─ → ──────┤
    /// │ plus  │ 0 │ false │
    /// │ minus │ 1 │ true  │
    /// └────── = ─ → ──────┘
    /// ```
    ///
    @_transparent public var bit: Bool {
        Swift.unsafeBitCast(self, to: Bool.self)
    }
    
    /// The `data` representation of this value.
    ///
    /// ```
    /// ┌────────── → ─────────┐
    /// │ sign      │ data     │
    /// ├────── = ─ → ─────────┤
    /// │ plus  │ 0 │ UInt8(0) │
    /// │ minus │ 1 │ UInt8(1) │
    /// └────── = ─ → ─────────┘
    /// ```
    ///
    @_transparent @usableFromInline var data: UInt8 {
        Swift.unsafeBitCast(self, to: UInt8.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the opposite `sign`.
    ///
    /// ```
    /// ┌────────── → ──────────┐
    /// │ sign      │ sign      │
    /// ├────── = ─ → ───── = ──┤
    /// │ plus  │ 0 │ minus │ 1 │
    /// │ minus │ 1 │ plus  │ 0 │
    /// └────── = ─ → ───── = ──┘
    /// ```
    ///
    @_transparent public mutating func toggle() {
        self = ~self
    }
    
    /// Returns the opposite `sign`.
    ///
    /// ```
    /// ┌────────── → ──────────┐
    /// │ sign      │ sign      │
    /// ├────── = ─ → ───── = ──┤
    /// │ plus  │ 0 │ minus │ 1 │
    /// │ minus │ 1 │ plus  │ 0 │
    /// └────── = ─ → ───── = ──┘
    /// ```
    ///
    @_transparent public func toggled() -> Self {
        ~self
    }
    
    /// Returns the opposite `sign` of this value.
    ///
    /// ```
    /// ┌────────── → ──────────┐
    /// │ sign      │ sign      │
    /// ├────── = ─ → ───── = ──┤
    /// │ plus  │ 0 │ minus │ 1 │
    /// │ minus │ 1 │ plus  │ 0 │
    /// └────── = ─ → ───── = ──┘
    /// ```
    ///
    @_transparent public static prefix func ~(sign: Self) -> Self {
        sign ^ minus
    }
    
    /// Forms the logical `AND` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs AND rhs │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ plus  │ 0   │
    /// │ minus │ 1 │ plus  │ 0 │ plus  │ 0   │
    /// │ minus │ 1 │ minus │ 1 │ minus │ 1   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func &=(lhs: inout Self, rhs: Self) {
        lhs = lhs & rhs
    }
    
    /// Returns the logical `AND` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs AND rhs │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ plus  │ 0   │
    /// │ minus │ 1 │ plus  │ 0 │ plus  │ 0   │
    /// │ minus │ 1 │ minus │ 1 │ minus │ 1   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func &(lhs: Self, rhs: Self) -> Self {
        Swift.unsafeBitCast(lhs.data & rhs.data, to: Self.self)
    }
    
    /// Forms the logical `OR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs OR rhs  │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ minus │ 1   │
    /// │ minus │ 1 │ plus  │ 0 │ minus │ 1   │
    /// │ minus │ 1 │ minus │ 1 │ minus │ 1   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func |=(lhs: inout Self, rhs: Self) {
        lhs = lhs | rhs
    }
    
    /// Returns the logical `OR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs OR rhs  │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ minus │ 1   │
    /// │ minus │ 1 │ plus  │ 0 │ minus │ 1   │
    /// │ minus │ 1 │ minus │ 1 │ minus │ 1   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func |(lhs: Self, rhs: Self) -> Self {
        Swift.unsafeBitCast(lhs.data | rhs.data, to: Self.self)
    }
    
    /// Forms the logical `XOR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs XOR rhs │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ minus │ 1   │
    /// │ minus │ 1 │ plus  │ 0 │ minus │ 1   │
    /// │ minus │ 1 │ minus │ 1 │ plus  │ 0   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func ^=(lhs: inout Self, rhs: Self) {
        lhs = lhs ^ rhs
    }
    
    /// Returns the logical `XOR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────────────── → ────────────┐
    /// │ lhs       │ rhs       │ lhs XOR rhs │
    /// ├────── = ──┼────── = ─ → ───── = ────┤
    /// │ plus  │ 0 │ plus  │ 0 │ plus  │ 0   │
    /// │ plus  │ 0 │ minus │ 1 │ minus │ 1   │
    /// │ minus │ 1 │ plus  │ 0 │ minus │ 1   │
    /// │ minus │ 1 │ minus │ 1 │ plus  │ 0   │
    /// └────── = ─ → ────── = ─ → ──── = ────┘
    /// ```
    ///
    @_transparent public static func ^(lhs: Self, rhs: Self) -> Self {
        Swift.unsafeBitCast(lhs.data ^ rhs.data, to: Self.self)
    }
}
