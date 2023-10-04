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
// MARK: * NBK x Signed x Words
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>) {
        self.init(words: words, isSigned: true)
    }
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>, isSigned: Bool) {
        let isLessThanZero: Bool = isSigned && words.last?.mostSignificantBit == true
        guard let magnitude = Magnitude(words: NBK.MaybeTwosComplement(words, formTwosComplement: isLessThanZero)) else { return nil }
        self.init(sign: Sign(bit: isLessThanZero), magnitude: magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(self)
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let count: Int
        @usableFromInline let sign: UInt
        @usableFromInline let base: NBK.MaybeTwosComplement<Magnitude.Words>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ source: NBKSigned) {
            let isLessThanZero = (source.isLessThanZero)
            self.sign  = UInt(repeating: isLessThanZero)
            self.base  = NBK.MaybeTwosComplement(source.magnitude.words, formTwosComplement: isLessThanZero)
            self.count = self.base.count + Int(bit:/**/self.base.last?.mostSignificantBit != isLessThanZero)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: Int {
            (0 as Int)
        }
        
        @inlinable public var endIndex: Int {
            self.count
        }
        
        @inlinable public var indices: Range<Int> {
            0 as Int ..< self.count
        }
        
        @inlinable public subscript(index: Int) -> UInt {
            index < self.base.count ? self.base[self.base.index(self.base.startIndex, offsetBy: index)] : self.sign
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func distance(from start: Int, to end: Int) -> Int {
            end - start
        }
        
        @inlinable public func index(after index: Int) -> Int {
            index + 1 as Int
        }
        
        @inlinable public func index(before index: Int) -> Int {
            index - 1 as Int
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
            index + distance
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
            NBK.arrayIndex(index, offsetBy: distance, limitedBy: limit)
        }
    }
}
