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
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    @inlinable var isNormal: Bool {
        // TODO: self.elements.last != 0
        
        switch self.elements.count > 1 {
        case  true: return !self.elements.last!.isZero
        case false: return !self.elements.isEmpty }
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Transformations
    //=--------------------------------------------------------------------=
    
    /// Normalizes the underlying storage.
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    @inlinable mutating func normalize() {
        // TODO: while self.elements.last == 0 { self.elements.removeLast() }
        
        var index = self.elements.endIndex as Int
        if  index > self.elements.startIndex {
            self.elements.formIndex(before: &index)
            while index > self.elements.startIndex,
            self.elements[index].isZero {
                self.elements.formIndex(before: &index)
                self.elements.removeLast()
            }
        }   else {
            self.elements.append(UInt.zero)
        }
    }
    
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
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    /// - Note: Calling this method denormalizes `self`.
    ///
    @inlinable mutating func resize(minCount: Int) {
        self.elements.reserveCapacity(minCount)
        appending: while self.elements.count < minCount {
            self.elements.append(UInt.zero)
        }
    }
    
    /// Resizes the underlying storage, if needed.
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    ///
    /// - Note: Calling this method denormalizes `self`.
    ///
    @inlinable mutating func resize(minLastIndex: Int) {
        self.resize(minCount: minLastIndex + 1)
    }
}
