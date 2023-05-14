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
// MARK: * NBK x Double Width x Numbers
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        Self(descending: HL(High.min, Low.min))
    }
    
    @inlinable public static var max: Self {
        Self(descending: HL(High.max, Low.max))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: Digit) {
        let bit  = digit.isLessThanZero
        let high = High(repeating: bit)
        let low  = Low(truncatingIfNeeded: digit)
        self.init(descending: HL(high, low))
    }
    
    @inlinable public init(_truncatingBits source: UInt) {
        let low  = Low(_truncatingBits: source)
        self.init(descending: HL(High.zero, low))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: StaticBigInt) {
        guard let value = Self(_exactlyIntegerLiteral: source) else {
            preconditionFailure("\(source) is not in \(Self.description)'s representable range")
        }
        
        self = value
    }
    
    @inlinable public init?(_exactlyIntegerLiteral source: StaticBigInt) {
        guard  Self.isSigned
        ? source.bitWidth <= Self.bitWidth
        : source.bitWidth <= Self.bitWidth + 1 && source.signum() >= 0
        else { return nil  }
        self = Self.fromUnsafeMutableWords({ for i in $0.indices { $0[i] = source[i] } })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: T) where T: BinaryInteger {
        guard let result = Self(exactly: source) else {
            preconditionFailure("\(source) is not in \(Self.description)'s representable range")
        }
        
        self = result
    }
    
    @inlinable public init?(exactly source: some BinaryInteger) {
        let (value, remainders, sign) = Self.copy(source)
        let isOK = value.isLessThanZero == sign.isFull && remainders.allSatisfy({ $0 == sign })
        if  isOK { self = value } else { return nil }
    }

    @inlinable public init(clamping source: some BinaryInteger) {
        let (value, remainders, sign) = Self.copy(source)
        let isOK = value.isLessThanZero == sign.isFull && remainders.allSatisfy({ $0 == sign })
        self = isOK ? value : sign.isFull ? Self.min : Self.max
    }

    @inlinable public init(truncatingIfNeeded source: some BinaryInteger) {
        self = Self.copy(source).value
    }
    
    @inlinable static func copy<T>(_ source: T) -> (value: Self, remainders: T.Words.SubSequence, sign: UInt) where T: BinaryInteger {
        let words: T.Words = source.words
        assert(words.startIndex ==  Int() && words.endIndex == words.count)
        let sign  = UInt(repeating: T.isSigned && words.last?.mostSignificantBit == true)
        let value = Self.fromUnsafeMutableWords { value in
            for index in value.indices {
                value[index] = index < words.endIndex ? words[index] : sign
            }
        }
        
        return (value: value, remainders: words.dropFirst(Self.count), sign: sign)
    }
}
