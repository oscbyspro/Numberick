//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Succinct Int x Comparisons
//*============================================================================*

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
