//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width Integer x Numbers
//*============================================================================*

extension DoubleWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var min: Self {
        Self(high: High.min,  low: Low.min)
    }
    
    @inlinable public static var max: Self {
        Self(high: High.max,  low: Low.max)
    }
    
    @inlinable public static var zero: Self {
        Self(high: High.zero, low: Low.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    public init(integerLiteral value: StaticBigInt) {
        fatalError()
    }
    
    public init(_truncatingBits source: UInt) {
        fatalError()
    }
    
    public init<T>(_ source: T) where T: BinaryInteger {
        fatalError()
    }
    
    public init?<T>(exactly source: T) where T: BinaryInteger {
        fatalError()
    }
}
