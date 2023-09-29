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
// MARK: * NBK x Flexible Width x Words x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some Sequence<UInt>) {
        self.init(words: words, isSigned: Self.isSigned)!
    }
    
    @inlinable public init?(words: some Sequence<UInt>, isSigned: Bool) {
        var storage =  Storage(nonemptying: Elements(words))
        if isSigned && storage.elements.last!.mostSignificantBit { return nil }
        
        storage.normalize()
        self.init(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        self.storage.elements.count
    }
    
    @inlinable public var words: ContiguousArray<UInt> {
        _read { yield self.storage.elements }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    /// The least significant word.
    ///
    /// - Note: This member is required by `Swift.BinaryInteger`.
    ///
    @inlinable public var _lowWord: UInt {
        self.first as UInt
    }
    
    /// The least significant word.
    @inlinable public var first: UInt {
        self.withUnsafeBufferPointer({ $0[0] })
    }
    
    /// The most significant word.
    @inlinable public var last: UInt {
        self.withUnsafeBufferPointer({ $0[$0.count - 1] })
    }
    
    @inlinable subscript(index: Int) -> UInt {
        index < self.storage.elements.endIndex ? self.storage.elements[index] : 0 as UInt
    }
}
