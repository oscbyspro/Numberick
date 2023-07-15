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
// MARK: * NBK x Flexible Width x Storage x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ elements: some Sequence<UInt>) {
        self.init(elements: Elements(elements))
    }
    
    @inlinable init(repeating element: UInt, count: Int) {
        self.init(elements: Elements(repeating: element, count: count))
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Accessors
    //=--------------------------------------------------------------------=
    
    /// Returns whether the underlying storage is normalized.
    @inlinable var isNormal: Bool {
        self.elements.last != 0 as UInt
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Transformations
    //=--------------------------------------------------------------------=
    
    /// Normalizes the underlying storage.
    @inlinable mutating func normalize() {
        trimming: while self.elements.last == 0 as UInt {
            self.elements.removeLast()
        }
    }
    
    /// Normalizes the underlying storage after appending the element.
    @inlinable mutating func normalizeAppend(_ element: UInt) {
        if  element.isZero {
            self.normalize()
        }   else {
            self.elements.append(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Resizes the underlying storage, if needed.
    @inlinable mutating func resize(minCount: Int) {
        self.elements.reserveCapacity(minCount)
        appending: while self.elements.count < minCount {
            self.elements.append(UInt.zero)
        }
    }
    
    /// Resizes the underlying storage, if needed.
    @inlinable mutating func resize(minLastIndex: Int) {
        self.resize(minCount: minLastIndex + 1)
    }
}
