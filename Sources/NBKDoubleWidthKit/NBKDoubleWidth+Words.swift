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
// MARK: * NBK x Double Width x Words
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>) {
        let  comparison: Int
       (self,comparison) = Self.validating(words: words, isSigned: Self.isSigned)
        if  !comparison.isZero { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Self {
        _read { yield self }
    }
    
    @inlinable public var count: Int {
        Self.count as Int
    }
    
    /// The number of words that fit in this integer type.
    @inlinable public static var count: Int {
        BitPattern.count(UInt.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {

    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
        
    @inlinable static func validating<T: RandomAccessCollection>(words: T, isSigned: Bool)
    -> (value: Self, comparison: Int) where T.Element == UInt {
        let (value, remainders, sign) = Self.truncating(words: words, isSigned: isSigned)
        let success = value.isLessThanZero != sign.isZero && remainders.allSatisfy({ $0 == sign })
        return (value: value, comparison: Int(bitPattern: success ? 0 : sign &<< 1 | 1))
    }
    
    @inlinable static func truncating<T: RandomAccessCollection>(words: T, isSigned: Bool)
    -> (value: Self, remainders: T.SubSequence, sign: UInt) where T.Element == UInt {
        //=--------------------------------------=
        let isLessThanZero: Bool =  isSigned && words.last?.mostSignificantBit == true
        let sign  = UInt(repeating: isLessThanZero)
        //=--------------------------------------=
        let value = Self.uninitialized(as: UInt.self) {
            let value =  NBK.TwinHeaded($0, reversed: NBK.isBigEndian)
            let start =  value.base.baseAddress!
            for index in value.indices {
                let word = index < words.count ? words[words.index(words.startIndex, offsetBy: index)] : sign
                start.advanced(by: value.baseSubscriptIndex(index)).initialize(to: word)
            }
        }
        //=--------------------------------------=
        return (value: value, remainders: words.dropFirst(value.count), sign: sign)
    }
}
