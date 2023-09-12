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
// MARK: * NBK x Flexible Width x Storage x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        if  self.storage.count == 1 { return true }
        
        let tail = Int(bitPattern: self.storage[self.storage.count - 1])
        let head = Int(bitPattern: self.storage[self.storage.count - 2])
        
        let sign = tail >> Int.bitWidth
        
        return !(sign == tail && sign == head >> Int.bitWidth)
    }
    
    @inlinable mutating func normalize() {
        Swift.assert(!self.storage.isEmpty)
        //=--------------------------------------=
        var position = self.storage.index(before: self.storage.endIndex)
        let mostSignificantBit = self.storage[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.storage.startIndex {
            if self.storage[position] != sign { return }
            self.storage.formIndex(before: &position)
            if self.storage[position].mostSignificantBit != mostSignificantBit { return }
            self.storage.removeLast()
        }
    }
    
    @inlinable mutating func normalize(appending word: UInt) {
        Swift.assert(!self.storage.isEmpty)
        //=--------------------------------------=
        var position = self.storage.index(before: self.storage.endIndex)
        let mostSignificantBit = self.storage[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        if  word != sign {
            return self.storage.append(word)
        }
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.storage.startIndex {
            if self.storage[position] != sign { return }
            self.storage.formIndex(before: &position)
            if self.storage[position].mostSignificantBit != mostSignificantBit { return }
            self.storage.removeLast()
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        self.storage.count == 1 || !self.storage.last!.isZero
    }
    
    @inlinable mutating func normalize() {
        Swift.assert(!self.storage.isEmpty)
        //=--------------------------------------=
        var position = self.storage.index(before: self.storage.endIndex)
        let sign = UInt(repeating: false)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.storage.startIndex {
            if self.storage[position] != sign { return }
            self.storage.formIndex(before: &position)
            self.storage.removeLast()
        }
    }
}
