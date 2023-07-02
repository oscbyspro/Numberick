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
// MARK: * NBK x Double Width x Rotations x Left
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitrotateLeft(words: Int) {
        self = self.bitrotatedLeft(words: words)
    }
    
    /// Performs a left rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitrotatedLeft(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return Self.uninitialized { result in
            var destination = words
            
            for source in self.indices {
                result[destination] = self[source]
                result.formIndex(after: &destination)
                
                if  destination >= result.endIndex {
                    destination -= result.endIndex
                }
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Rotations x Right
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public mutating func bitrotateRight(words: Int) {
        self = self.bitrotatedRight(words: words)
    }
    
    /// Performs a right rotation.
    ///
    /// - Parameters:
    ///   - words: `0 <= words < Self.endIndex`
    ///
    @inlinable public func bitrotatedRight(words: Int) -> Self {
        precondition(0 ..< self.endIndex ~= words, "invalid major rotation distance")
        //=--------------------------------------=
        if  words.isZero { return self }
        //=--------------------------------------=
        return Self.uninitialized { result in
            var source = words
            
            for destination in result.indices {
                result[destination] = self[source]
                self.formIndex(after: &source)
                
                if  source >= self.endIndex {
                    source -= self.endIndex
                }
            }
        }
    }
}
