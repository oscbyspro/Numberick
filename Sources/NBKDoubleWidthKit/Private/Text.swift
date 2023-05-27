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
// MARK: * NBK x Text x UInt
//*============================================================================*

extension UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digits and radix.
    ///
    /// The buffer passed as `digits` contain one or more numeric digits (0-9) or
    /// letters (a-z or A-Z) in ASCII format. The decoding is case insensitive.
    ///
    /// ```
    /// ┌────────┬─────── → ───────┐
    /// │ digits │ radix  │ self   │
    /// ├────────┼─────── → ───────┤
    /// │  "123" │  10    │  123   │
    /// │ "+123" │  10    │  nil   │
    /// │  "123" │  16    │  291   │
    /// │ "+123" │  16    │  nil   │
    /// └────────┴─────── → ───────┘
    /// ```
    ///
    /// - Parameters:
    ///   - digits: An unsigned ASCII sequence of a number in the given `radix`.
    ///   - radix: The radix of `digits`. It must be in 2 through 36. The default is 10.
    ///
    @inlinable init?(digits: UnsafeBufferPointer<UInt8>, radix: Int) {
        guard !digits.isEmpty else { return nil }
        //=------------------------------------------=
        let multiplier = Self(bitPattern: radix)
        let alphabet = AnyRadixAlphabetDecoder(radix: radix)
        //=------------------------------------------=
        self.init()
        
        for digit in digits {
            guard let value = alphabet.decode(digit)/*---------------------*/ else { return nil }            
            guard !self.multiplyReportingOverflow(by: multiplier)/*--------*/ else { return nil }
            guard !self.addReportingOverflow(Self(truncatingIfNeeded: value)) else { return nil }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Text x String
//*============================================================================*

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Encodes unchecked chunks, using the given format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable static func fromUTF8Unchecked(chunks: some RandomAccessCollection<UInt>, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, prefix: UnsafeBufferPointer<UInt8>) -> String {
        assert(!chunks.isEmpty, "chunks must not be empty")
        assert(!chunks.last!.isZero || chunks.count == 1, "chunks must not have redundant zeros")
        assert(  radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        return String.withUTF8Unchecked(chunk: chunks.last!, radix: radix, alphabet: alphabet) { leader in
            let count = prefix.count &+ leader.count + radix.exponent * (chunks.count &- 1)
            return String(unsafeUninitializedCapacity: count) { utf8 in
                var index = utf8.startIndex
                //=------------------------------=
                index = utf8[index...].initialize(fromContentsOf: prefix)
                index = utf8[index...].initialize(fromContentsOf: leader)
                //=------------------------------=
                for var chunk in chunks.dropLast().reversed() {
                    var digit: UInt
                    
                    let nextIndex = utf8.index(index, offsetBy: radix.exponent)
                    defer { index = nextIndex }
                    
                    for backtrackIndex in Range(uncheckedBounds:(index, nextIndex)).reversed() {
                        (chunk, digit) = radix.dividing(chunk)
                        let unit: UInt8 = alphabet.encode(unchecked: UInt8(_truncatingBits: digit))
                        utf8.initializeElement(at: backtrackIndex, to: unit)
                    }
                }
                //=------------------------------=
                assert(utf8[..<index].count == count)
                return count
            }
        }
    }
    
    /// Encodes an unchecked chunk, using the given format.
    ///
    /// In this context, a chunk is a digit in the base of the given radix's power.
    ///
    @inlinable static func withUTF8Unchecked<T>(chunk: UInt, radix: some RadixUIntRoot,
    alphabet: MaxRadixAlphabetEncoder, body: (UnsafeBufferPointer<UInt8>) -> T) -> T {
        assert(radix.power.isZero || chunk < radix.power, "chunks must be less than radix's power")
        //=--------------------------------------=
        return  Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            var digit: UInt
            var chunk: UInt = chunk
            var backtrackIndex = radix.exponent as Int
            //=----------------------------------=
            backwards: repeat {
                utf8.formIndex(before: &backtrackIndex)
                
                (chunk,  digit) = radix.dividing(chunk)
                let unit: UInt8 = alphabet.encode(unchecked: UInt8(_truncatingBits: digit))
                utf8.initializeElement(at: backtrackIndex, to: unit)
            }   while !chunk.isZero
            //=----------------------------------=
            let initialized = utf8[backtrackIndex...]
            defer { initialized.deinitialize() }
            //=----------------------------------=
            return body(UnsafeBufferPointer(rebasing: initialized))
        }
    }
}
