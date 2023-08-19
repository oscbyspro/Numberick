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
// MARK: * NBK x Double Width x Literals
//*============================================================================*

extension NBKDoubleWidth {
    
    //=-------------------------------------------------------------------------=
    // MARK: Details x Integer Literal Type
    //=-------------------------------------------------------------------------=
    #if SBI && swift(>=5.8)

    @inlinable public init(integerLiteral source: StaticBigInt) {
        if  let value = Self(exactlyIntegerLiteral: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable init?(exactlyIntegerLiteral source: StaticBigInt) {
        guard Self.isSigned
        ? source.bitWidth <= Self.bitWidth
        : source.bitWidth <= Self.bitWidth + 1 && source.signum() >= 0
        else { return nil }
        
        self = Self.uninitialized { value in
            for index in value.indices {
                value[unchecked: index] = source[index]
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
    
    @inlinable public init(stringLiteral source: StaticString) {
        if  let value = Self(exactlyStringLiteral: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable init?(exactlyStringLiteral source: StaticString) {
        let value: Optional<Self> = source.withUTF8Buffer { utf8 in
            let components = NBK.makeIntegerComponentsByDecodingRadix(utf8: utf8)
            let radix  = NBK.AnyRadixUIntRoot(components.radix)
            let digits = NBK.UnsafeUTF8(rebasing: components.body)
            guard  let magnitude = Magnitude(digits: digits, radix: radix) else { return nil }
            return Self(sign: components.sign, magnitude: magnitude)
        }
        
        if  let value { self = value } else { return nil }
    }
}
