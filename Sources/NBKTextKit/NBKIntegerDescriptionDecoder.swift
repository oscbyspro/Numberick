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
// MARK: * NBK x Integer Description Decoder
//*============================================================================*

@frozen public struct NBKIntegerDescriptionDecoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let solution: AnyRadixSolution<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(radix: Int) {
        self.solution = AnyRadixSolution(radix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: some StringProtocol, as type: T.Type = T.self) -> T? {
        var description = String(description); return description.withUTF8({ self.decode($0) })
    }
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: StaticString, as type: T.Type = T.self) -> T? {
        description.withUTF8Buffer({ self.decode($0) })
    }
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: NBK.UnsafeUTF8, as type: T.Type = T.self) -> T? {
        NBKIntegerDescription.decode(description, radix: self.solution)
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description Decoder x Decoding Radix
//*============================================================================*

@frozen public struct NBKIntegerDescriptionDecoderDecodingRadix {
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init() { }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: some StringProtocol, as type: T.Type = T.self) -> T? {
        var description = String(description); return description.withUTF8({ self.decode($0) })
    }
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: StaticString, as type: T.Type = T.self) -> T? {
        description.withUTF8Buffer({ self.decode($0) })
    }
    
    @inlinable public func decode<T: NBKBinaryInteger>(_ description: NBK.UnsafeUTF8, as type: T.Type = T.self) -> T? {
        NBKIntegerDescription.decodeByDecodingRadix(description)
    }
}
