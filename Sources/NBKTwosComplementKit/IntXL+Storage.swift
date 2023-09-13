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
// MARK: * NBK x Flexible Width x Storage
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable static func normalize(_ storage: inout Storage, update value: Digit) {
        storage.elements.replaceSubrange(storage.elements.indices, with: CollectionOfOne(UInt(bitPattern: value)))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable static func isNormal(_ storage: Storage) -> Bool {
        if  storage.elements.count == 1 { return true }
        
        let tail = Int(bitPattern: storage.elements[storage.elements.count - 1])
        let head = Int(bitPattern: storage.elements[storage.elements.count - 2])
        
        let sign = tail >> Int.bitWidth
        
        return !(sign == tail && sign == head >> Int.bitWidth)
    }
    
    @inlinable static func normalize(_ storage: inout Storage) {
        Swift.assert(!storage.elements.isEmpty)
        //=--------------------------------------=
        var position = storage.elements.index(before:  storage.elements.endIndex)
        let mostSignificantBit = storage.elements[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > storage.elements.startIndex {
            if storage.elements[position] != sign { return }
            storage.elements.formIndex(before: &position)
            if storage.elements[position].mostSignificantBit != mostSignificantBit { return }
            storage.elements.removeLast()
        }
    }
    
    @inlinable static func normalize(_ storage: inout Storage, appending word: UInt) {
        Swift.assert(!storage.elements.isEmpty)
        //=--------------------------------------=
        var position = storage.elements.index(before: storage.elements.endIndex)
        let mostSignificantBit = storage.elements[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        if  word != sign {
            return storage.elements.append(word)
        }
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > storage.elements.startIndex {
            if storage.elements[position] != sign { return }
            storage.elements.formIndex(before: &position)
            if storage.elements[position].mostSignificantBit != mostSignificantBit { return }
            storage.elements.removeLast()
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    @inlinable static func isNormal(_ storage: Storage) -> Bool {
        storage.elements.count == 1 || !storage.elements.last!.isZero
    }
    
    @inlinable static func normalize(_ storage: inout Storage) {
        Swift.assert(!storage.elements.isEmpty)
        //=--------------------------------------=
        var position = storage.elements.index(before: storage.elements.endIndex)
        let sign = UInt(repeating: false)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > storage.elements.startIndex {
            if storage.elements[position] != sign { return }
            storage.elements.formIndex(before: &position)
            storage.elements.removeLast()
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x StorageXL
//*============================================================================*

extension StorageXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func reserveCapacity(_ minCapacity: Int) {
        self.elements.reserveCapacity(minCapacity)
    }
    
    @inlinable mutating func append(_ word: UInt) {
        self.elements.append(word)
    }
    
    @inlinable mutating func resize(maxCount: Int) {
        precondition(maxCount.isMoreThanZero)
        if  self.elements.count > maxCount {
            self.elements.removeSubrange(maxCount...)
        }
    }
    
    @inlinable mutating func resize(minCount: Int, appending word: UInt) {
        self.reserveCapacity(minCount)
        appending: while self.elements.count < minCount {
            self.elements.append(word)
        }
    }
    
    @inlinable mutating func resize(minCount: Int, isSigned: Bool) {
        let isLessThanZero = self.isLessThanZero(isSigned: isSigned)
        self.resize(minCount: minCount, appending: UInt(repeating: isLessThanZero))
    }
}
