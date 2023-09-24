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
// MARK: * NBK x Integer Description x Encode
//*============================================================================*

extension NBKIntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: AnyRadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder,
    prefix: UnsafeBufferPointer<UInt8>, suffix: UnsafeBufferPointer<UInt8>) -> String {
        
        if  solution.power.isZero {
            let solution = PerfectRadixSolution(solution)!
            return self.encode(magnitude: &magnitude, solution: solution, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }   else {
            let solution = ImperfectRadixSolution(solution)!
            return self.encode(magnitude: &magnitude, solution: solution, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
    
    @inlinable static func encode(
    magnitude: inout UnsafeMutableBufferPointer<UInt>, solution: PerfectRadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder,
    prefix: UnsafeBufferPointer<UInt8>, suffix: UnsafeBufferPointer<UInt8>) -> String {
        
        let solution  = AnyRadixSolution(solution)
        let chunks = UnsafeBufferPointer(rebasing: NBK.dropLast(from:   magnitude, while:{ $0.isZero }))
        return self.encode(chunks: chunks, solution: solution, alphabet: alphabet, prefix: prefix, suffix: suffix)
    }
    
    @inlinable static func encode(
    magnitude: inout UnsafeMutableBufferPointer<UInt>, solution: ImperfectRadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder,
    prefix: UnsafeBufferPointer<UInt8>, suffix: UnsafeBufferPointer<UInt8>) -> String {
        //=--------------------------------------=
        // TODO: test that it works when empty
        //=--------------------------------------=
        let capacity = magnitude.count * UInt.bitWidth / 36.leadingZeroBitCount + 1
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { buffer in
            //=----------------------------------=
            let start = buffer.baseAddress!
            var position = start as UnsafeMutablePointer<UInt>
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            // TODO: normalizing division is more efficient
            //=----------------------------------=
            rebasing: repeat {
                let remainder = SUISS.formQuotientWithRemainderReportingOverflow(&magnitude, dividingBy: solution.power).partialValue
                position.initialize(to: remainder)
                position = position.successor()
            } while !magnitude.allSatisfy({ $0.isZero })
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count = start.distance(to: position)
            defer { start.deinitialize(count: count) }
            //=----------------------------------=
            let solution = AnyRadixSolution(solution)
            let chunks = UnsafeBufferPointer(start: start, count: count)
            return self.encode(chunks: chunks, solution: solution, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Algorithms
    //=------------------------------------------------------------------------=
    
    /// Encodes unchecked chunks, using the given UTF-8 format.
    ///
    /// In this context, a chunk is a digit in the base of the given solution's power.
    ///
    /// ### Development
    ///
    /// - `@inlinable` is not required.
    ///
    @usableFromInline static func encode(
    chunks: UnsafeBufferPointer<UInt>,  solution:  AnyRadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder,
    prefix: UnsafeBufferPointer<UInt8>, suffix: UnsafeBufferPointer<UInt8>) -> String {
        //=--------------------------------------=
        assert(chunks.count <= 1  || chunks.last != 0, "chunks must not contain redundant zeros")
        assert(solution.power.isZero || chunks.allSatisfy({ $0 < solution.power }), "chunks must be less than solution's power")
        //=--------------------------------------=
        var remainders = chunks[...]
        let mostSignificantChunk = remainders.popLast() ?? 0 as UInt
        return self.withUnsafeTemporaryDescriptionCodeBlock(chunk: mostSignificantChunk, solution: solution, alphabet: alphabet) { first in
            //=----------------------------------=
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * solution.exponent
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
                if  solution.power.isZero {
                    self.encodeSubSequenceReversedForEachCodeBlockUnchecked(
                    body: remainders, solution:   PerfectRadixSolution(solution)!, alphabet: alphabet, perform: pull)
                }   else {
                    self.encodeSubSequenceReversedForEachCodeBlockUnchecked(
                    body: remainders, solution: ImperfectRadixSolution(solution)!, alphabet: alphabet, perform: pull)
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
    /// In this context, a chunk is a digit in the base of the given solution's power.
    ///
    @inline(__always) @inlinable static func withUnsafeTemporaryDescriptionCodeBlock<T>(
    chunk: UInt, solution: AnyRadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder, body: (UnsafeBufferPointer<UInt8>) -> T) -> T {
        assert(solution.power.isZero || chunk < solution.power, "chunks must be less than solution's power")
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: solution.exponent) { utf8 in
            let end = utf8.baseAddress!.advanced(by: utf8.count)
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
            if  solution.power.isZero {
                self.encodeSubSequenceReversedForEachCodeBlockUnchecked(
                tail: chunk, solution:   PerfectRadixSolution(solution)!, alphabet: alphabet, perform: pull)
            }   else {
                self.encodeSubSequenceReversedForEachCodeBlockUnchecked(
                tail: chunk, solution: ImperfectRadixSolution(solution)!, alphabet: alphabet, perform: pull)
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count: Int = position.distance(to: end)
            defer{ position.deinitialize(count:  count) }
            return body(UnsafeBufferPointer(start: position, count: count))
        }
    }
    
    /// Performs an action for each digit of a most-significant chunk.
    ///
    /// The digits appear from least significant to most and redundant zeros are excluded.
    ///
    /// ### Development
    ///
    /// The nested version performed poorly, so now it's freestanding with `@inline(always)`.
    ///
    @inline(__always) @inlinable static func encodeSubSequenceReversedForEachCodeBlockUnchecked(
    tail: UInt, solution: some RadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder, perform: (UInt8) -> Void) {
        assert(solution.power.isZero || tail <  solution.power, "chunks must be less than solution's power")
        //=--------------------------------------=
        var chunk = tail as UInt
        let division = solution.division()
        //=--------------------------------------=
        backwards: repeat {
            let digit: UInt
            (chunk,digit) = division(chunk)
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
    @inline(__always) @inlinable static func encodeSubSequenceReversedForEachCodeBlockUnchecked(
    body: some Collection<UInt>, solution: some RadixSolution<Int>, alphabet: NBKIntegerDescriptionMaxAlphabetEncoder, perform: (UInt8) -> Void) {
        assert(solution.power.isZero || body.allSatisfy({ $0 < solution.power }), "chunks must be less than solution's power")
        //=--------------------------------------=
        let division = solution.division()
        //=--------------------------------------=
        for var chunk in body {
            for _  in 0 as UInt ..< solution.exponent {
                let digit: UInt
                (chunk,digit) = division(chunk)
                perform(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
            }
        }
    }
}
