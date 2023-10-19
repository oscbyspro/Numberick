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
            precondition(Self.validate(body, sign: sign))
            self.body = body
            self.sign = sign
        }
        
        @inlinable public init(unchecked body: Base, sign: Bool) {
            Swift.assert(Self.validate(body, sign: sign))
            self.body = body
            self.sign = sign
        }
                
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public static func validate(_ body: Base, sign: Bool) -> Bool {
            body.last != Base.Element(repeating: sign)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Strict Binary Integer
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
    @inlinable public init?<T: RandomAccessCollection>(
    fromStrictSignedIntegerSubSequence source: T) where Base == T.SubSequence {
        //=--------------------------------------=
        guard let sign = source.last?.mostSignificantBit else { return nil }
        //=--------------------------------------=
        let bits = UInt(repeating: sign)
        let body = NBK.dropLast(from: source, while:{ $0 == bits })
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
    @inline(__always) @inlinable public init<T:  RandomAccessCollection>(
    fromStrictUnsignedIntegerSubSequence source: T) where Base == T.SubSequence {
        self.init(unchecked: NBK.dropLast(from: source, while:{ $0.isZero }), sign: false)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.SuccinctInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates an instance using the memory as the given sub sequence.
    @inlinable public init<T>(rebasing other: NBK.SuccinctInt<Base.SubSequence>) where Base == UnsafeBufferPointer<T> {
        self.init(unchecked: Base(rebasing: other.body), sign: other.sign)
    }
    
    /// Creates an instance using the memory as the given sub sequence.
    @inlinable public init<T>(rebasing other: NBK.SuccinctInt<Base.SubSequence>) where Base == UnsafeMutableBufferPointer<T> {
        self.init(unchecked: Base(rebasing: other.body), sign: other.sign)
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
    @inlinable public func compared<T>(to rhs: NBK.SuccinctInt<T>) -> Int where T.Element == Base.Element {
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  self.sign != rhs.sign {
            return self.sign ? -1 : 1
        }
        //=---------------------------------------=
        return self.compared(toSameSignUnchecked: rhs)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable func compared<T>(toSameSignUnchecked other: NBK.SuccinctInt<T>) -> Int where T.Element == Base.Element {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        //=--------------------------------------=
        // Long & Short
        //=--------------------------------------=
        if  self.body.count  != other.body.count {
            return self.sign == (self.body.count > other.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return self.compared(toSameSignSameSizeUnchecked: other)
    }
    
    /// A three-way comparison of `self` against `other`.
    @inlinable func compared<T>(toSameSignSameSizeUnchecked other: NBK.SuccinctInt<T>) -> Int where T.Element == Base.Element {
        //=--------------------------------------=
        Swift.assert(self.sign == other.sign)
        Swift.assert(self.body.count == other.body.count)
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        var lhsIndex = self .body.endIndex
        var rhsIndex = other.body.endIndex
        
        backwards: while lhsIndex > self.body.startIndex {
            self .body.formIndex(before: &lhsIndex)
            other.body.formIndex(before: &rhsIndex)
            
            let lhsWord  = self .body[lhsIndex] as Base.Element
            let rhsWord  = other.body[rhsIndex] as Base.Element
            
            if  lhsWord != rhsWord {
                return lhsWord < rhsWord ? -1 : 1
            }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return 0 as Int as Int as Int as Int as Int
    }
}
