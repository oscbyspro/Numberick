//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    
    @inlinable public static var zero: Self {
        Self(descending: HL(High.zero, Low.zero))
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
        let high = High.zero
        let low  = Low(_truncatingBits: source)
        self.init(descending: HL(high, low))
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

    @inlinable public init?<T>(exactly source: T) where T: BinaryInteger {
        //=--------------------------------------=
        if !Self.isSigned, source < 0 { return nil }
        //=--------------------------------------=
        if  let low = Low(exactly: source.magnitude) {
            self.init(descending: HL(source < (0 as T) ? (~0, ~low &+ 1) : (0, low)))
        }   else {
            let low = Low(source & T(~0 as Low))
            guard let high = High(exactly: source >> Low.bitWidth) else { return nil }
            self.init(descending: HL(high, low))
        }
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
}
