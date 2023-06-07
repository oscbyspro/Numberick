//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Bit Cast
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Reinterprets the bits of a partial value and an overflow indicator.
    @inlinable public static func bitCast<A0, B0>(_ x: PVO<A0>) -> PVO<B0> where
    A0: NBKBitPatternConvertible, B0: NBKBitPatternConvertible, A0.BitPattern == B0.BitPattern {
        PVO(partialValue: B0(bitPattern: x.partialValue), overflow: x.overflow)
    }
    
    /// Reinterprets the bits of a high and a low value.
    @inlinable public static func bitCast<A0, A1, B0, B1>(_ x: HL<A0, A1>) -> HL<B0, B1> where
    A0: NBKBitPatternConvertible, B0: NBKBitPatternConvertible, A0.BitPattern == B0.BitPattern,
    A1: NBKBitPatternConvertible, B1: NBKBitPatternConvertible, A1.BitPattern == B1.BitPattern {
        HL(high: B0(bitPattern: x.high), low: B1(bitPattern: x.low))
    }
    
    /// Reinterprets the bits of a quotient and a remainder, relating to division.
    @inlinable public static func bitCast<A0, A1, B0, B1>(_ x: QR<A0, A1>) -> QR<B0, B1> where
    A0: NBKBitPatternConvertible, B0: NBKBitPatternConvertible, A0.BitPattern == B0.BitPattern,
    A1: NBKBitPatternConvertible, B1: NBKBitPatternConvertible, A1.BitPattern == B1.BitPattern {
        QR(quotient: B0(bitPattern: x.quotient), remainder: B1(bitPattern: x.remainder))
    }
    
    /// Reinterprets the bits of a partial value and an overflow indicator.
    @inlinable public static func bitCast<A0, A1, B0, B1>(_ x: PVO<QR<A0, A1>>) -> PVO<QR<B0, B1>> where
    A0: NBKBitPatternConvertible, B0: NBKBitPatternConvertible, A0.BitPattern == B0.BitPattern,
    A1: NBKBitPatternConvertible, B1: NBKBitPatternConvertible, A1.BitPattern == B1.BitPattern {
        PVO(partialValue: NBK.bitCast(x.partialValue), overflow: x.overflow)
    }
}
