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

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `sign`'s ascii representation.
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
    @inlinable public static func ascii(_ sign: Sign) -> UInt8 {
        UInt8(ascii: sign == Sign.plus ? "+" : "-")
    }
    
    /// Returns the `sign`'s bit representation.
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
    @inlinable public static func bit(_ sign: Sign) -> Bool {
        sign == Sign.plus ? false : true
    }
    
    /// Returns the `bit`'s sign representation.
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
    @inlinable public static func sign(_ bit: Bool) -> Sign {
        bit ? Sign.minus : Sign.plus
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the opposite `sign`.
    ///
    /// ```
    /// ┌────────── → ──────────┐
    /// │ sign      │ NOT sign  │
    /// ├────── = ─ → ───── = ──┤
    /// │ plus  │ 0 │ minus │ 1 │
    /// │ minus │ 1 │ plus  │ 0 │
    /// └────── = ─ → ───── = ──┘
    /// ```
    ///
    @inlinable public static func not(_ sign: Sign) -> Sign {
        self.xor(sign, Sign.minus)
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
    /// └────── = ─ → ───── = ─ → ───── = ────┘
    /// ```
    ///
    @inlinable public static func and(_ lhs: Sign, _ rhs: Sign) -> Sign {
        lhs == rhs ? lhs : Sign.plus
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
    /// └────── = ─ → ───── = ─ → ───── = ────┘
    /// ```
    ///
    @inlinable public static func or(_ lhs: Sign, _ rhs: Sign) -> Sign {
        lhs == Sign.plus ? rhs : lhs
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
    /// └────── = ─ → ───── = ─ → ───── = ────┘
    /// ```
    ///
    @inlinable public static func xor(_ lhs: Sign, _ rhs: Sign) -> Sign {
        lhs == rhs ? Sign.plus : Sign.minus
    }
}
