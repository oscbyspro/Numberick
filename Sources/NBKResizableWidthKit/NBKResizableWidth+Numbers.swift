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
// MARK: * NBK x Numbers x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Digit
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: UInt) {
        self.init(unchecked:[digit])
    }
    
    @inlinable public init(digit: UInt, at index: Int) {
        self.init(repeating: UInt.zero, count: index + 1)
        self.storage[index] = digit
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
    
    // TODO: internal
    @inlinable public init?(exactlyIntegerLiteral source: StaticBigInt) {
        //=--------------------------------------=
        if source.signum() == -1 { return nil }
        //=--------------------------------------=
        self.init(truncatingIntegerLiteral: source)
    }
    
    // TODO: internal
    @inlinable public init(truncatingIntegerLiteral source: StaticBigInt) {
        //=--------------------------------------=
        let bitWidth = source.bitWidth
        let major = NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let minor = NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(bitWidth)
        let count = major + Int(bit: !minor.isZero)
        //=--------------------------------------=
        self = Self.uninitialized(count: count) { storage in
            for index in storage.indices {
                storage[index] = source[index]
            }
        }
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
        fatalError("TODO")
    }
    
    @inlinable public init?(exactly source: some BinaryFloatingPoint) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Sign & Magnitude
    //=------------------------------------------------------------------------=
        
    @inlinable public static func exactly(sign: FloatingPointSign, magnitude: Magnitude) -> Self? {
        if sign == FloatingPointSign.plus || magnitude.isZero { return magnitude } else { return nil }
    }
    
    @inlinable public static func clamping(sign: FloatingPointSign, magnitude: Magnitude) -> Self {
        if sign == FloatingPointSign.plus { return magnitude } else { return Self.zero }
    }
}
