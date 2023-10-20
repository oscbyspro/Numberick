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
            self.solution = AnyRadixSolution<UInt>.init(radix)
            self.alphabet = MaxRadixAlphabetEncoder(uppercase: uppercase)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func encode(_ integer: some NBKBinaryInteger) -> String {
            let isLessThanZero = integer.isLessThanZero
            return NBK.withUnsafeTemporaryAllocation(copying: integer.magnitude.words) {
                NBK.IntegerDescription.encode(
                magnitude: &$0,
                solution: self.solution as AnyRadixSolution<UInt>,
                alphabet: self.alphabet as MaxRadixAlphabetEncoder,
                minus:   isLessThanZero as Bool)
            }
        }
        
        @inlinable public func encode(_ components: SM<some NBKUnsignedInteger>) -> String {
            let isLessThanZero = NBK.ISM.isLessThanZero(components)
            return NBK.withUnsafeTemporaryAllocation(copying: components.magnitude.words) {
                NBK.IntegerDescription.encode(
                magnitude: &$0,
                solution: self.solution as AnyRadixSolution<UInt>,
                alphabet: self.alphabet as MaxRadixAlphabetEncoder,
                minus:   isLessThanZero as Bool)
            }
        }
        
        @_disfavoredOverload @inlinable public func encode(_ components: SM<some RandomAccessCollection<UInt>>) -> String {
            let isLessThanZero = NBK.SSMSS.isLessThanZero(components)
            return NBK.withUnsafeTemporaryAllocation(copying: components.magnitude) {
                NBK.IntegerDescription.encode(
                magnitude: &$0,
                solution: self.solution as AnyRadixSolution<UInt>,
                alphabet: self.alphabet as MaxRadixAlphabetEncoder,
                minus:   isLessThanZero as Bool)
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
    
    /// Encodes the magnitude, with or without a minus sign, using the given UTF-8 format.
    ///
    /// ### Development
    ///
    /// - `@inlinable` is not required (nongeneric algorithm).
    ///
    @usableFromInline static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    minus: Bool) -> String {
        NBK.IntegerDescription.withUnsafeTemporarySignPrefix(minus: minus) { prefix in
            NBK.IntegerDescription.encode(
            magnitude: &magnitude,
            solution: solution as AnyRadixSolution<UInt>,
            alphabet: alphabet as MaxRadixAlphabetEncoder,
            prefix: prefix as  UnsafeBufferPointer<UInt8>,
            suffix: UnsafeBufferPointer<UInt8>(start: nil, count: 0 as Int))
        }
    }
    
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
        return self.encode(
        chunks:   UnsafeBufferPointer(rebasing: NBK.dropLast(from: magnitude, while:{ $0.isZero })),
        solution: AnyRadixSolution(solution),
        alphabet: alphabet  as MaxRadixAlphabetEncoder,
        prefix:   prefix as UnsafeBufferPointer<UInt8>,
        suffix:   suffix as UnsafeBufferPointer<UInt8>)
    }
    
    /// ### Development
    ///
    /// - `@inlinable` is not required (nongeneric algorithm).
    ///
    @usableFromInline static func encode(
    magnitude: inout NBK.UnsafeMutableWords, solution: ImperfectRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        let capacity: Int = solution.divisibilityByPowerUpperBound(magnitude: magnitude)
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) {
            let chunked = NBK.unwrapping($0)!
            var pointer = chunked.baseAddress
            var magnitude = magnitude[...]
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            rebasing: while !magnitude.isEmpty {
                let chunk = NBK.SUISS.formQuotientWithRemainder(dividing: &magnitude, by: solution.power)
                magnitude = NBK.dropLast(from: magnitude, while:{ $0.isZero })
                pointer.initialize(to: chunk)
                pointer = pointer.successor()
            }
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count = chunked.baseAddress.distance(to: pointer)
            defer{ chunked.baseAddress.deinitialize(count: count) }
            return self.encode(
            chunks:   UnsafeBufferPointer(start: chunked.baseAddress, count: count),
            solution: AnyRadixSolution(solution),
            alphabet: alphabet  as MaxRadixAlphabetEncoder,
            prefix:   prefix as UnsafeBufferPointer<UInt8>,
            suffix:   suffix as UnsafeBufferPointer<UInt8>)
        }
    }
    
    /// Encodes unchecked chunks, using the given UTF-8 format.
    ///
    /// Each chunk must be a digit in the base of the given solution's power.
    ///
    /// ### Development
    ///
    /// - `@inlinable` is not required (nongeneric algorithm).
    ///
    @usableFromInline static func encode(
    chunks: NBK.UnsafeWords, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8,  suffix: NBK.UnsafeUTF8) -> String {
        //=--------------------------------------=
        Swift.assert(chunks.count <= 1 || chunks.last != 0,
        "chunk sequence must not contain redundant zeros")
        
        Swift.assert(solution.power.isZero || chunks.allSatisfy({ $0 < solution.power }), 
        "each chunk must be less than the radix solution's power")
        //=--------------------------------------=
        var remainders = chunks[...] as NBK.UnsafeWords.SubSequence
        let high = remainders.popLast() ?? 0 as UInt
        return self.withUnsafeTemporaryDescription(chunk: high, solution: solution, alphabet: alphabet) { first in
            //=----------------------------------=
            var count: Int
            count  = prefix.count
            count += first .count
            count += Int(bitPattern: solution.exponent) * remainders.count
            count += suffix.count
            //=----------------------------------=
            return String(unsafeUninitializedCapacity: count) {
                let ascii = NBK.unwrapping($0)!
                var pointer = ascii.baseAddress.advanced(by: count)
                //=------------------------------=
                // pointee: initialization
                //=------------------------------=
                func pull(_ element: UInt8) {
                    pointer = pointer.predecessor()
                    pointer.initialize(to: element)
                }
                //=------------------------------=
                for i in suffix.indices.reversed() {
                    pull(suffix[i])
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
                for i in first .indices.reversed() {
                    pull(first [i])
                }
                
                for i in prefix.indices.reversed() {
                    pull(prefix[i])
                }
                //=------------------------------=
                Swift.assert(pointer == ascii.baseAddress)
                return count as Int
            }
        }
    }
    
    /// Encodes an unchecked chunk, using the given UTF-8 format.
    ///
    /// Each chunk must be a digit in the base of the given solution's power.
    ///
    /// ### Development
    ///
    /// - `@inlinable` is not required (nongeneric algorithm).
    ///
    @usableFromInline static func withUnsafeTemporaryDescription(
    chunk: UInt, solution: AnyRadixSolution<UInt>, alphabet: MaxRadixAlphabetEncoder, 
    perform: (NBK.UnsafeUTF8) -> String) -> String {
        //=--------------------------------------=
        Swift.assert(solution.power.isZero || chunk < solution.power,
        "each chunk must be less than the radix solution's power")
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: Int(bitPattern: solution.exponent)) {
            let ascii = NBK.unwrapping($0)!
            let limit = ascii.baseAddress.advanced(by: ascii.count)
            var pointer = limit as UnsafeMutablePointer<UInt8>
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            func pull(_ element: UInt8) {
                pointer = pointer.predecessor()
                pointer.initialize(to: element)
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
            let count = pointer.distance(to:   limit)
            defer{ pointer.deinitialize(count: count) }
            return perform(UnsafeBufferPointer(start: pointer, count: count))
        }
    }
}
