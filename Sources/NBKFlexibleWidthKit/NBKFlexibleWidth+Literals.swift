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
// MARK: * NBK x Flexible Width x Literals x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=-------------------------------------------------------------------------=
    // MARK: Details x Integer Literal Type
    //=-------------------------------------------------------------------------=
    #if SBI && swift(>=5.8)

    @inlinable public init(integerLiteral source: StaticBigInt) {
        let sourceIsLessThanZero = source.signum() == -1
        //=--------------------------------------=
        self.init(sign: Sign.plus, magnitude: Magnitude(truncatingIntegerLiteral: source))
        //=--------------------------------------=
        if  sourceIsLessThanZero {
            self.sign.toggle()
            self.magnitude.formTwosComplement()
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
    @inlinable public init(stringLiteral source: StaticString) {
        if  let value = Self(exactlyStringLiteral: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable init?(exactlyStringLiteral source: StaticString) {
        let value: Optional<Self> = source.withUTF8Buffer { utf8 in
            let components = NBK.makeIntegerComponentsByDecodingRadix(utf8: utf8)
            let radix  = NBK.AnyRadixSolution<Int>(components.radix)
            let digits = NBK.UnsafeUTF8(rebasing:  components.body )
            guard  let magnitude = Magnitude(digits: digits, radix: radix) else { return nil }
            return Self(sign: components.sign, magnitude: magnitude)
        }
        
        if  let value { self = value } else { return nil }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Literals x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=-------------------------------------------------------------------------=
    // MARK: Details x Integer Literal Type
    //=-------------------------------------------------------------------------=
    #if SBI && swift(>=5.8)

    @inlinable public init(integerLiteral source: StaticBigInt) {
        guard let value = Self(exactlyIntegerLiteral: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = value
    }
    
    @inlinable init?(exactlyIntegerLiteral source: StaticBigInt) {
        //=--------------------------------------=
        if source.signum() == -1 { return nil }
        //=--------------------------------------=
        self.init(truncatingIntegerLiteral: source)
    }
    
    @inlinable init(truncatingIntegerLiteral source: StaticBigInt) {
        self.init(storage: Storage(truncatingIntegerLiteral: source))
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
    @inlinable public init(stringLiteral source: StaticString) {
        if  let value = Self(exactlyStringLiteral: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable init?(exactlyStringLiteral source: StaticString) {
        if  let value: Self = source.withUTF8Buffer({ utf8 in
            let components = NBK.makeIntegerComponentsByDecodingRadix(utf8: utf8)
            let radix  = NBK.AnyRadixSolution<Int>(components.radix)
            let digits = NBK.UnsafeUTF8(rebasing:  components.body )
            guard  let magnitude = Magnitude(digits: digits, radix: radix) else { return nil }
            return Self(sign: components.sign, magnitude: magnitude)
        }){ self = value } else { return nil }
    }
}
