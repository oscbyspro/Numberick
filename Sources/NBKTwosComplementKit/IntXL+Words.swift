//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some Sequence<UInt>) {
        self.init(Storage(words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: ContiguousArray<UInt> {
        self.storage
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        if  index < self.storage.endIndex {
            return  self.storage[index]
        }   else {
            return  UInt(bitPattern: Int(bitPattern: self.storage.last!) >> Int.bitWidth)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some Sequence<UInt>) {
        self.init(Storage(words))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: ContiguousArray<UInt> {
        self.storage
    }
    
    @inlinable public subscript(index: Int) -> UInt {
        if  index < self.storage.endIndex {
            return  self.storage[index]
        }   else {
            return  0000000000000000000
        }
    }
}
