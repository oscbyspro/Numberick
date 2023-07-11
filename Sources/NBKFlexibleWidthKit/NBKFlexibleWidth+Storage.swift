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

extension NBKFlexibleWidth.Magnitude {
    
    @usableFromInline typealias Storage = Array<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Private
    //=------------------------------------------------------------------------=
    
    /// Returns whether the underlying storage is normalized.
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    @inlinable var isNormal: Bool {
        switch self.storage.count > 1 {
        case  true: return !self.storage.last!.isZero
        case false: return !self.storage.isEmpty }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    /// Normalizes the underlying storage.
    ///
    /// The storage is normalized under each of the following conditions:
    ///
    /// - `count == 1`
    /// - `count >= 2 && last != 0`
    ///
    @inlinable mutating func normalize() {
        var index = self.storage.endIndex as Int
        if  index > self.storage.startIndex {
            self.storage.formIndex(before: &index)
            while index > self.storage.startIndex,
            self.storage[index].isZero {
                self.storage.formIndex(before: &index)
                self.storage.removeLast()
            }
        }   else {
            self.storage.append(UInt.zero)
        }
    }
    
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
        self.storage.reserveCapacity(minCount)
        appending: while self.storage.count < minCount {
            self.storage.append(UInt.zero)
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
