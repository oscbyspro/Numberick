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
// MARK: * NBK x Flexible Width x Words
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some Sequence<UInt>) {
        self.init(normalizing: Storage(nonemptying: Elements(words)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: ContiguousArray<UInt> {
        self.storage.elements // TODO: make opaque
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        if  index < self.storage.elements.endIndex {
            return  self.storage.elements[index]
        }   else {
            return  UInt(bitPattern: Digit(bitPattern: self.storage.last) >> Digit.bitWidth)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Storage
//*============================================================================*

extension NBKFlexibleWidth.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var first: UInt {
        get { self.elements[self.elements.startIndex]  }
        set { self.elements[self.elements.startIndex] = newValue }
    }
    
    @inlinable var last: UInt {
        get { self.elements[self.elements.index(before: self.elements.endIndex)]  }
        set { self.elements[self.elements.index(before: self.elements.endIndex)] = newValue }
    }
    
    @inlinable subscript<T>(_ index: Int, as type: T.Type) -> T where T: NBKCoreInteger<UInt> {
        get { T.init(bitPattern: self.elements[index]) }
        set { self.elements[index] = UInt(bitPattern: newValue) }
    }
}
