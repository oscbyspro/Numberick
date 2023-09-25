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
// MARK: * NBK x Integer Description x Decode
//*============================================================================*

extension NBKIntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func decode<Integer: NBKBinaryInteger>(
    _ description: NBK.UnsafeUTF8, radix: AnyRadixSolution<Int>) -> Integer? {
        let components = NBK.makeIntegerComponents(utf8: description)
        let radix  = AnyRadixSolution<Int>(radix)
        let digits = NBK.UnsafeUTF8(rebasing: components.body)
        guard let magnitude: Integer.Magnitude = self.decode(digits: digits, radix: radix) else { return nil }
        return Integer(sign: components.sign, magnitude: magnitude)
    }
    
    @inlinable static func decodeByDecodingRadix<Integer: NBKBinaryInteger>(
    _ description: NBK.UnsafeUTF8) -> Integer? {
        let components = NBK.makeIntegerComponentsByDecodingRadix(utf8: description)
        let radix  = AnyRadixSolution<Int>(components.radix)
        let digits = NBK.UnsafeUTF8(rebasing: components.body)
        guard let magnitude: Integer.Magnitude = self.decode(digits: digits, radix: radix) else { return nil }
        return Integer(sign: components.sign, magnitude: magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decode x Unsigned
//*============================================================================*

extension NBKIntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, radix: AnyRadixSolution<Int>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        switch radix.power.isZero {
        case  true: return self.decode(digits: digits, radix:   PerfectRadixSolution(radix)!)
        case false: return self.decode(digits: digits, radix: ImperfectRadixSolution(radix)!) }
    }

    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, radix: PerfectRadixSolution<Int>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        // TODO: breaking fixed-width early would be nice
        //=--------------------------------------=
        var digits    = digits.drop(while:{ $0 == 48 })
        let quotient  = digits.count &>> radix.exponent.trailingZeroBitCount
        let remainder = digits.count &  (radix.exponent - 1)
        let count = quotient &+ Int(bit: remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: count) { words in
            var index = words.startIndex as Int
            let baseAddress = words.baseAddress!
            //=----------------------------------=
            // pointee: de/initialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= words.endIndex)
                baseAddress.deinitialize(count:index)
            }
            
            backwards: while index < quotient {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: radix.exponent))
                guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
                
                baseAddress.advanced(by: index).initialize(to: word)
                words.formIndex(after:  &index)
            }

            backwards: if !remainder.isZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: remainder))
                guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }

                baseAddress.advanced(by: index).initialize(to: word)
                words.formIndex(after:  &index)
            }
            //=----------------------------------=
            Swift.assert(index == words.endIndex)
            return Magnitude(words: words)
        }
    }
    
    @inlinable static func decode<Magnitude: NBKUnsignedInteger>(
    digits: NBK.UnsafeUTF8, radix: ImperfectRadixSolution<Int>, as type: Magnitude.Type = Magnitude.self) -> Magnitude? {
        //=--------------------------------------=
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        // TODO: breaking fixed-width early would be nice
        //=--------------------------------------=
        var digits   = digits.drop(while:{ $0 == 48 })
        let division = digits.count.quotientAndRemainder(dividingBy: radix.exponent)
        let capacity = division.quotient &+ Int(bit: division.remainder.isMoreThanZero)
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) {
            var words = $0 as NBK.UnsafeMutableWords
            var index = words.startIndex as Int
            let baseAddress = words.baseAddress!
            //=----------------------------------=
            // pointee: de/initialization
            //=----------------------------------=
            defer {
                Swift.assert(index <= words.endIndex)
                baseAddress.deinitialize(count:index)
            }
            
            forwards: if !division.remainder.isZero {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: division.remainder))
                guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
                baseAddress.advanced(by: index).initialize(to: word)
                words.formIndex(after:  &index)
            }
            
            forwards: while !digits.isEmpty {
                let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: radix.exponent))
                guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
                let carry = SUISS.multiplyFullWidth(&words, by: radix.power, add: word, upTo: index)
                baseAddress.advanced(by: index).initialize(to: carry)
                words.formIndex(after:  &index)
            }
            //=----------------------------------=
            Swift.assert(index == words.endIndex)
            return Magnitude(words: words)
        }
    }
}
