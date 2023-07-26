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
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    public static let zero = Self(0)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: Int) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Literal
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral value: StaticBigInt) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init?(exactly source: some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(clamping source: some BinaryInteger) {
        fatalError("TODO")
    }
    
    @inlinable public init(truncatingIfNeeded source: some BinaryInteger) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Floating Point
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: some BinaryFloatingPoint) {
        fatalError("TODO")
    }
    
    @inlinable public init?(exactly source: some BinaryFloatingPoint) {
        fatalError("TODO")
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
        self.init(storage: Storage(elements: [digit]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Literal
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: StaticBigInt) {
        guard let value = Self(exactlyIntegerLiteral: source) else {
            preconditionFailure("\(Self.description) cannot represent \(source)")
        }
        
        self = value
    }
    
    @inlinable init?(exactlyIntegerLiteral source: StaticBigInt) {
        guard source.signum() >= 0 else { return nil }
        //=--------------------------------------=
        let bitWidth = source.bitWidth - 1
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let count = major + Int(bit: !minor.isZero)
        //=--------------------------------------=
        let storage = Storage.uninitialized(count: count) { storage in
            for index in storage.indices {
                storage[index] = source[index]
            }
        }
        
        self.init(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Binary Integer
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(_ source: T) where T: BinaryInteger {
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
    
    @inlinable public static func exactly(sign: FloatingPointSign, magnitude: Self) -> Self? {
        if sign == FloatingPointSign.plus || magnitude.isZero { return magnitude } else { return nil }
    }
    
    @inlinable public static func clamping(sign: FloatingPointSign, magnitude: Self) -> Self {
        if sign == FloatingPointSign.plus { return magnitude } else { return Self.zero }
    }
}
