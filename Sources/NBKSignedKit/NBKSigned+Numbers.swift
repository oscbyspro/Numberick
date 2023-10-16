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
// MARK: * NBK x Signed x Numbers x Decoding
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// The positive zero value.
    ///
    /// Positive and negative zero are equal and have the same `hashValue`.
    ///
    @inlinable public static var zero: Self {
        Self(sign: Sign.plus, magnitude: Magnitude.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
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
    // NOTE: Using init(sign:magnitude:) is more efficient than init(words:).
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        if  let value = Self(exactly: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
    }
    
    @inlinable public init?<T: BinaryInteger>(exactly source: T) {
        let sign = Sign(bit:  source < T.zero)
        guard let magnitude = Magnitude(exactly: source.magnitude) else { return nil }
        self.init(sign: sign, magnitude: magnitude)
    }
    
    @inlinable public init<T: BinaryInteger>(clamping source: T) {
        let sign = Sign(bit:  source < T.zero)
        let magnitude = Magnitude(clamping: source.magnitude)
        self.init(sign: sign, magnitude: magnitude)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Fixed Width
//=----------------------------------------------------------------------------=

extension NBKSigned where Magnitude: FixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static var max: Self {
        Self(sign: Sign.plus,  magnitude: Magnitude.max)
    }
    
    @inlinable public static var min: Self {
        Self(sign: Sign.minus, magnitude: Magnitude.max)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Numbers x Encoding
//*============================================================================*

extension NBKBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: NBKSigned<T>) {
        if  let value = Self(exactly: source) { self = value } else {
            preconditionFailure("\(Self.self) cannot represent \(source)")
        }
    }
    
    @inlinable public init?<T>(exactly source: NBKSigned<T>) {
        guard let magnitude: Magnitude = NBK.initOrBitCast(exactly: source.magnitude) else { return nil }
        self.init(sign: source.sign, magnitude: magnitude)
    }
    
    @inlinable public init<T>(clamping source: NBKSigned<T>) where Self: NBKFixedWidthInteger {
        self = Self(exactly: source) ?? (source.sign == FloatingPointSign.plus ? Self.max : Self.min)
    }
}
