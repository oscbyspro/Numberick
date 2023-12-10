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
// MARK: * NBK x Flexible Width x Multiplication x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                Self.uninitialized(count: lhs.count + rhs.count) {
                    NBK.SUISS.initialize(&$0, to: lhs, times: rhs)
                }
            }
        }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Square
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func square() {
        self = self.squared()
    }
    
    @inlinable public func squared() -> Self {
        self.withUnsafeBufferPointer{ words in
            Self.uninitialized(count: words.count * 2) {
                NBK.SUISS.initialize(&$0, toSquareProductOf: words)
            }
        }
    }
}

