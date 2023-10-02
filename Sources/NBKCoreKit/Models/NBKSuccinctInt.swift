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
            precondition(Self.isValid(body, sign: sign))
            self.body = body
            self.sign = sign
        }
        
        @inlinable public init(unchecked body: Base, sign: Bool) {
            Swift.assert(Self.isValid(body, sign: sign))
            self.body = body
            self.sign = sign
        }
                
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public static func isValid(_ body: Base, sign: Bool) -> Bool {
            body.last != Base.Element(repeating: sign)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Comparisons
//=----------------------------------------------------------------------------=

extension NBK.SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared(to rhs: Self) -> Int {
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  self.sign != rhs.sign {
            return self.sign ? -1 : 1
        }
        //=---------------------------------------=
        return self.compared(toSameSign: rhs)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared(toSameSign other: Self) -> Int {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        //=--------------------------------------=
        // Long & Short
        //=--------------------------------------=
        if  self.body.count  != other.body.count {
            return self.sign == (self.body.count > other.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return self.compared(toSameSignSameSize: other)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable public func compared(toSameSignSameSize other: Self) -> Int {
        //=--------------------------------------=
        Swift.assert(self.sign/*--*/ == other.sign/*--*/)
        Swift.assert(self.body.count == other.body.count)
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        for index in self.body.indices.reversed() {
            let lhsWord  = self .body[index] as Base.Element
            let rhsWord  = other.body[index] as Base.Element
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return 0 as Int as Int as Int as Int as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from a strict signed integer subsequence.
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
    /// │                │                │ nil   │
    /// └─────────────── → ───────────────┴───────┘
    /// ```
    ///
    /// ### Development
    ///
    /// `@inline(always)` is required for `NBKFlexibleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public init?<T>(fromStrictSignedIntegerSubSequence source: Base) where Base == UnsafeBufferPointer<T> {
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
