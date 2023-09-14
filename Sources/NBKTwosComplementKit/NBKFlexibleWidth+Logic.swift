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
        lhs.storage.upsizeThenFormInIntersection(extending: rhs.storage, each: &)
        lhs.storage.normalize()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(extending: rhs.storage, each: |)
        lhs.storage.normalize()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(extending: rhs.storage, each: ^)
        lhs.storage.normalize()
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
        lhs.storage.normalize()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, each: |)
        Swift.assert(lhs.storage.isNormal)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, each: ^)
        Swift.assert(lhs.storage.isNormal)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x Storage
//*============================================================================*

extension PrivateIntXLOrUIntXLStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
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
    
    @inlinable mutating func upsizeThenFormInIntersection(with other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(minCount: other.elements.count)
        self.elements.withUnsafeMutableBufferPointer { lhs in
            other.elements.withUnsafeBufferPointer {   rhs in
                for index in rhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
    
    @inlinable mutating func upsizeThenFormInIntersection(extending other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(minCount: other.elements.count)
        self.elements.withUnsafeMutableBufferPointer { lhs in
            other.elements.withUnsafeBufferPointer {   rhs in
                let rhsSign = UInt(repeating: Self.isSigned && rhs.last!.mostSignificantBit)
                for index in lhs.indices {
                    lhs[index] = element(lhs[index], index < rhs.endIndex ? rhs[index] : rhsSign)
                }
            }
        }
    }
}
