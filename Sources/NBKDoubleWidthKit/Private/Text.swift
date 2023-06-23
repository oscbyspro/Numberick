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
    
    /// Creates a new instance from the given `digits` and `radix`.
    ///
    /// The ASCII sequence passed as `digits` may contain one or more numeric
    /// digits (0-9) or letters (a-z or A-Z), according to the `radix`. If the
    /// ASCII sequence passed as `digits` uses an invalid format, or its value
    /// cannot be represented, the result is nil.
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @inlinable init?(digits: NBK.UnsafeUTF8, radix: Int) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        let alphabet = AnyRadixAlphabetDecoder(radix: radix) // this checks the radix
        //=--------------------------------------=
        self.init()
        
        for digit in  digits {
            guard let addend = alphabet.decode(digit) else { return nil }
            guard !self.multiplyReportingOverflow(by: Self(bitPattern: radix)) else { return nil }
            guard !self.addReportingOverflow(UInt(truncatingIfNeeded: addend)) else { return nil }
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
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable static func fromUTF8Unchecked(chunks: some RandomAccessCollection<UInt>, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        assert(!chunks.isEmpty, "chunks must not be empty")
        assert(!chunks.last!.isZero || chunks.count == 1, "chunks must not have redundant zeros")
        assert(  radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        var remainders = chunks[...]
        let mostSignificantChunk = remainders.removeLast()
        return String.withUTF8Unchecked(chunk: mostSignificantChunk, radix: radix, alphabet: alphabet) { first in
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * radix.exponent
            count += suffix.count
            //=----------------------------------=
            return String(unsafeUninitializedCapacity: count) { utf8 in
                //=------------------------------=
                // de/init: pointee is trivial
                //=------------------------------=
                var index = count as Int
                func pull(_ unit: UInt8) {
                    utf8.formIndex(before: &index)
                    utf8[index] = unit
                }
                //=------------------------------=
                suffix.reversed().forEach(pull)
                
                for var chunk in remainders {
                    for _ in 0 ..< radix.exponent {
                        let digit: UInt
                        (chunk,  digit) = radix.dividing(chunk)
                        pull(alphabet.encode(UInt8(_truncatingBits: digit))!)
                    }
                }
                
                first .reversed().forEach(pull)
                prefix.reversed().forEach(pull)
                //=------------------------------=
                assert(utf8.startIndex == index)
                assert(utf8[index..<count].count == count)
                return count
            }
        }
    }
    
    /// Encodes an unchecked chunk, using the given format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable static func withUTF8Unchecked<T>(chunk: UInt, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, body: (NBK.UnsafeUTF8) -> T) -> T {
        assert(radix.power.isZero || chunk < radix.power, "chunks must be less than radix's power")
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            var chunk = chunk as UInt
            var index = radix.exponent as Int
            //=----------------------------------=
            backwards: repeat {
                let digit: UInt
                (chunk,  digit) = radix.dividing(chunk)
                utf8.formIndex(before: &index)
                utf8[index] = alphabet.encode(UInt8(_truncatingBits: digit))!
            }   while !chunk.isZero
            //=----------------------------------=
            return body(NBK.UnsafeUTF8(rebasing: utf8[index...]))
        }
    }
}
