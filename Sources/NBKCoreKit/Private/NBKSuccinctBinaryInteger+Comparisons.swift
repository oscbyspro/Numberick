//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Succinct Binary Integer x Comparisons
//*============================================================================*

extension NBK.SuccinctBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compare(_ lhs: Components, to rhs: Components) -> Int {
        //=--------------------------------------=
        Swift.assert(lhs.body.last != Base.Element(repeating: lhs.sign))
        Swift.assert(rhs.body.last != Base.Element(repeating: rhs.sign))
        //=--------------------------------------=
        // Plus & Minus
        //=--------------------------------------=
        if  lhs.sign != rhs.sign {
            return lhs.sign ? -1 : 1
        }
        //=---------------------------------------=
        return self.compareSameSign(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareSameSign(_ lhs: Components, to rhs: Components) -> Int {
        //=--------------------------------------=
        Swift.assert(lhs.sign == rhs.sign)
        Swift.assert(lhs.body.last != Base.Element(repeating: lhs.sign))
        Swift.assert(rhs.body.last != Base.Element(repeating: rhs.sign))
        //=---------------------------------------=
        // Long & Short
        //=---------------------------------------=
        if  lhs.body.count  !=  rhs.body.count {
            return lhs.sign == (lhs.body.count > rhs.body.count) ? -1 : 1
        }
        //=--------------------------------------=
        return self.compareSameSizeSameSign(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable public static func compareSameSizeSameSign(_ lhs: Components, to rhs: Components) -> Int {
        //=--------------------------------------=
        Swift.assert(lhs.sign == rhs.sign)
        Swift.assert(lhs.body.count == rhs.body.count)
        Swift.assert(lhs.body.last  != Base.Element(repeating: lhs.sign))
        Swift.assert(rhs.body.last  != Base.Element(repeating: rhs.sign))
        //=--------------------------------------=
        // Word By Word, Back To Front
        //=--------------------------------------=
        for index in lhs.body.indices.reversed() {
            let lhsWord  = lhs.body[index] as Base.Element
            let rhsWord  = rhs.body[index] as Base.Element
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        //=--------------------------------------=
        // Same
        //=--------------------------------------=
        return 0 as Int
    }
}
