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
        Self(high: High.min, low: Low.min)
    }
    
    @inlinable public static var max: Self {
        Self(high: High.max, low: Low.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable public init(digit: Digit) {
        let bit  = digit.isLessThanZero
        let high = High(repeating: bit)
        let low  = Low(truncatingIfNeeded: digit)
        self.init(high: high, low: low)
    }
    
    @inlinable public init(_truncatingBits  source: UInt) {
        self.init(low: Low(_truncatingBits: source))
    }
    
#if swift(>=5.8)
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: StaticBigInt) {
        guard let value = Self(exactlyIntegerLiteral: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = value
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
    @inlinable public init(integerLiteral source: Int) {
        self.init(source)
    }
#endif
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        guard let result = Self(exactly: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = result
    }
    
    @inlinable public init?(exactly source: some BinaryInteger) {
        let (value, remainders, sign) = Self.truncating(source)
        let isOK = value.isLessThanZero != sign.isZero && remainders.allSatisfy({ $0 == sign })
        if  isOK { self = value } else { return nil }
    }
    
    @inlinable public init(clamping source: some BinaryInteger) {
        let (value, remainders, sign) = Self.truncating(source)
        let isOK = value.isLessThanZero != sign.isZero && remainders.allSatisfy({ $0 == sign })
        if  isOK { self = value } else { self = sign.isZero ? Self.max : Self.min }
    }
    
    @inlinable public init(truncatingIfNeeded source: some BinaryInteger) {
        self = Self.truncating(source).value
    }

    @inlinable static func truncating<T>(_ source: T) -> (value: Self, remainders: T.Words.SubSequence, sign: UInt) where T: BinaryInteger {
        let words: T.Words = source.words
        let isLessThanZero: Bool = T.isSigned && words.last?.mostSignificantBit == true
        let sign = UInt(repeating: isLessThanZero)
        //=--------------------------------------=
        let value = Self.uninitialized  { value in
            for index in value.indices  {
                value[unchecked: index] = index < words.count ? words[words.index(words.startIndex, offsetBy: index)] : sign
            }
        }
        //=--------------------------------------=
        return (value: value, remainders: words.dropFirst(value.count), sign: sign)
    }
}
