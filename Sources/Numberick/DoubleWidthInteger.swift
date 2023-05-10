//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width Integer
//*============================================================================*

@frozen public struct DoubleWidthInteger<High>: FixedWidthInteger & WholeMachineWords
where High: FixedWidthInteger & WholeMachineWords, High.Magnitude:  WholeMachineWords {
    
    public typealias High = High
    
    public typealias Low  = High.Magnitude
    
    public typealias Magnitude = DoubleWidthInteger<High.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        High.isSigned
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


//*============================================================================*
// MARK: * NBK x Double Width Integer x Conditional Conformances
//*============================================================================*

extension DoubleWidthInteger:   SignedInteger, SignedNumeric where High:   SignedInteger { }
extension DoubleWidthInteger: UnsignedInteger  /*---------*/ where High: UnsignedInteger { }
