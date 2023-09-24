//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKTextKit

//*============================================================================*
// MARK: * NBK x Double Width x Text
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: some StringProtocol, radix: Int) {
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
    
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        NBKIntegerDescriptionEncoder(radix: radix, uppercase: uppercase).encode(self)
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
        var digits    = digits.drop(while:{ $0 == 48 })
        let quotient  = digits.count &>> radix.exponent.trailingZeroBitCount
        let remainder = digits.count &  (radix.exponent - 1)
        //=--------------------------------------=
        guard quotient &+ Int(bit: remainder.isMoreThanZero) <= Self.count else { return nil }
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
        var digits    = digits.drop(while:{ $0 == 48 })
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
}
