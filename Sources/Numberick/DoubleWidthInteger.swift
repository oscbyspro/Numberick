//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Double Width Integer
//*============================================================================*

@frozen public struct DoubleWidthInteger<High> where High: FixedWidthInteger {
    
    public typealias High = High
    
    public typealias Low  = High.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        High.isSigned
    }
    
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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var low:  Low
    public var high: High
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(high: High, low: Low) {
        self.low  = low
        self.high = high
    }
}
