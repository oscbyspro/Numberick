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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The description of this type.
    ///
    /// ```swift
    /// DoubleWidth< Int128>.description //  "Int256"
    /// DoubleWidth<UInt256>.description // "UInt512"
    /// ```
    ///
    @inlinable public static var description: String {
        let signedness = !Self.isSigned ? "U" : ""
        return "\(signedness)Int\(Self.bitWidth)"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(self, radix: 10)
    }
    
    @inlinable public var debugDescription: String {
        self.withUnsafeWords { words in
            let body = words.lazy.map(String.init).joined(separator: ", ")
            return "\(Self.description)(\(body))"
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x Decode
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decodeBigEndianText(_ source: some StringProtocol, radix: Int?) -> Self? {
        let components = source._bigEndianTextComponents(radix: radix)
        let magnitude  = AnyRadixUIntRoot(components.radix).switch(
          perfect:{ Magnitude._decodeBigEndianDigits(components.body, radix: $0) },
        imperfect:{ Magnitude._decodeBigEndianDigits(components.body, radix: $0) })
        if let magnitude, let value = Self(sign: components.sign, magnitude: magnitude) { return value } else { return nil }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func _decodeBigEndianDigits(_ source: some StringProtocol, radix: PerfectRadixUIntRoot) -> Self? {
        Self.fromUnsafeMutableWordsAsOptional { magnitude in
            for index in magnitude.indices {
                magnitude[index] = UInt()
            }
            //=----------------------------------=
            let utf8  = source.utf8.drop(while:{ $0 == 48 })
            let start = utf8.startIndex as String.Index
            var tail  = utf8.endIndex   as String.Index
            var index = magnitude.startIndex as Int
            let step  = radix.exponent.twosComplement() as Int
            //=----------------------------------=
            backwards: while tail != start {
                guard index != magnitude.endIndex else { return nil }
                let head = utf8.index(tail, offsetBy: step,  limitedBy:  start) ?? start
                guard let word = UInt(source[head ..< tail], radix: radix.base) else { return nil }

                tail = head
                magnitude[index] = word
                magnitude.formIndex(after: &index)
            }
        }
    }
    
    @inlinable static func _decodeBigEndianDigits(_ source: some StringProtocol, radix: ImperfectRadixUIntRoot) -> Self? {
        let utf8 = source.utf8.drop(while:{ $0 == 48 })
        var head = utf8.startIndex as String.Index
        let alignment = utf8.count  % radix.exponent as Int
        var magnitude = Magnitude()
        //=--------------------------------------=
        forwards: if !alignment.isZero {
            let tail = utf8.index(head, offsetBy: alignment/*-*/); defer  { head = tail }
            guard let word = UInt(source[head ..< tail], radix: radix.base) else { return nil }
            magnitude.first = word
        }
        //=--------------------------------------=
        forwards: while head != utf8.endIndex {
            let tail = utf8.index(head, offsetBy: radix.exponent); defer  { head = tail }
            guard let word = UInt(source[head ..< tail], radix: radix.base) else { return nil }
            guard !magnitude.multiplyReportingOverflow(by: radix.power)/**/ else { return nil }
            guard !magnitude.addReportingOverflow(word)/*----------------*/ else { return nil }
        }
        //=--------------------------------------=
        return magnitude
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x Encode
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func encodeBigEndianText(_ source: Self, radix: Int, uppercase: Bool) -> String {
        let sign = Bool(source.isLessThanZero)
        var magnitude: Magnitude = source.magnitude
        let alphabet = MaxRadixAlphabet(uppercase: uppercase)
        return AnyRadixUIntRoot(radix).switch(
          perfect:{ Magnitude._encodeBigEndianText(&magnitude, sign: sign, radix: $0, alphabet: alphabet) },
        imperfect:{ Magnitude._encodeBigEndianText(&magnitude, sign: sign, radix: $0, alphabet: alphabet) })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func _encodeBigEndianText(_ magnitude: inout Self, sign: Bool,
    radix: PerfectRadixUIntRoot, alphabet: MaxRadixAlphabet) -> String {
        let minLastIndex: Int = magnitude.minLastIndexReportingIsZeroOrMinusOne().minLastIndex
        return magnitude.withUnsafeWords {
            String(chunks: $0[...minLastIndex], sign: sign, radix: radix, alphabet: alphabet)
        }
    }
    
    @inlinable static func _encodeBigEndianText(_ magnitude: inout Self, sign: Bool,
    radix: ImperfectRadixUIntRoot, alphabet: MaxRadixAlphabet) -> String {
        let capacity: Int = radix.divisibilityByPowerUpperBound(magnitude)
        return withUnsafeTemporaryAllocation(of: UInt.self, capacity: capacity) { chunks in
            var index = chunks.startIndex
            rebasing: repeat {
                chunks[index] = magnitude._formQuotientReportingRemainderAndOverflow(dividingBy: radix.power).partialValue
                chunks.formIndex(after: &index)
            }   while !magnitude.isZero
            
            return String(chunks: chunks[..<index], sign: sign, radix: radix, alphabet: alphabet)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + String
//=----------------------------------------------------------------------------=

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(chunks: some BidirectionalCollection<UInt>, sign: Bool,
    radix: some RadixUIntRoot, alphabet: MaxRadixAlphabet) {
        assert(chunks.last! != 0 || chunks.count == 1)
        assert(chunks.allSatisfy({ $0 < radix.power }) || radix.power.isZero)
        //=--------------------------------------=
        self = Self._withUTF8(chunk: chunks.last!, radix: radix, alphabet: alphabet) { first in
            let count = Int(bit: sign) &+ first.count + radix.exponent * (chunks.count &- 1)
            return Self(unsafeUninitializedCapacity: count) { UTF8 in
                var index = UTF8.startIndex
                //=------------------------------=
                if  sign {
                    UTF8.initializeElement(at: index, to: 45)
                    UTF8.formIndex(after: &index)
                }
                //=------------------------------=
                index = UTF8[index...].initialize(fromContentsOf: first)
                //=------------------------------=
                for var chunk in chunks.dropLast().reversed() {
                    let destination = UTF8.index(index, offsetBy: radix.exponent)
                    var backtrack = destination
                    defer { index = destination }
                    
                    backwards: while backtrack != index {
                        UTF8.formIndex(before: &backtrack)
                        
                        let digit: UInt
                        (chunk,  digit) = radix.dividing(chunk)
                        let unit: UInt8 = alphabet[unchecked: UInt8(_truncatingBits: digit)]
                        UTF8.initializeElement(at: backtrack, to: unit)
                    }
                }
                //=------------------------------=
                assert(UTF8[..<index].count == count)
                return count
            }
        }
    }
    
    @inlinable static func _withUTF8<T>(chunk: UInt, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabet, body: (UnsafeBufferPointer<UInt8>) throws -> T) rethrows -> T {
        try withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            assert(chunk < radix.power || radix.power.isZero)
            //=----------------------------------=
            var chunk = chunk as UInt
            var backtrack = radix.exponent as Int
            //=----------------------------------=
            backwards: repeat {
                utf8.formIndex(before: &backtrack)
                
                let digit: UInt
                (chunk,  digit) = radix.dividing(chunk)
                let unit: UInt8 = alphabet[unchecked: UInt8(_truncatingBits: digit)]
                utf8.initializeElement(at: backtrack, to: unit)
            }   while !chunk.isZero
            //=----------------------------------=
            let initialized = utf8[backtrack...]
            defer { initialized.deinitialize() }
            //=----------------------------------=
            return try body(UnsafeBufferPointer(rebasing: initialized))
        }
    }
}
