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
// MARK: * NBK x Integer Description Encoder
//*============================================================================*

@frozen public struct NBKIntegerDescriptionEncoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let solution: AnyRadixSolution<Int>
    @usableFromInline let alphabet: NBKIntegerDescriptionMaxAlphabetEncoder
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(radix: Int, uppercase: Bool) {
        self.solution = AnyRadixSolution<Int>(radix)
        self.alphabet = NBKIntegerDescriptionMaxAlphabetEncoder(uppercase: uppercase)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Encode
//=----------------------------------------------------------------------------=

extension NBKIntegerDescriptionEncoder {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    
    @inlinable public func encode(_ integer: some NBKBinaryInteger) -> String {
        self.encode(magnitude: integer.magnitude.words, uncheckedIsLessThanZero: integer.isLessThanZero)
    }
    
    @inlinable public func encode(sign: FloatingPointSign, magnitude: some RandomAccessCollection<UInt>) -> String {
        self.encode(magnitude: magnitude, uncheckedIsLessThanZero: sign == .minus && !magnitude.allSatisfy({ $0.isZero }))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private x Algorithms
    //=------------------------------------------------------------------------=
    
    @inlinable func encode(magnitude: some RandomAccessCollection<UInt>, uncheckedIsLessThanZero: Bool) -> String {
        Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: magnitude.count) {
            var copy = $0 as UnsafeMutableBufferPointer<UInt>
            _ = copy.initialize(from: magnitude)
            defer{ copy.baseAddress!.deinitialize(count: magnitude.count) }
            return self.encode(magnitude: &copy, uncheckedIsLessThanZero: uncheckedIsLessThanZero)
        }
    }
    
    @usableFromInline func encode(magnitude: inout NBK.UnsafeMutableWords, uncheckedIsLessThanZero: Bool) -> String {
        Swift.assert(!uncheckedIsLessThanZero || !magnitude.allSatisfy({ $0.isZero }) )
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 1 as Int) {
            var prefix = $0 as UnsafeMutableBufferPointer<UInt8>
            prefix.baseAddress!.initialize(to: UInt8(ascii: uncheckedIsLessThanZero ? "-" : "+"))
            defer{ prefix.baseAddress!.deinitialize(count: 1 as Int) }
            prefix = UnsafeMutableBufferPointer(rebasing: prefix.prefix(Int(bit: uncheckedIsLessThanZero)))
            return NBKIntegerDescription.encode(
            magnitude: &magnitude,
            solution: solution as AnyRadixSolution<Int>,
            alphabet: alphabet as NBKIntegerDescriptionMaxAlphabetEncoder,
            prefix: UnsafeBufferPointer(prefix),
            suffix: NBK.UnsafeUTF8(start: nil, count: 0 as Int))
        }
    }
}
