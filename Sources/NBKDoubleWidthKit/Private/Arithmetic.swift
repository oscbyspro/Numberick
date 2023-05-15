//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Arithmetic x Int
//*============================================================================*

extension Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal func dividedByBitWidth() -> QR<Self, Self> {
        QR(self &>> Self.bitWidth.trailingZeroBitCount, self & (Self.bitWidth &- 1))
    }
}

//*============================================================================*
// MARK: * NBK x Arithmetic x UInt
//*============================================================================*

extension UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sum of adding both values to this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: UInt = ~0; a.addReportingOverflow( 0, false) // a = ~0; -> false
    /// var b: UInt = ~0; a.addReportingOverflow( 0, true ) // b =  0; -> true
    /// var c: UInt = ~0; c.addReportingOverflow(~0, false) // c = ~1; -> true
    /// var d: UInt = ~0; d.addReportingOverflow(~0, true ) // d = ~0; -> true
    /// ```
    ///
    /// - Returns: A truncated value in the range: `(high: 0, low: 0) ... (high: 1, low: ~0)`.
    ///
    @inlinable internal mutating func addReportingOverflow(_ amount: Self, _ bit: Bool) -> Bool {
        let a: Bool = self.addReportingOverflow(amount)
        let b: Bool = self.addReportingOverflow(Self(bit: bit))
        return a || b
    }
    
    /// Returns the sum of adding both values to this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// (~0 as UInt).addingReportingOverflow( 0, false) // (partialValue: ~0, overflow: false)
    /// (~0 as UInt).addingReportingOverflow( 0, true ) // (partialValue:  0, overflow: true )
    /// (~0 as UInt).addingReportingOverflow(~0, false) // (partialValue: ~1, overflow: true )
    /// (~0 as UInt).addingReportingOverflow(~0, true ) // (partialValue: ~0, overflow: true )
    /// ```
    ///
    /// - Returns: A truncated value in the range: `(high: 0, low: 0) ... (high: 1, low: ~0)`.
    ///
    @inlinable internal func addingReportingOverflow(_ amount: Self, _ bit: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.addReportingOverflow(amount, bit)
        return PVO(partialValue, overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sum of adding the product of the multiplicands to this value.
    ///
    /// ```swift
    /// var a: UInt = ~0; a.addFullWidth(multiplicands:( 2,  3)) // a = 5; ->  1
    /// var b: UInt = ~0; b.addFullWidth(multiplicands:(~0, ~0)) // b = 0; -> ~0
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: ~0, low: 0)`.
    ///
    @inlinable mutating func addFullWidth(multiplicands: (Self, Self)) -> Self {
        let product = multiplicands.0.multipliedFullWidth(by: multiplicands.1)
        return Self(bit: self.addReportingOverflow(product.low)) &+ product.high
    }
    
    /// Returns the sum of adding the product of the multiplicands to this value.
    ///
    /// ```swift
    /// (~0 as UInt).addingFullWidth(multiplicands:( 2,  3)) // (high:  1, low: 5)
    /// (~0 as UInt).addingFullWidth(multiplicands:(~0, ~0)) // (high: ~0, low: 0)
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: ~0, low: 0)`.
    ///
    @inlinable internal func addingFullWidth(multiplicands: (Self, Self)) -> HL<Self, Magnitude> {
        var low = self
        let high: Self = low.addFullWidth(multiplicands: multiplicands)
        return HL(high,  low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sum of adding the addend and product of the multiplicands to this value.
    ///
    /// ```swift
    /// var a: UInt = ~0; a.addFullWidth( 1, multiplicands:( 2,  3)) // a =  6; ->  1
    /// var b: UInt = ~0; b.addFullWidth(~0, multiplicands:(~0, ~0)) // b = ~0; -> ~0
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: ~0, low: ~0)`.
    ///
    @inlinable internal mutating func addFullWidth(_ addend: Self, multiplicands: (Self, Self)) -> Self {
        let high: Self = self.addFullWidth(multiplicands: multiplicands)
        return Self(bit: self.addReportingOverflow(addend)) &+ high
    }
    
    /// Returns the sum of adding the addend and product of the multiplicands to this value.
    ///
    /// ```swift
    /// (~0 as UInt).addingFullWidth( 1, multiplicands:( 2,  3)) // (high:  1, low:  6)
    /// (~0 as UInt).addingFullWidth(~0, multiplicands:(~0, ~0)) // (high: ~0, low: ~0)
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: ~0, low: ~0)`.
    ///
    @inlinable internal func addingFullWidth(_ addend: Self, multiplicands: (Self, Self)) -> HL<Self, Magnitude> {
        var low = self
        let high: Self = low.addFullWidth(addend, multiplicands: multiplicands)
        return HL(high,  low)
    }
}

//*============================================================================*
// MARK: * NBK x Arithmetic x Fixed Width x Unsigned
//*============================================================================*

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the sum of given values.
    ///
    /// ```swift
    /// UInt.sum(~0,  1,  2) // (high: 1, low:  2)
    /// UInt.sum(~0, ~0, ~0) // (high: 2, low: ~2)
    /// ```
    ///
    /// - Returns: A value in the range: `(high: 0, low: 0) ... (high: 2, low: ~2)`.
    ///
    @inlinable internal static func sum(_ x0: Self, _ x1: Self, _ x2: Self) -> HL<UInt, Self> {
        var xx = x0
        let o3 = xx.addReportingOverflow(x1)
        let o4 = xx.addReportingOverflow(x2)
        return HL(UInt(bit: o3) &+ UInt(bit: o4), xx)
    }
}
