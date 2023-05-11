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
    
    @inlinable public init(integerLiteral value: StaticBigInt) {
        fatalError()
    }
    
    @inlinable public init<T>(_ source: T) where T: BinaryInteger {
        fatalError()
    }
    
    @inlinable public init?<T>(exactly source: T) where T: BinaryInteger {
        fatalError()
    }
}
