//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding
//*============================================================================*

extension NBK.IntegerDescription {
    
    //*========================================================================*
    // MARK: * Encoder
    //*========================================================================*
    
    /// An encoder encoding an integer description.
    ///
    /// The description may contain a minus sign (-), followed by one
    /// or more numeric digits (0-9) or letters (a-z or A-Z). These represent
    /// the integer's sign and magnitude. Zero is always non-negative.
    ///
    /// ```
    /// ┌──────────────┬───────┬─────────── → ────────────┐
    /// │ integer      │ radix │ uppercase  │ description │
    /// ├──────────────┼───────┼─────────── → ────────────┤
    /// │ Int256( 123) │ 12    │ true       │  "A3"       │
    /// │ Int256(-123) │ 16    │ false      │ "-7b"       │
    /// └──────────────┴───────┴─────────── → ────────────┘
    /// ```
    ///
    @frozen public struct Encoder {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let solution: AnyRadixSolution<UInt>
        @usableFromInline let alphabet: MaxRadixAlphabetEncoder
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(radix: Int, uppercase: Bool) {
            self.solution = AnyRadixSolution<UInt>(radix)
            self.alphabet = MaxRadixAlphabetEncoder(uppercase: uppercase)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func encode(_ integer: some NBKBinaryInteger) -> String {
            let isLessThanZero = integer.isLessThanZero as Bool
            return self.encode(magnitude: integer.magnitude.words, uncheckedIsLessThanZero: isLessThanZero)
        }
        
        @inlinable public func encode(sign: FloatingPointSign, magnitude: some RandomAccessCollection<UInt>) -> String {
            let isLessThanZero: Bool = sign == .minus && !magnitude.allSatisfy({ $0.isZero })
            return self.encode(magnitude: magnitude, uncheckedIsLessThanZero: isLessThanZero)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities x Private
        //=--------------------------------------------------------------------=
        
        @inlinable func encode(magnitude: some RandomAccessCollection<UInt>, uncheckedIsLessThanZero: Bool) -> String {
            Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: magnitude.count) {
                var copy = $0 as NBK.UnsafeMutableWords
                _ = copy.initialize(from: magnitude)
                defer{ copy.baseAddress!.deinitialize(count: magnitude.count) }
                return self.encode(magnitude: &copy, uncheckedIsLessThanZero: uncheckedIsLessThanZero)
            }
        }
        
        @usableFromInline func encode(magnitude: inout NBK.UnsafeMutableWords, uncheckedIsLessThanZero: Bool) -> String {
            Swift.assert(!uncheckedIsLessThanZero || !magnitude.allSatisfy({ $0.isZero }))
            return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 1 as Int) {
                let prefix = $0 as NBK.UnsafeMutableUTF8
                prefix.baseAddress!.initialize(to: UInt8(ascii: uncheckedIsLessThanZero ? "-" : "+"))
                defer{ prefix.baseAddress!.deinitialize(count: 1 as Int) }
                return NBK.IntegerDescription.encode(
                magnitude: &magnitude,
                solution: solution as AnyRadixSolution<UInt>,
                alphabet: alphabet as MaxRadixAlphabetEncoder,
                prefix: NBK.UnsafeUTF8(rebasing: prefix.prefix(Int(bit: uncheckedIsLessThanZero))),
                suffix: NBK.UnsafeUTF8(start: nil, count: 0 as Int))
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding x Algorithms
//*============================================================================*

extension NBK.IntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        if  solution.power.isZero {
            return self.encode(magnitude: &magnitude, solution: PerfectRadixSolution(solution)!,
            alphabet: alphabet, prefix: prefix, suffix: suffix)
        }   else {
            return self.encode(magnitude: &magnitude, solution: ImperfectRadixSolution(solution)!,
            alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
    
    @inlinable static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: PerfectRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        let chunks = NBK.UnsafeWords(rebasing: NBK.dropLast(from: magnitude, while:{ $0.isZero }))
        return self.encode(chunks: chunks, solution: AnyRadixSolution(solution), alphabet: alphabet, prefix: prefix, suffix: suffix)
    }
    
    @usableFromInline static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: ImperfectRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        let capacity = solution.divisibilityByPowerUpperBound(magnitude: magnitude)
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { chunks in
            var chunksIndex = chunks.startIndex
            var magnitudeEndIndex = magnitude.endIndex
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            rebasing: repeat {
                let chunk = SUISS.formQuotientWithRemainderReportingOverflow(
                &magnitude, dividingBy: solution.power,  in: ..<magnitudeEndIndex).partialValue
                magnitudeEndIndex = NBK.dropLast(from: magnitude, while:{ $0.isZero }).endIndex
                chunks.baseAddress!.advanced(by: chunksIndex).initialize(to: chunk)
                chunks.formIndex(after: &chunksIndex)
            }   while magnitudeEndIndex > magnitude.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                assert(chunksIndex <= chunks.endIndex)
                chunks.baseAddress!.deinitialize(count: chunksIndex)
            }
            //=----------------------------------=
            let solution = AnyRadixSolution(solution)
            let chunks = NBK.UnsafeWords(start: chunks.baseAddress!, count: chunksIndex)
            return self.encode(chunks: chunks, solution: solution, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
    
    /// Encodes unchecked chunks, using the given UTF-8 format.
    ///
    /// Each chunk must be a digit in the base of the given solution's power.
    ///
    /// ### Development
    ///
    /// - `@inlinable` is not required.
    ///
    @usableFromInline static func encode(
    chunks: NBK.UnsafeWords, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8,  suffix: NBK.UnsafeUTF8) -> String {
        //=--------------------------------------=
        Swift.assert(chunks.count <= 1     || chunks.last != 0, "chunks must not contain redundant zeros")
        Swift.assert(solution.power.isZero || chunks.allSatisfy({ $0 < solution.power }), "chunks must be less than solution's power")
        //=--------------------------------------=
        var remainders = chunks[...] as NBK.UnsafeWords.SubSequence
        let mostSignificantChunk = remainders.popLast() ?? 0 as UInt
        return self.withUnsafeTemporaryDescriptionCodeBlock(chunk: mostSignificantChunk, solution: solution, alphabet: alphabet) { first in
            //=----------------------------------=
            var count: Int
            count  = prefix.count
            count += first .count
            count += remainders.count * Int(bitPattern: solution.exponent)
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
                    let divisor = PerfectRadixSolution(solution)!.divisor()
                    for var chunk in remainders {
                        for _  in 0 as UInt ..< solution.exponent {
                            let digit: UInt; (chunk,digit) = divisor.dividing(chunk)
                            pull(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
                        }
                    }
                    
                }   else {
                    let divisor = ImperfectRadixSolution(solution)!.divisor()
                    for var chunk in remainders {
                        for _  in 0 as UInt ..< solution.exponent {
                            let digit: UInt; (chunk,digit) = divisor.dividing(chunk)
                            pull(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
                        }
                    }
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
    /// Each chunk must be a digit in the base of the given solution's power.
    ///
    @inlinable static func withUnsafeTemporaryDescriptionCodeBlock(
    chunk: UInt, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder, perform: (NBK.UnsafeUTF8) -> String) -> String {
        assert(solution.power.isZero || chunk < solution.power, "chunks must be less than solution's power")
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: Int(bitPattern: solution.exponent)) { utf8 in
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
            var chunk = chunk as UInt
            if  solution.power.isZero {
                let divisor = PerfectRadixSolution(solution)!.divisor()
                backwards: repeat {
                    let digit: UInt; (chunk,digit) = divisor.dividing(chunk)
                    pull(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
                }   while !chunk.isZero
                
            }   else {
                let divisor = ImperfectRadixSolution(solution)!.divisor()
                backwards: repeat {
                    let digit: UInt; (chunk,digit) = divisor.dividing(chunk)
                    pull(alphabet.encode(UInt8(truncatingIfNeeded: digit))!)
                }   while !chunk.isZero
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count: Int = position.distance(to: end)
            defer{ position.deinitialize (count: count) }
            return perform(NBK.UnsafeUTF8(start: position, count: count))
        }
    }
}
