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
    
    /// Creates a new instance from the given `digits` and `radix`.
    ///
    /// The ASCII sequence passed as `digits` may contain one or more numeric
    /// digits (0-9) or letters (a-z or A-Z), according to the `radix`. If
    /// the ASCII sequence passed as `digits` uses an invalid format, or it's
    /// value cannot be represented, the result is nil.
    ///
    /// - Note:  The decoding strategy is case insensitive.
    ///
    @inlinable init?(digits: NBK.UnsafeUTF8, radix: Int) {
        guard !digits.isEmpty else { return nil }
        //=--------------------------------------=
        let alphabet = AnyRadixAlphabetDecoder(radix: radix) // this checks the radix
        //=--------------------------------------=
        self.init()
        
        for digit in digits {
            guard let digitValue = alphabet.decode(digit) else { return nil }
            guard !self.multiplyReportingOverflow(by:/**/ Self(bitPattern: radix)) else { return nil }
            guard !self.addReportingOverflow(Self(truncatingIfNeeded: digitValue)) else { return nil }
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
    alphabet: MaxRadixAlphabetEncoder, prefix: NBK.UnsafeUTF8) -> String {
        //=--------------------------------------=
        assert(!chunks.isEmpty, "chunks must not be empty")
        assert(!chunks.last!.isZero || chunks.count == 1, "chunks must not have redundant zeros")
        assert(  radix.power.isZero || chunks.allSatisfy({ $0 < radix.power }), "chunks must be less than radix's power")
        //=--------------------------------------=
        return String.withUTF8Unchecked(chunk: chunks.last!, radix: radix, alphabet: alphabet) { first in
            let count: Int = prefix.count + first.count + radix.exponent * (chunks.count &- 1)
            return String(unsafeUninitializedCapacity: count) { utf8 in
                //=------------------------------=
                // de/init: element is trivial
                //=------------------------------=
                var index = utf8.startIndex
                //=------------------------------=
                index = utf8[index...].update(fromContentsOf: prefix)
                index = utf8[index...].update(fromContentsOf: first )
                //=------------------------------=
                for var chunk in chunks.dropLast().reversed() {
                    var digit: UInt
                    
                    let nextIndex = utf8.index(index, offsetBy: radix.exponent)
                    defer { index = nextIndex }
                    
                    for backtrackIndex in Range(uncheckedBounds:(index, nextIndex)).reversed() {
                        (chunk,  digit) = radix.dividing(chunk)
                        let unit: UInt8 = alphabet.encode(unchecked: UInt8(_truncatingBits: digit))
                        utf8[backtrackIndex] = unit
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
    alphabet: MaxRadixAlphabetEncoder, body: (NBK.UnsafeUTF8) -> T) -> T {
        //=--------------------------------------=
        assert(radix.power.isZero || chunk < radix.power, "chunks must be less than radix's power")
        //=--------------------------------------=
        return Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: radix.exponent) { utf8 in
            //=----------------------------------=
            // de/init: element is trivial
            //=----------------------------------=
            var digit: UInt
            var chunk: UInt = chunk
            var backtrackIndex = radix.exponent as Int
            //=----------------------------------=
            backwards: repeat {
                utf8.formIndex(before: &backtrackIndex)
                
                (chunk,  digit) = radix.dividing(chunk)
                let unit: UInt8 = alphabet.encode(unchecked: UInt8(_truncatingBits: digit))
                utf8[backtrackIndex] = unit
            }   while !chunk.isZero
            //=----------------------------------=
            return body(NBK.UnsafeUTF8(rebasing: utf8[backtrackIndex...]))
        }
    }
}
