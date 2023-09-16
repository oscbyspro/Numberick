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
// MARK: * NBK x Flexible Width x Numbers x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    public static let zero = Self(digit: 0)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: UInt) {
        self.init(unchecked: Storage(unchecked: [digit]))
    }
    
    // #warning("unchecked should be unchecked...")
    @inlinable public init(digit: UInt, at index: Int) {
        var storage = Storage(repeating: 0 as UInt, count: index + 1)
        storage.elements[index] = digit
        storage.normalize()
        self.init(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        if  let value = Self(exactly: source) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
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
        if  let value = Self(exactly: source.rounded(.towardZero)) { self = value } else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
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
