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
// MARK: * NBK x Signed
//*============================================================================*

@frozen public struct NBKSigned<Magnitude: NBKUnsignedInteger>: Comparable,
CustomStringConvertible, ExpressibleByIntegerLiteral, Hashable, Sendable, SignedNumeric {
    
    public typealias Sign  = FloatingPointSign
    
    public typealias Digit = NBKSigned<Magnitude.Digit>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The sign of this value.
    public var sign: Sign
    
    /// The magnitude of this value.
    public var magnitude: Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with a positive zero value.
    @inlinable public init() {
        self.init(sign: Sign.plus, magnitude: Magnitude())
    }
    
    /// Creates a new instance with the given sign and magnitude.
    @inlinable public init(sign: Sign, magnitude: Magnitude) {
        self.sign = sign; self.magnitude = magnitude
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    /// Returns `true` for all values, except negative zero where it returns `false`.
    @inlinable public var isNormal: Bool {
        self.sign == Sign.plus || !self.isZero
    }
    
    /// Returns the sign when for all values, except negative zero where it returns `plus`.
    @inlinable public var normalizedSign: Sign {
        self.isNormal ? self.sign : Sign.plus
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Aliases
//*============================================================================*

/// A signed integer with a pointer-bit magnitude.
public typealias SInt = NBKSigned<UInt>

/// A signed integer with an 8-bit magnitude.
public typealias SInt8 = NBKSigned<UInt8>

/// A signed integer with a 16-bit magnitude.
public typealias SInt16 = NBKSigned<UInt16>

/// A signed integer with a 32-bit magnitude.
public typealias SInt32 = NBKSigned<UInt32>

/// A signed integer with a 64-bit magnitude.
public typealias SInt64 = NBKSigned<UInt64>
