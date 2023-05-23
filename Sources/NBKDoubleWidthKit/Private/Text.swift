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
// MARK: * NBK x Text x UInt
//*============================================================================*

extension UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digits and radix.
    ///
    /// The buffer passed as `digits` contain one or more numeric digits (0-9) or
    /// letters (a-z or A-Z) in ASCII format. The decoding is case insensitive.
    ///
    /// ```
    /// │     input       │ output │
    /// ├────────┬────────┼────────┤
    /// │ digits │ radix  │ value  │
    /// ├────────┼────────┼────────┤
    /// │  "123" │  10    │  123   │
    /// │ "+123" │  10    │  nil   │
    /// │  "123" │  16    │  291   │
    /// │ "+123" │  16    │  nil   │
    /// ```
    ///
    /// - Parameters:
    ///   - digits: An unsigned ASCII sequence of a number in the radix passed as `radix`.
    ///   - radix: The decoding radix. Its value must be in 2 through 36. The default is 10.
    ///
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: Int) {
        guard !digits.isEmpty else { return nil }
        //=------------------------------------------=
        let multiplier =/**/Self(truncatingIfNeeded: radix)
        let decoder = AnyRadixAlphabetDecoder(radix: radix)
        //=------------------------------------------=
        self.init()
        
        for digit in digits {
            guard let value = decoder.decode(digit)/*----------------------*/ else { return nil }
            guard !self.multiplyReportingOverflow(by: multiplier)/*--------*/ else { return nil }
            guard !self.addReportingOverflow(Self(truncatingIfNeeded: value)) else { return nil }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Text x String
//*============================================================================*

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Encodes unchecked chunks, using the given format.
    @inlinable internal static func fromUTF8(uncheckedChunks: some RandomAccessCollection<UInt>, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeBufferPointer<UInt8>) -> String {
        //=--------------------------------------=
        radix.assertChunkCollectionIsValid(uncheckedChunks)
        //=--------------------------------------=
        return String.withUTF8(uncheckedChunk: uncheckedChunks.last!, radix: radix, alphabet: alphabet) { leader in
            let count = prefix.count &+ leader.count + radix.exponent * (uncheckedChunks.count &- 1)
            return String(unsafeUninitializedCapacity: count) { utf8 in
                var index = utf8.startIndex
                //=------------------------------=
                index = utf8[index...].initialize(fromContentsOf: prefix)
                index = utf8[index...].initialize(fromContentsOf: leader)
                //=------------------------------=
                for var chunk in uncheckedChunks.dropLast().reversed() {
                    let destination = utf8.index(index, offsetBy: radix.exponent)
                    var backtrack = destination
                    defer { index = destination }
                    
                    backwards: while backtrack > index {
                        utf8.formIndex(before: &backtrack)
                        
                        let digit: UInt
                        (chunk,  digit) = radix.dividing(chunk)
                        let unit: UInt8 = alphabet[unchecked: UInt8(_truncatingBits: digit)]
                        utf8.initializeElement(at: backtrack, to: unit)
                    }
                }
                //=------------------------------=
                assert(utf8[..<index].count == count)
                return count
            }
        }
    }
    
    /// Encodes an unchecked chunk, using the given format.
    @inlinable internal static func withUTF8<T>(uncheckedChunk: UInt, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, body: (UnsafeBufferPointer<UInt8>) -> T) -> T {
        //=--------------------------------------=
        radix.assertChunkCollectionIsValid(CollectionOfOne(uncheckedChunk))
        //=--------------------------------------=
        return withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            var chunk = uncheckedChunk as UInt
            var backtrack = radix.exponent as Int
            //=----------------------------------=
            backwards: repeat {
                utf8.formIndex(before: &backtrack)
                
                let digit: UInt
                (chunk,  digit) = radix.dividing(chunk)
                let unit: UInt8 = alphabet[unchecked: UInt8(_truncatingBits: digit)]
                utf8.initializeElement(at: backtrack, to: unit)
            }   while !chunk.isZero
            //=----------------------------------=
            let initialized = utf8[backtrack...]
            defer { initialized.deinitialize() }
            //=----------------------------------=
            return body(UnsafeBufferPointer(rebasing: initialized))
        }
    }
}
