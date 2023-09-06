//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Text
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance by truncating the given `digits` and `radix`.
    ///
    /// The sequence passed as `digits` may contain one or more numeric digits
    /// (0-9) or letters (a-z or A-Z). If the sequence passed as `digits` uses
    /// an invalid format, the result is nil. If the sequence passed as `digits`
    /// cannot be represented, the result is truncated.
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    /// ### Parameters
    ///
    /// Creating a new decoder is faster than passing one as an argument.
    ///
    @inlinable public static func truncating<T: NBKCoreInteger>(
    digits: UnsafeUTF8, radix: Int, as type: T.Type = T.self) -> T? {
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
    /// - Note: `@inlinable` is not needed.
    ///
    public static func integerTextUnchecked(
    chunks:   NBKTwinHeaded<NBK.UnsafeWords>,  radix: AnyRadixSolution<Int>,
    alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeUTF8, suffix: UnsafeUTF8) -> String {
        assert(chunks.count <= 1  || chunks.last != 0, "chunks must not contain redundant zeros")
        assert(radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        var remainders = chunks[...]
        let mostSignificantChunk = remainders.popLast() ?? UInt()
        return NBK.withUnsafeTemporaryIntegerTextUnchecked(
        chunk: mostSignificantChunk, radix: radix, alphabet: alphabet) { first in
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * radix.exponent
            count += suffix.count
            return String(unsafeUninitializedCapacity: count) { utf8 in
                var position = utf8.baseAddress!.advanced(by: count)
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                func pull(_ unit: UInt8) {
                    position = position.predecessor()
                    position.initialize(to: unit)
                }
                //=------------------------------=
                suffix.reversed().forEach(pull)
                //=------------------------------=
                // dynamic: loop unswitch perf.
                //=------------------------------=
                if  radix.power.isZero {
                    let divisor = PerfectRadixSolution(radix)!.divisor()
                    for var chunk in remainders {
                        for _ in 0 as  UInt ..< radix.exponent {
                            let digit: UInt; (chunk, digit) = divisor.dividing(chunk)
                            pull(alphabet.encode(UInt8(truncatingIfNeeded:  digit))!)
                        }
                    }
                    
                }   else {
                    let divisor = ImperfectRadixSolution(radix)!.divisor()
                    for var chunk in remainders {
                        for _ in 0 as  UInt ..< radix.exponent {
                            let digit: UInt; (chunk, digit) = divisor.dividing(chunk)
                            pull(alphabet.encode(UInt8(truncatingIfNeeded:  digit))!)
                        }
                    }
                }
                //=------------------------------=
                first .reversed().forEach(pull)
                prefix.reversed().forEach(pull)
                //=------------------------------=
                assert(position == utf8.baseAddress!)
                return count as Int
            }
        }
    }
    
    /// Encodes an unchecked chunk, using the given UTF-8 format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    /// - Note: `@inlinable` is not needed.
    ///
    public static func withUnsafeTemporaryIntegerTextUnchecked<T>(
    chunk: UInt, radix: AnyRadixSolution<Int>, alphabet: MaxRadixAlphabetEncoder, body:(UnsafeUTF8) -> T) -> T {
        assert(radix.power.isZero || chunk < radix.power, "chunks must be less than radix's power")
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            var chunk = chunk as UInt
            let end   = utf8.baseAddress!.advanced(by: utf8.count)
            var position = end as UnsafeMutablePointer<UInt8>
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            let divisor = radix.divisor()
            backwards: repeat {
                let digit: UInt; (chunk, digit) = divisor.dividing(chunk)
                position = position.predecessor()
                position.initialize(to: alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
            }   while !chunk.isZero
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count: Int = position.distance(to: end)
            defer{ position.deinitialize(count:  count) }
            return body(NBK.UnsafeUTF8(start: position, count: count))
        }
    }
}
