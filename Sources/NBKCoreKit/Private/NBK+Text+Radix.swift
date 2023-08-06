//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Text x Radix
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by truncating the given `digits` and `radix`.
    ///
    /// The sequence passed as `digits` may contain one or more numeric digits
    /// (0-9) or letters (a-z or A-Z), according to the `radix`. If the sequence
    /// passed as `digits` uses an invalid format, the result is nil. If the
    /// sequence passed as `digits` cannot be represented, the result is truncated.
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    /// ### Parameters
    ///
    /// Creating a new decoder is faster than passing one as an argument.
    ///
    @inlinable public static func truncating<T>(digits: NBK.UnsafeUTF8, radix: Int, as type: T.Type = T.self) -> T? where T: NBKCoreInteger {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        let alphabet = NBK.AnyRadixAlphabetDecoder(radix: radix)
        //=--------------------------------------=
        var value = T.zero
        let multiplicand = NBK.initOrBitCast(truncating: radix, as: T.self)
        //  all core integers can represent the range 2 ... 36
        
        for digit in  digits {
            guard let addend = alphabet.decode(digit) else { return nil }
            value &*= multiplicand
            value &+= NBK.initOrBitCast(truncating: addend, as: T.self)
            //  all core integers can represent the range 0 ..< 36
        }
        
        return value as T
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    /// Encodes unchecked chunks, using the given UTF-8 format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable public static func integerTextUnchecked(chunks: some RandomAccessCollection<UInt>, radix: some _NBKRadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        assert(chunks.count <= 1  || chunks.last != 0, "chunks must not contain redundant zeros")
        assert(radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        var remainders = chunks[...]
        let mostSignificantChunk = remainders.popLast() ?? UInt()
        return NBK.withIntegerTextUnchecked(chunk: mostSignificantChunk, radix: radix, alphabet: alphabet) { first in
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * radix.exponent
            count += suffix.count
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
                        pull(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
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
    
    /// Encodes an unchecked chunk, using the given UTF-8 format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable public static func withIntegerTextUnchecked<T>(chunk: UInt, radix: some _NBKRadixUIntRoot,
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
                utf8[index] = alphabet.encode(UInt8(truncatingIfNeeded: digit))!
            }   while !chunk.isZero
            //=----------------------------------=
            return body(NBK.UnsafeUTF8(rebasing: utf8[index...]))
        }
    }
}
