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
        let value: Optional<Self> = description.withUTF8 {
            let (sign, body) =  NBK.components(ascii: $0)
            guard let magnitude = Magnitude(digits: body, radix: radix) else { return nil }
            return NBK.exactly(sign: sign, magnitude: magnitude) as Optional<Self>
        }
        
        if let value { self = value } else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    @inlinable public func description(radix: Int = 10, uppercase: Bool = false) -> String {
        Swift.withUnsafePointer(to: UInt8(ascii: "-")) { minus in
            let prefix =  UnsafeBufferPointer(start: minus, count: Int(bit: self.isLessThanZero))
            return self.magnitude.description(radix: radix, uppercase: uppercase, prefix: prefix)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: Int) {
        self.init(digits: digits, radix: AnyRadixUIntRoot(radix))
    }
    
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: AnyRadixUIntRoot) {
        switch radix.power.isZero {
        case  true: self.init(digits: digits, radix:   PerfectRadixUIntRoot(unchecked: radix))
        case false: self.init(digits: digits, radix: ImperfectRadixUIntRoot(unchecked: radix)) }
    }
    
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: PerfectRadixUIntRoot) {
        var digits = digits.drop(while:{ $0 == 48 })
        //=--------------------------------------=
        self.init()
        var index: Int = self.startIndex
        
        backwards: while !digits.isEmpty {
            guard index < self.endIndex else { return nil }
            let chunk = digits.suffix(radix.exponent)
            digits    = digits.prefix(upTo: chunk.startIndex)
            
            guard let word = UInt(digits: UnsafeBufferPointer(rebasing: chunk), radix: radix.base) else { return nil }

            self[index] = word
            self.formIndex(after: &index)
        }
    }
    
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: ImperfectRadixUIntRoot) {
        var digits = digits.drop(while:{ $0 == 48 })
        let alignment = digits.count % radix.exponent
        //=--------------------------------------=
        self.init()
        
        forwards: if !alignment.isZero {
            let chunkEndIndex = digits.startIndex &+ alignment
            let chunk = digits.prefix(upTo: chunkEndIndex)
            digits    = digits.suffix(from: chunkEndIndex)
            
            guard let word = UInt(digits: UnsafeBufferPointer(rebasing: chunk), radix: radix.base) else { return nil }
            self.first = word // self = (self * radix.power) + word, because self == 0
        }
        
        forwards: while !digits.isEmpty {
            let chunkEndIndex = digits.startIndex &+ radix.exponent
            let chunk = digits.prefix(upTo: chunkEndIndex)
            digits    = digits.suffix(from: chunkEndIndex)

            guard let word = UInt(digits: UnsafeBufferPointer(rebasing: chunk), radix: radix.base) else { return nil }
            guard !self.multiplyReportingOverflow(by: radix.power) else { return nil }
            guard !self.addReportingOverflow(word)/*------------*/ else { return nil }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    @inlinable internal func description(radix: Int, uppercase: Bool, prefix: UnsafeBufferPointer<UInt8>) -> String {
        self.description(radix: AnyRadixUIntRoot(radix), alphabet: MaxRadixAlphabetEncoder(uppercase: uppercase), prefix: prefix)
    }

    @inlinable internal func description(radix: AnyRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeBufferPointer<UInt8>) -> String {
        switch radix.power.isZero {
        case  true: return self.description(radix:   PerfectRadixUIntRoot(unchecked: radix), alphabet: alphabet, prefix: prefix)
        case false: return self.description(radix: ImperfectRadixUIntRoot(unchecked: radix), alphabet: alphabet, prefix: prefix) }
    }

    @inlinable internal func description(radix: PerfectRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeBufferPointer<UInt8>) -> String {
        let minLastIndex: Int = self.minLastIndexReportingIsZeroOrMinusOne().minLastIndex
        let chunks: Words.SubSequence = self[...minLastIndex]
        return String.fromUTF8(uncheckedChunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix)
    }

    @inlinable internal func description(radix: ImperfectRadixUIntRoot, alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeBufferPointer<UInt8>) -> String {
        let capacity: Int = radix.divisibilityByPowerUpperBound(self)
        return  Swift.withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { buffer in
            var magnitude = self
            var index = buffer.startIndex
            
            rebasing: repeat {
                let (remainder, overflow) = magnitude.formQuotientReportingRemainderAndOverflow(dividingBy: radix.power)
                buffer[index] = remainder
                buffer.formIndex(after: &index)
                assert(!overflow)
            }   while !magnitude.isZero
            
            let chunks = UnsafeBufferPointer(rebasing: buffer[..<index])
            return String.fromUTF8(uncheckedChunks: chunks, radix: radix, alphabet: alphabet, prefix: prefix)
        }
    }
}
