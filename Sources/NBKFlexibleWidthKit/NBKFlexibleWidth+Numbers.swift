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
// MARK: * NBK x Flexible Width x Numbers x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    public static let zero = Self(0)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: Int) {
        let sign = digit.isLessThanZero
        let magnitude = Magnitude(digit: digit.magnitude)
        self.init(sign: Sign(sign), magnitude: magnitude)
    }
    
    @inlinable public init(digit: Int, at index: Int) {
        let sign = digit.isLessThanZero
        let magnitude = Magnitude(digit: digit.magnitude, at: index)
        self.init(sign: Sign(sign), magnitude: magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        //=--------------------------------------=
        // Magnitude
        //=--------------------------------------=
        if  let source = source as? Magnitude {
            self.init(sign: Sign.plus, magnitude: source)
        //=--------------------------------------=
        // some BinaryInteger
        //=--------------------------------------=
        }   else {
            let sign = Sign(source < 0)
            let magnitude = Magnitude(source.magnitude)
            self.init(sign: sign, magnitude: magnitude)
        }
    }
    
    @inlinable public init?(exactly source: some BinaryInteger) {
        self.init(source)
    }
    
    @inlinable public init(clamping source: some BinaryInteger) {
        self.init(source)
    }
    
    @inlinable public init(truncatingIfNeeded source: some BinaryInteger) {
        self.init(source)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Floating Point
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryFloatingPoint) {
        guard let result = Self(exactly: source.rounded(.towardZero)) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = result
    }
    
    @inlinable public init?(exactly source: some BinaryFloatingPoint) {
        guard let magnitude = Magnitude(exactly: source.magnitude) else { return nil }
        self.init(sign: source.sign,  magnitude: magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Numbers x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    public static let zero = Self(0)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: UInt) {
        self.init(unchecked: Storage(digit: digit))
    }
    
    @inlinable public init(digit: UInt, at index: Int) {
        self.init(unchecked: Storage(digit: digit, at: index))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        guard let result = Self(exactly: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = result
    }
    
    @inlinable public init?(exactly source: some BinaryInteger) {
        guard source.signum() >= 0 else { return nil }
        self.init(words: source.words)
    }
    
    @inlinable public init(clamping source: some BinaryInteger) {
        self = Self(exactly: source) ?? (0 as Self)
    }
    
    @inlinable public init(truncatingIfNeeded source: some BinaryInteger) {
        self.init(words: source.words)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Floating Point
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryFloatingPoint) {
        guard let value = Self(exactly: source.rounded(.towardZero)) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = value
    }
    
    @inlinable public init?(exactly source: some BinaryFloatingPoint) {
        if source.sign == .minus { return nil }
        //=--------------------------------------=
        if source.isZero { self.init();  return }
        guard source.isFinite else { return nil }
        let   value = source.rounded(.towardZero)
        guard value == source else { return nil }
        //=--------------------------------------=
        let exponent = Int(source.exponent)
        let ratio = exponent.quotientAndRemainder(dividingBy: UInt.bitWidth)
        //=--------------------------------------=
        self.init(exactly: source.significandBitPattern)
        self >>=  type(of: source).significandBitCount - exponent
        self.add(UInt(1) << ratio.remainder, at: ratio.quotient)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(sign: FloatingPointSign, magnitude: Magnitude) {
        if sign == FloatingPointSign.plus || magnitude.isZero { self = magnitude } else { return nil }
    }
}
