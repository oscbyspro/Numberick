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
// MARK: * NBK x Double Width x Text x Radix
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: some StringProtocol, radix: Int = 10) {
        var description = String(description)
        
        let value: Optional<Self> = description.withUTF8 { utf8 in
            let (radix) = AnyRadixUIntRoot(radix)
            let (sign,body) = NBK.integerComponents(utf8: utf8)
            let (digits) = NBK.UnsafeUTF8(rebasing: body)
            let (magnitude) = Magnitude(digits: digits, radix: radix)
            return magnitude.flatMap({ Self.exactly(sign: sign, magnitude: $0) })
        }
        
        if let value { self = value } else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    @inlinable public func description(radix: Int = 10, uppercase: Bool = false) -> String {
        Swift.withUnsafePointer(to: UInt8(ascii: "-")) { minus in
            let radix = AnyRadixUIntRoot(radix)
            let alphabet = MaxRadixAlphabetEncoder(uppercase: uppercase)
            let prefix = NBK.UnsafeUTF8(start: minus, count: Int(bit: self.isLessThanZero))
            let suffix = NBK.UnsafeUTF8(start: nil,   count: Int.zero)
            return self.magnitude.description(radix:  radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode x Private
    //=------------------------------------------------------------------------=
    
    @inlinable init?(digits: NBK.UnsafeUTF8, radix: AnyRadixUIntRoot) {
        switch radix.power.isZero {
        case  true: self.init(digits: digits, radix:   PerfectRadixUIntRoot(unchecked: radix))
        case false: self.init(digits: digits, radix: ImperfectRadixUIntRoot(unchecked: radix)) }
    }
    
    @inlinable init?(digits: NBK.UnsafeUTF8, radix: PerfectRadixUIntRoot) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        //=--------------------------------------=
        var error = false
        let value = Self.uninitialized { value in
            for index in value.indices {
                if  digits.isEmpty {
                    value[index] = UInt.zero
                }   else {
                    let chunk = NBK.removeSuffix(from: &digits, maxLength: radix.exponent)
                    guard let word = UInt(digits: NBK.UnsafeUTF8(rebasing: chunk), radix: radix.base) else { return error = true }
                    value[index] = word
                }
            }
        }
        
        if !error, digits.isEmpty { self = value } else { return nil }
    }
    
    @inlinable init?(digits: NBK.UnsafeUTF8, radix: ImperfectRadixUIntRoot) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        var digits = digits.drop(while:{ $0 == 48 })
        let alignment = digits.count % radix.exponent
        //=--------------------------------------=
        self.init()
        guard let _ = { // this closure makes it 10% faster for some reason
            
            forwards: if !alignment.isZero {
                let chunk = NBK.removePrefix(from: &digits, count: alignment)
                guard let word = UInt(digits: NBK.UnsafeUTF8(rebasing: chunk), radix: radix.base) else { return nil }
                self.first = word
            }
            
            forwards: while !digits.isEmpty {
                let chunk = NBK.removePrefix(from: &digits, count: radix.exponent)
                guard let word = UInt(digits: NBK.UnsafeUTF8(rebasing: chunk), radix: radix.base) else { return nil }
                guard !self.multiplyReportingOverflow(by: radix.power) else { return nil }
                guard !self.addReportingOverflow(word)/*------------*/ else { return nil }
            }
            
        }() as Void? else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode x Private
    //=------------------------------------------------------------------------=
    
    @inlinable func description(radix: AnyRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        switch radix.power.isZero {
        case  true: return self.description(radix:   PerfectRadixUIntRoot(unchecked: radix), alphabet: alphabet, prefix: prefix, suffix: suffix)
        case false: return self.description(radix: ImperfectRadixUIntRoot(unchecked: radix), alphabet: alphabet, prefix: prefix, suffix: suffix) }
    }
    
    @inlinable func description(radix: PerfectRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        let index = self.lastIndex(where:{ !$0.isZero }) ?? self.startIndex
        let chunks: Words.SubSequence = self[...index]
        return String.fromUTF8Unchecked(chunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
    }
    
    @inlinable func description(radix: ImperfectRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8, suffix: NBK.UnsafeUTF8) -> String {
        let capacity: Int = radix.divisibilityByPowerUpperBound(self)
        return Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { buffer in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            var magnitude: Magnitude = self
            var index: Int = buffer.startIndex
            //=----------------------------------=
            rebasing: repeat {
                let (remainder, overflow) = magnitude.formQuotientWithRemainderReportingOverflow(dividingBy: radix.power)
                buffer[index] = remainder
                buffer.formIndex(after: &index)
                assert(!overflow)
            }   while !magnitude.isZero
            //=----------------------------------=
            let chunks  = NBK.UnsafeWords(rebasing: buffer[..<index])
            return String.fromUTF8Unchecked(chunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix, suffix: suffix)
        }
    }
}
