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
// MARK: * NBK x Flexible Width x Storage x Normalization
//*============================================================================*

extension PrivateIntXLOrUIntXLStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize(update value: Digit) {
        self.elements.replaceSubrange(self.elements.indices, with: CollectionOfOne(UInt(bitPattern: value)))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x Normalization x IntXL
//*============================================================================*

extension IntXL.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        if  self.elements.count == 1 { return true }
        
        let tail = Int(bitPattern: self.elements[self.elements.count - 1])
        let head = Int(bitPattern: self.elements[self.elements.count - 2])
        
        let sign = tail >> Int.bitWidth
        
        return !(sign == tail && sign == head >> Int.bitWidth)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize() {
        Swift.assert(!self.elements.isEmpty)
        //=--------------------------------------=
        var position = self.elements.index(before:  self.elements.endIndex)
        let mostSignificantBit = self.elements[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.elements.startIndex {
            if self.elements[position] != sign { return }
            self.elements.formIndex(before: &position)
            if self.elements[position].mostSignificantBit != mostSignificantBit { return }
            self.elements.removeLast()
        }
    }
    
    @inlinable mutating func normalize(appending element: UInt) {
        Swift.assert(!self.elements.isEmpty)
        //=--------------------------------------=
        var position = self.elements.index(before: self.elements.endIndex)
        let mostSignificantBit = self.elements[position].mostSignificantBit
        let sign = UInt(repeating: mostSignificantBit)
        //=--------------------------------------=
        if  element != sign {
            return self.elements.append(element)
        }
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.elements.startIndex {
            if self.elements[position] != sign { return }
            self.elements.formIndex(before: &position)
            if self.elements[position].mostSignificantBit != mostSignificantBit { return }
            self.elements.removeLast()
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x Normalization x UIntXL
//*============================================================================*

extension UIntXL.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        self.elements.count == 1 || !self.elements.last!.isZero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable mutating func normalize() {
        Swift.assert(!self.elements.isEmpty)
        //=--------------------------------------=
        var position = self.elements.index(before: self.elements.endIndex)
        let sign = UInt(repeating: false)
        //=--------------------------------------=
        // TODO: measure combined loop conditions
        //=--------------------------------------=
        backwards: while position > self.elements.startIndex {
            if self.elements[position] != sign { return }
            self.elements.formIndex(before: &position)
            self.elements.removeLast()
        }
    }
}
