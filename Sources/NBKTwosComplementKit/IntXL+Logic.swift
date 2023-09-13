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
// MARK: * NBK x Flexible Width x Logic
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x NOT
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(x: Self) -> Self {
        x.onesComplement()
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x AND
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(extending: rhs, each: &)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(extending: rhs, each: |)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(extending: rhs, each: ^)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func upsizeThenFormInIntersection(extending other: Self, each element: (UInt, UInt) -> UInt) {
        let lhsSign = UInt(repeating: self.isLessThanZero)
        self.storage.resize(minCount: other.storage.elements.count, appending: lhsSign)
        self.withUnsafeMutableBufferPointer { lhs in
            other.withUnsafeBufferPointer {   rhs in
                let rhsSign = UInt(repeating: rhs.last!.mostSignificantBit)
                for index in  lhs.indices {
                    lhs[index] = element(lhs[index], index < rhs.endIndex ? rhs[index] : rhsSign)
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x AND
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        lhs.storage.downsizeThenFormInIntersection(with: rhs.storage, each: &)
        Self.normalize(&lhs.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, appending: 0 as UInt, each: |)
        Swift.assert(Self.isNormal(lhs.storage))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, appending: 0 as UInt, each: ^)
        Swift.assert(Self.isNormal(lhs.storage))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x Storage
//*============================================================================*

extension StorageXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func upsizeThenFormInIntersection(with other: Self, appending word: UInt, each element: (UInt, UInt) -> UInt) {
        self.resize(minCount: other.elements.count, appending: word)
        self.elements.withUnsafeMutableBufferPointer { lhs in
            other.elements.withUnsafeBufferPointer {   rhs in
                for index in rhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
    
    @inlinable mutating func downsizeThenFormInIntersection(with other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(maxCount: other.elements.count)
        self.elements.withUnsafeMutableBufferPointer { lhs in
            other.elements.withUnsafeBufferPointer {   rhs in
                for index in lhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
}
