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
// MARK: * NBK x Signed x Numbers
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: Digit) {
        let sign = digit.sign
        let magnitude = Magnitude(digit: digit.magnitude)
        self.init(sign: sign, magnitude: magnitude)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Magnitude) {
        self.init(sign: Sign.plus, magnitude: source)
    }
    
    @inlinable public init?(exactly source: Magnitude) {
        self.init(sign: Sign.plus, magnitude: source)
    }
    
    @inlinable public init(clamping source: Magnitude) {
        self.init(sign: Sign.plus, magnitude: source)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        if  let value = Self(exactly: source) { self = value } else {
            preconditionFailure("\(Self.self) cannot represent \(source)")
        }
    }
    
    @inlinable public init?<T: BinaryInteger>(exactly source: T) {
        let sign = Sign(source < T.zero)
        guard let magnitude = Magnitude(exactly: source.magnitude) else { return nil }
        self.init(sign: sign, magnitude: magnitude)
    }
    
    @inlinable public init<T: BinaryInteger>(clamping source: T) {
        let sign = Sign(source < T.zero)
        let magnitude = Magnitude(clamping: source.magnitude)
        self.init(sign: sign, magnitude: magnitude)
    }
}
