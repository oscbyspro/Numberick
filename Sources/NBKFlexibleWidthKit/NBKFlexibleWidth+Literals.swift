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
// MARK: * NBK x Flexible Width x Literals x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=-------------------------------------------------------------------------=
    // MARK: Details x Integer Literal Type
    //=-------------------------------------------------------------------------=
    #if SBI && swift(>=5.8)

    @inlinable public init(integerLiteral source: StaticBigInt) {
        if  let value = Self(exactlyIntegerLiteral: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    /// - Warning: This method is only public for RELEASE mode testing.
    @inlinable public init?(exactlyIntegerLiteral source: StaticBigInt) {
        guard  Self.isSigned || source.signum() >= 0 as Int else { return nil }
        //=--------------------------------------=
        let width = Swift.max(1, source.bitWidth - Int(bit: !Self.isSigned))
        let major = NBK.PBI .quotient(dividing: NBK.ZeroOrMore(unchecked: width), by: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(unchecked: width), by: NBK.PowerOf2(bitWidth: UInt.self))
        let count = major &+ Int(bit: minor.isMoreThanZero)
        //=--------------------------------------=
        self = Self.uninitialized(count: count) { words in
            for index in words.indices {
                words.baseAddress!.advanced(by: index).initialize(to: source[index])
            }
        }
    }
    
    #else
    
    @inlinable public init(integerLiteral source: Digit.IntegerLiteralType) {
        self.init(digit: Digit(integerLiteral: source))
    }
    
    #endif
    //=------------------------------------------------------------------------=
    // MARK: Details x String Literal Type
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given string literal.
    ///
    /// The string literal may contain a plus or minus sign (+ or -), followed by
    /// an optional radix indicator (0b, 0o or 0x), then one or more numeric digits
    /// (0-9) or letters (a-z or A-Z). If the string literal uses an invalid format,
    /// or its value cannot be represented, a runtime error may occur.
    ///
    /// ```
    /// ┌───────── → ─────────────┐
    /// │ literal  │ self         │
    /// ├───────── → ─────────────┤
    /// │    "123" │ Int256( 123) │
    /// │ "+0x123" │ Int256( 291) │
    /// │ "-0x123" │ Int256(-291) │
    /// │ "~OX123" │ error        │
    /// └───────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @inlinable public init(stringLiteral description: StaticString) {
        if  let value = Self(exactlyStringLiteral: description) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(description)")
        }
    }
    
    /// - Warning: This method is only public for RELEASE mode testing.
    @inlinable public init?(exactlyStringLiteral description: StaticString) {
        let decoder = NBK.IntegerDescription.DecoderDecodingRadix<Magnitude>()
        guard let components: SM<Magnitude> = decoder.decode(description) else { return nil }
        self.init(sign: components.sign, magnitude: components.magnitude)
    }
}
