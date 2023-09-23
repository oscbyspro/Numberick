//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Succinct Int
//*============================================================================*

extension NBK {
    
    /// A succinct binary integer.
    @frozen public struct SuccinctInt<Base> where Base: RandomAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let body: Base
        public let sign: Bool
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ body: Base, sign: Bool) {
            self.body = body
            self.sign = sign
            precondition(self.body.last != Base.Element(repeating: sign))
        }
        
        @inlinable public init(unchecked body: Base, sign: Bool) {
            self.body = body
            self.sign = sign
            Swift.assert(self.body.last != Base.Element(repeating: sign))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from a strict signed integer.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬───────┐
    /// │ source         │ body           │ sign  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │  0,  0,  0,  0 │                │ false │
    /// │  1,  2,  0,  0 │  1,  2         │ false │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2         │ true  │
    /// │ ~0, ~0, ~0, ~0 │                │ true  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │                │                │ error │
    /// └─────────────── → ───────────────┴───────┘
    /// ```
    ///
    /// ### Development
    ///
    /// `@inline(always)` is required for `NBKFlexibleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public init?<T>(fromStrictSignedInteger source: Base) where Base == UnsafeBufferPointer<T> {
        guard let sign = source.last?.mostSignificantBit else { return nil }
        let bits = UInt(repeating: sign)
        let body = Base(rebasing:  NBK.dropLast(from: source, while:{ $0 == bits }))
        self.init(unchecked: body, sign: sign)
    }
    
    /// Creates a new instance from a strict unsigned integer subsequence.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬───────┐
    /// │ source         │ body           │ sign  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │  0,  0,  0,  0 │                │ false │
    /// │  1,  2,  0,  0 │  1,  2         │ false │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2, ~0, ~0 │ false │
    /// │ ~0, ~0, ~0, ~0 │ ~0, ~0, ~0, ~0 │ false │
    /// ├─────────────── → ───────────────┼───────┤
    /// │                │                │ false │
    /// └─────────────── → ───────────────┴───────┘
    /// ```
    ///
    /// ### Development
    ///
    /// `@inline(always)` is required for `NBKFlexibleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public init<T>(fromStrictUnsignedIntegerSubSequence source: Base) where Base == UnsafeBufferPointer<T> {
        self.init(unchecked: Base(rebasing: NBK.dropLast(from: source, while:{ $0.isZero })), sign: false)
    }
}
