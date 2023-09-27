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
    
    // TODO: documentation
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
            guard let magnitude: T.Magnitude = NBK.IntegerDescription.decode(digits: digits, radix: solution) else { return nil }
            return T(sign: components.sign, magnitude: magnitude)
        }
    }
    
    //*========================================================================*
    // MARK: * Decoder Decoding Radix
    //*========================================================================*
    
    // TODO: documentation
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
            let radix  = AnyRadixSolution<UInt>(components.radix)
            let digits = NBK.UnsafeUTF8(rebasing:components.body)
            guard  let magnitude: T.Magnitude = NBK.IntegerDescription.decode(digits: digits, radix: radix) else { return nil }
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
    digits: NBK.UnsafeUTF8, radix: AnyRadixSolution<UInt>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        switch radix.power.isZero {
        case  true: return self.decode(digits: digits, radix:   PerfectRadixSolution(radix)!)
        case false: return self.decode(digits: digits, radix: ImperfectRadixSolution(radix)!) }
    }
    
    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, radix: PerfectRadixSolution<UInt>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits    = digits.drop(while:{ $0 == 48 })
        let quotient  = digits.count &>> radix.exponent.trailingZeroBitCount
        let remainder = digits.count &   Int(bitPattern: radix.exponent - 1)
        let count = quotient &+ Int(bit: remainder.isMoreThanZero)
        //=--------------------------------------=
        guard Magnitude.maxBitWidth >= count * UInt.bitWidth else { return nil }
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) { words in
            var index = words.startIndex as Int
            let baseAddress = words.baseAddress!
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= words.endIndex)
                baseAddress.deinitialize(count:index)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            backwards: while index < quotient {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: Int(bitPattern: radix.exponent)))
                guard let word = self.truncating(digits: chunk, radix: Int(bitPattern: radix.base), as: UInt.self) else { return nil }
                
                baseAddress.advanced(by: index).initialize(to: word)
                words.formIndex(after:  &index)
            }
            
            backwards: if !remainder.isZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: remainder))
                guard let word = self.truncating(digits: chunk, radix: Int(bitPattern: radix.base), as: UInt.self) else { return nil }
                
                baseAddress.advanced(by: index).initialize(to: word)
                words.formIndex(after:  &index)
            }
            //=----------------------------------=
            Swift.assert(index == words.endIndex)
            return Magnitude(words: words)
        }
    }
    
    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, radix: ImperfectRadixSolution<UInt>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits   = digits.drop(while:{ $0 == 48 })
        let division = digits.count.quotientAndRemainder(dividingBy: Int(bitPattern: radix.exponent))
        let count = division.quotient &+ Int(bit: division.remainder.isMoreThanZero)
        //=--------------------------------------=
        guard Magnitude.maxBitWidth >= (count &- 1) * (UInt.bitWidth &+ radix.power.leadingZeroBitCount.onesComplement()) else { return nil }
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) {
            var words = $0 as NBK.UnsafeMutableWords
            var index = words.startIndex as Int
            let baseAddress = words.baseAddress!
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= words.endIndex)
                baseAddress.deinitialize(count:index)
            }
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            forwards: if !division.remainder.isZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: division.remainder))
                guard let word = self.truncating(digits: chunk, radix: Int(bitPattern: radix.base), as: UInt.self) else { return nil }
                baseAddress.advanced(by: index).initialize(to:  word)
                words.formIndex(after:  &index)
            }
            
            forwards: while !digits.isEmpty {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: Int(bitPattern: radix.exponent)))
                guard let word = self.truncating(digits: chunk, radix: Int(bitPattern: radix.base), as: UInt.self) else { return nil }
                let range = Range(uncheckedBounds:(words.startIndex, index))
                let carry = SUISS.multiplyFullWidth(&words,by:  radix.power, add: word, in: range)
                baseAddress.advanced(by: index).initialize(to:  carry)
                words.formIndex(after:  &index)
            }
            //=----------------------------------=
            Swift.assert(index == words.endIndex)
            return Magnitude(words: words)
        }
    }
}
