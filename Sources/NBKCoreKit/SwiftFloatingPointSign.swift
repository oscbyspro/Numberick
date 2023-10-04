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
    @inlinable public init(bit: Bool) {
        self = bit ? Self.minus : Self.plus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The `ascii` representation of this value.
    ///
    /// ```
    /// ┌────────── → ─────────────┐
    /// │ sign      │ ascii        │
    /// ├────── = ─ → ────── = ────┤
    /// │ plus  │ 0 │ 43     │ "+" │
    /// │ minus │ 1 │ 45     │ "-" │
    /// └────── = ─ → ────── = ────┘
    /// ```
    ///
    @inlinable public var ascii: UInt8 {
        UInt8(ascii: self == Self.plus ? "+" : "-")
    }
    
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
    @inlinable public var bit: Bool {
        self == Self.plus ? false : true
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
    @inlinable public mutating func toggle() {
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
    @inlinable public func toggled() -> Self {
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
    @inlinable public static prefix func ~(sign: Self) -> Self {
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
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
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
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? lhs : Self.plus
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
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
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
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        lhs == Self.plus ? rhs : lhs
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
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
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
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        lhs == rhs ? Self.plus : Self.minus
    }
}
