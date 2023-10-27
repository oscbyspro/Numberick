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
    @frozen public struct Decoder<Magnitude: NBKUnsignedInteger> {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let radix: AnyRadixSolution<UInt>
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(radix: Int) {
            self.radix = AnyRadixSolution(radix)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode(_ description: StaticString) -> SM<Magnitude>? {
            description.withUTF8Buffer(self.decode)
        }
        
        @inlinable public func decode(_ description: some StringProtocol) -> SM<Magnitude>? {
            var description = String(description); return description.withUTF8(self.decode)
        }
        
        @inlinable public func decode(_ description: UnsafeBufferPointer<UInt8>) -> SM<Magnitude>? {
            let inputs = NBK.IntegerDescription.makeSignBody(from: description)
            let digits = UnsafeBufferPointer(rebasing: inputs.body)
            guard  let magnitude: Magnitude = NBK.IntegerDescription.decode(digits: digits, radix: self.radix) else { return nil }
            return SM(sign: inputs.sign, magnitude: magnitude)
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
    @frozen public struct DecoderDecodingRadix<Magnitude> where Magnitude: NBKUnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init() { }

        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode(_ description: StaticString) -> SM<Magnitude>? {
            description.withUTF8Buffer(self.decode)
        }
        
        @inlinable public func decode(_ description: some StringProtocol) -> SM<Magnitude>? {
            var description = String(description); return description.withUTF8(self.decode)
        }
        
        @inlinable public func decode(_ description: UnsafeBufferPointer<UInt8>) -> SM<Magnitude>? {
            let inputs = NBK.IntegerDescription.makeSignRadixBody(from: description)
            let radix  = NBK.IntegerDescription.AnyRadixSolution<UInt>(inputs.radix)
            let digits = UnsafeBufferPointer(rebasing: inputs.body)
            guard  let magnitude: Magnitude = NBK.IntegerDescription.decode(digits: digits, radix: radix) else { return nil }
            return SM(sign: inputs.sign, magnitude: magnitude)
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
    digits: UnsafeBufferPointer<UInt8>, radix: Int, as type: Digit.Type = Digit.self) -> Digit? {
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
    digits: UnsafeBufferPointer<UInt8>, radix: AnyRadixSolution<UInt>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        var magnitude: Magnitude?
        
        if  radix.power.isZero {
            self.decode(digits: digits, radix:   PerfectRadixSolution(radix)!, success:{ magnitude = Magnitude(words: $0) })
        }   else {
            self.decode(digits: digits, radix: ImperfectRadixSolution(radix)!, success:{ magnitude = Magnitude(words: $0) })
        }
        
        return magnitude as Magnitude?
    }
    
    @usableFromInline static func decode(
    digits: UnsafeBufferPointer<UInt8>, radix: PerfectRadixSolution<UInt>, success: (UnsafeBufferPointer<UInt>) -> Void) {
        //=--------------------------------------=
        guard !digits.isEmpty else { return }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        let split  = NBK.PBI.dividing(NBK.ZeroOrMore(unchecked: digits.count), by: NBK.PowerOf2(unchecked: radix.exponent()))
        let count  = split.quotient &+ Int(bit: split.remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) {
            let words: UnsafeMutableBufferPointer<UInt> = $0
            var index: Int = words.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= count)
                words.baseAddress!.deinitialize(count: index)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            backwards: while index < split.quotient {
                let chunk = UnsafeBufferPointer(rebasing: NBK.removeSuffix(from: &digits, count: radix.exponent()))
                guard let element: UInt = self.truncating(digits: chunk, radix: radix.base()) else { return }
                words.baseAddress!.advanced(by: index).initialize(to: element)
                words.formIndex(after: &index)
            }
            
            backwards: if split.remainder.isMoreThanZero {
                let chunk = UnsafeBufferPointer(rebasing: NBK.removeSuffix(from: &digits, count: split.remainder))
                guard let element: UInt = self.truncating(digits: chunk, radix: radix.base()) else { return }
                words.baseAddress!.advanced(by: index).initialize(to: element)
                words.formIndex(after: &index)
            }
            
            Swift.assert(digits.isEmpty)
            Swift.assert(index == count)
            success(UnsafeBufferPointer(words))
        }
    }
    
    @usableFromInline static func decode(
    digits: UnsafeBufferPointer<UInt8>, radix: ImperfectRadixSolution<UInt>, success: (UnsafeBufferPointer<UInt>) -> Void) {
        //=--------------------------------------=
        guard !digits.isEmpty else { return }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        let split  = digits.count.quotientAndRemainder(dividingBy: radix.exponent())
        let count  = split.quotient &+ Int(bit: split.remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) {
            var words: UnsafeMutableBufferPointer<UInt> = $0
            var index: Int = words.startIndex
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= count)
                words.baseAddress!.deinitialize(count: index)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            forwards: if split.remainder.isMoreThanZero {
                let chunk = UnsafeBufferPointer(rebasing: NBK.removePrefix(from: &digits, count: split.remainder))
                guard let element: UInt = self.truncating(digits: chunk, radix: radix.base()) else { return }
                words.baseAddress!.advanced(by: index).initialize(to: element)
                words.formIndex(after: &index)
            }
            
            forwards: while index < count {
                let chunk = UnsafeBufferPointer(rebasing: NBK.removePrefix(from: &digits, count: radix.exponent()))
                guard let element: UInt = self.truncating(digits: chunk, radix: radix.base()) else { return }
                words.baseAddress!.advanced(by: index).initialize(to: NBK.SUISS.multiply(&words[..<index], by: radix.power, add: element))
                words.formIndex(after: &index)
            }
            
            Swift.assert(digits.isEmpty)
            Swift.assert(index == count)
            success(UnsafeBufferPointer(words))
        }
    }
}
