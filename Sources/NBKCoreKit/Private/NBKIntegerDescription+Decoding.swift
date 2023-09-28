//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding
//*============================================================================*

extension NBK.IntegerDescription {
    
    //*========================================================================*
    // MARK: * Decoder
    //*========================================================================*
    
    /// A decoder decoding an integer description.
    ///
    /// The description may contain a plus or minus sign (+ or -), followed by one
    /// or more numeric digits (0-9) or letters (a-z or A-Z). If the description uses
    /// an invalid format, or its value cannot be represented, the result is nil.
    ///
    /// ```
    /// ┌─────────────┬────── → ─────────────┐
    /// │ description │ radix │ integer      │
    /// ├─────────────┼────── → ─────────────┤
    /// │  "123"      │ 16    │ Int256( 291) │
    /// │ "+123"      │ 16    │ Int256( 291) │
    /// │ "-123"      │ 16    │ Int256(-291) │
    /// │ "~123"      │ 16    │ nil          │
    /// └─────────────┴────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @frozen public struct Decoder {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let solution: AnyRadixSolution<UInt>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(radix: Int) {
            self.solution = AnyRadixSolution(radix)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: some StringProtocol, as type: T.Type = T.self) -> T? {
            var description = String(description); return description.withUTF8({ self.decode($0) })
        }
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: StaticString, as type: T.Type = T.self) -> T? {
            description.withUTF8Buffer({ self.decode($0) })
        }
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: NBK.UnsafeUTF8, as type: T.Type = T.self) -> T? {
            let components = NBK.IntegerDescription.makeSignBody(from: description)
            let digits = NBK.UnsafeUTF8(rebasing: components.body)
            guard let magnitude: T.Magnitude = NBK.IntegerDescription.decode(digits: digits, solution: self.solution) else { return nil }
            return T(sign: components.sign, magnitude: magnitude)
        }
    }
    
    //*========================================================================*
    // MARK: * Decoder Decoding Radix
    //*========================================================================*
    
    /// A decoder decoding an integer description by decoding the radix.
    ///
    /// The description may contain a plus or minus sign (+ or -), followed by
    /// an optional radix indicator (0b, 0o or 0x), then one or more numeric digits
    /// (0-9) or letters (a-z or A-Z). If the description uses an invalid format,
    /// or its value cannot be represented, the result is nil.
    ///
    /// ```
    /// ┌──────────── → ─────────────┐
    /// │ description │ integer      │
    /// ├──────────── → ─────────────┤
    /// │    "123"    │ Int256( 123) │
    /// │ "+0x123"    │ Int256( 291) │
    /// │ "-0x123"    │ Int256(-291) │
    /// │ "~OX123"    │ nil          │
    /// └──────────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @frozen public struct DecoderDecodingRadix {
            
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() { }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: some StringProtocol, as type: T.Type = T.self) -> T? {
            var description = String(description)
            return description.withUTF8({ self.decode($0) })
        }
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: StaticString, as type: T.Type = T.self) -> T? {
            description.withUTF8Buffer({ self.decode($0) })
        }
        
        @inlinable public func decode<T: NBKBinaryInteger>(
        _   description: NBK.UnsafeUTF8, as type: T.Type = T.self) -> T? {
            let components = NBK.IntegerDescription.makeSignRadixBody(from: description)
            let solution = AnyRadixSolution<UInt>(components.radix)
            let digits = NBK.UnsafeUTF8(rebasing: components.body )
            guard  let magnitude: T.Magnitude = NBK.IntegerDescription.decode(digits: digits, solution: solution) else { return nil }
            return T(sign: components.sign, magnitude: magnitude)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Algorithms
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBK.IntegerDescription {
    
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
    /// ### Development
    ///
    /// Creating a new decoder is faster than passing one by argument.
    ///
    @inlinable public static func truncating<Digit: NBKCoreInteger>(
    digits: NBK.UnsafeUTF8, radix: Int, as type: Digit.Type = Digit.self) -> Digit? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        let alphabet = AnyRadixAlphabetDecoder(radix: radix)
        //=--------------------------------------=
        var value = Digit.zero
        let multiplicand = NBK.initOrBitCast(truncating: radix, as: Digit.self)
        //  all core integers can represent the range 2 ... 36
        
        for digit in  digits {
            guard let addend = alphabet.decode(digit) else { return nil }
            value &*= multiplicand
            value &+= NBK.initOrBitCast(truncating: addend, as: Digit.self)
            //  all core integers can represent the range 0 ..< 36
        }
        
        return value as Digit
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBK.IntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, solution: AnyRadixSolution<UInt>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        var magnitude: Magnitude?
        
        if  solution.power.isZero {
            self.decode(digits: digits, solution:   PerfectRadixSolution(solution)!) { magnitude = Magnitude(words: $0) }
        }   else {
            self.decode(digits: digits, solution: ImperfectRadixSolution(solution)!) { magnitude = Magnitude(words: $0) }
        }
        
        return magnitude as Magnitude?
    }
    
    @usableFromInline static func decode(
    digits: NBK.UnsafeUTF8, solution: PerfectRadixSolution<UInt>, perform: (NBK.UnsafeWords) -> Void) -> Void? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits    = digits.drop(while:{ $0 == 48 })
        let quotient  = digits.count &>> solution.exponent.trailingZeroBitCount
        let remainder = digits.count &   Int(bitPattern: solution.exponent &- 1)
        let count = quotient &+ Int(bit: remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) { words in
            var wordsIndex: Int = words.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(wordsIndex <= count)
                words.baseAddress!.deinitialize(count: wordsIndex)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            backwards: while wordsIndex < quotient {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: Int(bitPattern: solution.exponent)))
                guard let element: UInt = self.truncating(digits: chunk, radix: Int(bitPattern: solution.base)) else { return nil }
                words.baseAddress!.advanced(by: wordsIndex).initialize(to: element)
                words.formIndex(after: &wordsIndex)
            }
            
            backwards: if !remainder.isZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: remainder))
                guard let element: UInt = self.truncating(digits: chunk, radix: Int(bitPattern: solution.base)) else { return nil }
                words.baseAddress!.advanced(by: wordsIndex).initialize(to: element)
                words.formIndex(after: &wordsIndex)
            }
            
            Swift.assert(digits.isEmpty)
            Swift.assert(wordsIndex == (count))
            perform(UnsafeBufferPointer(words))
        }
    }
    
    @usableFromInline static func decode(
    digits: NBK.UnsafeUTF8, solution: ImperfectRadixSolution<UInt>, perform: (NBK.UnsafeWords) -> Void) -> Void? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits   = digits.drop(while:{ $0 == 48 })
        let division = digits.count.quotientAndRemainder(dividingBy: Int(bitPattern: solution.exponent))
        let count = division.quotient &+ Int(bit: division.remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) {
            var words: NBK.UnsafeMutableWords = $0
            var wordsIndex: Int = words.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(wordsIndex <= count)
                words.baseAddress!.deinitialize(count: wordsIndex)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            forwards: if division.remainder.isMoreThanZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: division.remainder))
                guard let element: UInt = self.truncating(digits: chunk, radix: Int(bitPattern:  solution.base)) else { return nil }
                words.baseAddress!.advanced(by: wordsIndex).initialize(to: element)
                words.formIndex(after: &wordsIndex)
            }
            
            forwards: while wordsIndex < count {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: Int(bitPattern: solution.exponent)))
                guard let element: UInt = self.truncating(digits: chunk, radix: Int(bitPattern:  solution.base)) else { return nil }
                let carry = NBK.SUISS.multiplyFullWidth(&words, by: solution.power, add: element, in: ..<wordsIndex)
                words.baseAddress!.advanced(by: wordsIndex).initialize(to: carry)
                words.formIndex(after: &wordsIndex)
            }
            
            Swift.assert(digits.isEmpty)
            Swift.assert(wordsIndex == (count))
            perform(UnsafeBufferPointer(words))
        }
    }
}
