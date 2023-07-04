//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Bit Vector
//*============================================================================*

/// A bit pattern.
public protocol NBKBitVector {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// The number of bits in the binary representation of this value.
    @inlinable var bitWidth: Int { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Logic
    //=------------------------------------------------------------------------=
    
    /// Returns the logical `NOT` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌───────── → ─────────┐
    /// │ operand  │ ~operand │
    /// ├───────── → ─────────┤
    /// │ 00000000 │ 11111111 │
    /// │ 11111111 │ 00000000 │
    /// └───────── → ─────────┘
    /// ```
    ///
    @inlinable static prefix func ~(operand: Self) -> Self
    
    /// Forms the logical `AND` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs & rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 00000000  │
    /// │ 11111111 │ 00000000 │ 00000000  │
    /// │ 11111111 │ 11111111 │ 11111111  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func &=(lhs: inout Self, rhs: Self)
    
    /// Returns the logical `AND` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs & rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 00000000  │
    /// │ 11111111 │ 00000000 │ 00000000  │
    /// │ 11111111 │ 11111111 │ 11111111  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func &(lhs: Self, rhs: Self) -> Self
    
    /// Forms the logical `OR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs | rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 11111111  │
    /// │ 11111111 │ 00000000 │ 11111111  │
    /// │ 11111111 │ 11111111 │ 11111111  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func |=(lhs: inout Self, rhs: Self)
    
    /// Returns the logical `OR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs | rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 11111111  │
    /// │ 11111111 │ 00000000 │ 11111111  │
    /// │ 11111111 │ 11111111 │ 11111111  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func |(lhs: Self, rhs: Self) -> Self
    
    /// Forms the logical `XOR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs ^ rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 11111111  │
    /// │ 11111111 │ 00000000 │ 11111111  │
    /// │ 11111111 │ 11111111 │ 00000000  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func ^=(lhs: inout Self, rhs: Self)
    
    /// Returns the logical `XOR` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌──────────┬───────── → ──────────┐
    /// │ lhs      │ rhs      │ lhs ^ rhs │
    /// ├──────────┼───────── → ──────────┤
    /// │ 00000000 │ 00000000 │ 00000000  │
    /// │ 00000000 │ 11111111 │ 11111111  │
    /// │ 11111111 │ 00000000 │ 11111111  │
    /// │ 11111111 │ 11111111 │ 00000000  │
    /// └──────────┴───────── → ──────────┘
    /// ```
    ///
    @inlinable static func ^(lhs: Self, rhs: Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitshiftLeft(by distance: Int)
    
    /// Performs a left shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitshiftedLeft(by distance: Int) -> Self
    
    /// Performs an un/signed right shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256(-1) │
    /// │ Int256(-1) │ Int(  1) │ Int256(-1) │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.max │ Int(254) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitshiftRight(by distance: Int)
    
    /// Performs an un/signed right shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256(-1) │
    /// │ Int256(-1) │ Int(  1) │ Int256(-1) │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.max │ Int(254) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitshiftedRight(by distance: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Rotations
    //=------------------------------------------------------------------------=
    
    /// Performs a left rotation.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 1) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitrotateLeft(by distance: Int)
    
    /// Performs a left rotation.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 1) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitrotatedLeft(by distance: Int) -> Self
    
    /// Performs a right rotation.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256.min │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitrotateRight(by distance: Int)
    
    /// Performs a right rotation.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256.min │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitrotatedRight(by distance: Int) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details where Self is Fixed-Width Integer
//=----------------------------------------------------------------------------=

extension NBKBitVector where Self: NBKFixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitshiftLeft(by distance: Int) {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        self &<<= distance
    }
    
    @inlinable public func bitshiftedLeft(by distance: Int) -> Self {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        return self &<< distance
    }
    
    @inlinable public mutating func bitshiftRight(by distance: Int) {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        self &>>= distance
    }
    
    @inlinable public func bitshiftedRight(by distance: Int) -> Self {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        return self &>> distance
    }

    //=------------------------------------------------------------------------=
    // MARK: Details x Rotations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitrotateLeft(by distance: Int) {
        self = self.bitrotatedLeft(by: distance)
    }
    
    @inlinable public func bitrotatedLeft(by distance: Int) -> Self {
        precondition(0 ..< Self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  distance.isZero { return self }
        //=--------------------------------------=
        let pushed = self &<< (distance)
        let pulled = Magnitude(bitPattern: self) &>> (Self.bitWidth &- distance)
        return pushed | Self(bitPattern: pulled)
    }
    
    @inlinable public mutating func bitrotateRight(by distance: Int) {
        self = self.bitrotatedRight(by: distance)
    }
    
    @inlinable public func bitrotatedRight(by distance: Int) -> Self {
        precondition(0 ..< Self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        if  distance.isZero { return self }
        //=--------------------------------------=
        let pulled = self &<< (Self.bitWidth &- distance)
        let pushed = Magnitude(bitPattern: self) &>> (distance)
        return Self(bitPattern: pushed) | pulled
    }
}
