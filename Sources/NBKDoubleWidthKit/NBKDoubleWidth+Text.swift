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
// MARK: * NBK x Double Width x Text
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: some StringProtocol, radix: Int = 10) {
        var description = String(description)
        if  let value:Self = description.withUTF8({ utf8 in
            let components = NBK.makeIntegerComponents(utf8: utf8)
            let radix  = NBK.AnyRadixSolution<Int>(radix)
            let digits = NBK.UnsafeUTF8(rebasing: components.body)
            guard  let magnitude = Magnitude(digits: digits, radix: radix) else { return nil }
            return Self(sign: components.sign, magnitude: magnitude)
        }){ self = value } else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    @inlinable public func description(radix: Int = 10, uppercase: Bool = false) -> String {
        Swift.withUnsafePointer(to: UInt8(ascii: "-")) { minus in
            let radix  = NBK.AnyRadixSolution<Int>(radix)
            let alphabet = NBK.MaxRadixAlphabetEncoder(uppercase: uppercase)
            let prefix = NBK.UnsafeUTF8(start: minus, count: Int(bit: self.isLessThanZero))
            let suffix = NBK.UnsafeUTF8(start: nil,   count: 0 as Int)
            return self.magnitude.description(radix:  radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x Unsigned
//*============================================================================*

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode x Private
    //=------------------------------------------------------------------------=
    
    @inlinable init?(digits:  NBK.UnsafeUTF8, radix: NBK.AnyRadixSolution<Int>) {
        switch radix.power.isZero {
        case  true: self.init(digits: digits, radix: NBK  .PerfectRadixSolution(radix)!)
        case false: self.init(digits: digits, radix: NBK.ImperfectRadixSolution(radix)!) }
    }
    
    @inlinable init?(digits:  NBK.UnsafeUTF8, radix: NBK.PerfectRadixSolution<Int>) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        let quotient  = digits.count &>> radix.exponent.trailingZeroBitCount
        let remainder = digits.count &  (radix.exponent - 1)
        //=--------------------------------------=
        guard quotient + Int(bit:  remainder.isMoreThanZero) <= Self.count else { return nil }
        //=--------------------------------------=
        self.init()
        var index = self.startIndex
        
        backwards: while index < quotient {
            let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: radix.exponent))
            guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
            
            self[index] = word
            self.formIndex(after: &index)
        }
        
        backwards: if !remainder.isZero {
            let chunk = NBK.UnsafeUTF8(rebasing: NBK.removeSuffix(from: &digits, count: remainder))
            guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
            
            self[index] = word
            self.formIndex(after: &index)
        }
    }
    
    @inlinable init?(digits:  NBK.UnsafeUTF8, radix: NBK.ImperfectRadixSolution<Int>) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        let remainder = digits.count % radix.exponent
        //=--------------------------------------=
        self.init()
        
        forwards: if !remainder.isZero {
            let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: remainder))
            guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
            self.first = word
        }
        
        forwards: while !digits.isEmpty {
            let chunk = NBK.UnsafeUTF8(rebasing: NBK.removePrefix(from: &digits, count: radix.exponent))
            guard let word = NBK.truncating(digits: chunk, radix: radix.base, as: UInt.self) else { return nil }
            guard !self.multiplyReportingOverflow(by: radix.power, add: word) else { return nil }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode x Private
    //=------------------------------------------------------------------------=
    // NOTE: Both branches specialize NBKTwinHeaded<UnsafeBufferPointer<UInt>>.
    //=------------------------------------------------------------------------=
    
    @inlinable func description(
    radix:  NBK.AnyRadixSolution<Int>, alphabet: NBK.MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        switch radix.power.isZero {
        case  true: return self.description(radix: NBK  .PerfectRadixSolution(radix)!, alphabet: alphabet, prefix: prefix, suffix: suffix)
        case false: return self.description(radix: NBK.ImperfectRadixSolution(radix)!, alphabet: alphabet, prefix: prefix, suffix: suffix) }
    }
    
    @inlinable func description(
    radix:  NBK.PerfectRadixSolution<Int>, alphabet: NBK.MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        //=--------------------------------------=
        // with one buffer pointer specialization
        //=--------------------------------------=
        self.withUnsafeData(as: UInt.self) { data in
            let radix  = NBK.AnyRadixSolution(radix)
            let words  = NBKTwinHeaded(data, reversed: NBK.isBigEndian)
            let chunks = NBKTwinHeaded(rebasing:NBK.dropLast(from: words, while:{ $0.isZero }))
            return NBK.integerTextUnchecked(chunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
    
    @inlinable func description(
    radix:  NBK.ImperfectRadixSolution<Int>, alphabet: NBK.MaxRadixAlphabetEncoder,
    prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        //=--------------------------------------=
        // with one buffer pointer specialization
        //=--------------------------------------=
        let capacity: Int = radix.divisibilityByPowerUpperBound(self)
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { buffer in
            //=----------------------------------=
            var magnitude: Magnitude = self
            let start = buffer.baseAddress!
            var position = start as UnsafeMutablePointer<UInt>
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            rebasing: repeat {
                position.initialize(to: magnitude.formQuotientWithRemainderReportingOverflow(dividingBy: radix.power).partialValue)
                position = position.successor()
            } while !magnitude.isZero
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            let count = start.distance(to: position)
            defer { start.deinitialize(count: count) }
            //=----------------------------------=
            let radix  = NBK.AnyRadixSolution(radix)
            let chunks = NBKTwinHeaded(UnsafeBufferPointer( start: start, count: count))
            return NBK.integerTextUnchecked(chunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
}
