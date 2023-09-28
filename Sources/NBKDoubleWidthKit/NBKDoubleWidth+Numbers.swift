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
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        if  let value = Self(exactly: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable public init?<T: BinaryInteger>(exactly source: T) {
        let  comparison: Int
       (self,comparison) = Self.validating(words: source.words, isSigned: T.isSigned)
        if  !comparison.isZero { return nil }
    }
    
    @inlinable public init<T: BinaryInteger>(clamping source: T) {
        let  comparison: Int
       (self,comparison) = Self.validating(words: source.words, isSigned: T.isSigned)
        if  !comparison.isZero { self = comparison == -1 ? Self.min : Self.max }
    }
    
    @inlinable public init<T: BinaryInteger>(truncatingIfNeeded source: T) {
        self = Self.truncating(words: source.words, isSigned: T.isSigned).value
    }
}
