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
    /// ### Development
    ///
    /// - `@inlinable` is not needed.
    ///
    public static func integerTextUnchecked(
    chunks: NBKTwinHeaded<NBK.UnsafeWords>, radix: AnyRadixSolution<Int>, alphabet: MaxRadixAlphabetEncoder,
    prefix: UnsafeUTF8, suffix: UnsafeUTF8) -> String {
        assert(chunks.count <= 1  || chunks.last != 0, "chunks must not contain redundant zeros")
        assert(radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        var remainders = chunks[...]
        let mostSignificantChunk = remainders.popLast() ?? 0 as UInt
        return NBK.withUnsafeTemporaryIntegerTextUnchecked(
        chunk: mostSignificantChunk, radix: radix, alphabet: alphabet) { first in
            //=----------------------------------=
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * radix.exponent
            count += suffix.count
            //=----------------------------------=
            return String(unsafeUninitializedCapacity: count) { utf8 in
                var position = utf8.baseAddress!.advanced(by: count)
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                func pull(_ element: UInt8) {
                    position = position.predecessor()
                    position.initialize(to:  element)
                }
                //=------------------------------=
                for index in suffix.indices.reversed() {
                    pull(suffix[index]) // loop: index > element
                }
                //=------------------------------=
                // dynamic: loop unswitching perf.
                //=------------------------------=
                if  radix.power.isZero {
                    NBK.integerTextSubsequenceReversedForEachCodeBlockUnchecked(
                    body: remainders, radix:   PerfectRadixSolution(radix)!, alphabet: alphabet, perform: pull)
                }   else {
                    NBK.integerTextSubsequenceReversedForEachCodeBlockUnchecked(
                    body: remainders, radix: ImperfectRadixSolution(radix)!, alphabet: alphabet, perform: pull)
                }
                //=------------------------------=
                for index in first .indices.reversed() {
                    pull(first [index]) // loop: index > element
                }
                
                for index in prefix.indices.reversed() {
                    pull(prefix[index]) // loop: index > element
                }
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
    /// ### Development
    ///
    /// - `@inlinable` is not needed.
    ///
    public static func withUnsafeTemporaryIntegerTextUnchecked<T>(
    chunk: UInt, radix: AnyRadixSolution<Int>, alphabet: MaxRadixAlphabetEncoder, body:(UnsafeUTF8) -> T) -> T {
        assert(radix.power.isZero || chunk < radix.power, "chunks must be less than radix's power")
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            let end = utf8.baseAddress!.advanced  (by: utf8.count)
            var position = end as UnsafeMutablePointer<UInt8>
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            func pull(_ element: UInt8) {
                position = position.predecessor()
                position.initialize(to:  element)
            }
            //=----------------------------------=
            // dynamic: loop unswitching perf.
            //=----------------------------------=
            if  radix.power.isZero {
                NBK.integerTextSubsequenceReversedForEachCodeBlockUnchecked(
                tail: chunk, radix:   PerfectRadixSolution(radix)!, alphabet: alphabet, perform: pull)
            }   else {
                NBK.integerTextSubsequenceReversedForEachCodeBlockUnchecked(
                tail: chunk, radix: ImperfectRadixSolution(radix)!, alphabet: alphabet, perform: pull)
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count: Int = position.distance(to: end)
            defer{ position.deinitialize(count:  count) }
            return body(UnsafeUTF8(start: position, count: count))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode x Code Blocks
    //=------------------------------------------------------------------------=
    
    /// Performs an action for each digit of a most-significant chunk.
    ///
    /// The digits appear from least significant to most and redundant zeros are excluded.
    ///
    /// ### Development
    ///
    /// The nested version performed poorly, so now it's freestanding with `@inline(always)`.
    ///
    @inline(__always) @inlinable static func integerTextSubsequenceReversedForEachCodeBlockUnchecked(
    tail: UInt, radix: some RadixSolution<Int>, alphabet: MaxRadixAlphabetEncoder, perform: (UInt8) -> Void) {
        assert(radix.power.isZero || tail <  radix.power, "chunks must be less than radix's power")
        //=--------------------------------------=
        var chunk = tail as UInt
        let division = radix.division()
        //=--------------------------------------=
        backwards: repeat {
            let digit: UInt; (chunk,digit) = division(chunk)
            perform(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
        }   while !chunk.isZero
    }
    
    /// Performs an action for each digit of non-most-significant chunks.
    ///
    /// The digits appear from least significant to most and redundant zeros are included.
    ///
    /// ### Development
    ///
    /// The nested version performed poorly, so now it's freestanding with `@inline(always)`.
    ///
    @inline(__always) @inlinable static func integerTextSubsequenceReversedForEachCodeBlockUnchecked(
    body: some Collection<UInt>, radix: some RadixSolution<Int>, alphabet: MaxRadixAlphabetEncoder, perform: (UInt8) -> Void) {
        assert(radix.power.isZero || body.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        let division = radix.division()
        //=--------------------------------------=
        for var chunk in body {
            for _  in 0 as UInt ..< radix.exponent {
                let digit: UInt; (chunk,digit) = division(chunk)
                perform(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
            }
        }
    }
}
