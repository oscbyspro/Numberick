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
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// The number of words that fit in this integer type.
    @inlinable public static var count: Int {
        BitPattern.count(UInt.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>) {
        self.init(words: words, isSigned: Self.isSigned)
    }
    
    @inlinable public init?(words: some RandomAccessCollection<UInt>, isSigned: Bool) {
        let  comparison: Int
       (self,comparison) = Self.validating(words: words, isSigned: isSigned)
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
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {

    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
        
    @inlinable static func validating(words: some RandomAccessCollection<UInt>, isSigned: Bool) -> (value: Self, comparison: Int) {
        let (value, sign) = Self.truncating(words: words, isSigned: isSigned)
        let success =  value.isLessThanZero != sign.isZero && words.dropFirst(Self.count).allSatisfy({ $0 == sign })
        return (value: value, comparison: Int(bitPattern: success ? 0 : sign &<< 1 &+ 1))
    }
    
    @inlinable static func truncating(words: some RandomAccessCollection<UInt>, isSigned: Bool) -> (value: Self, sign: UInt) {
        let sign  = UInt(repeating: isSigned && words.last?.mostSignificantBit == true)
        let value = Self.uninitialized(as: UInt.self) {
            let value = NBK.TwinHeaded($0, reversed: NBK.isBigEndian)
            let limit = words.count as Int
            for index in value.indices {
                let element = index < limit ? words[words.index(words.startIndex,offsetBy: index)] : sign
                value.base.baseAddress!.advanced(by: value.baseSubscriptIndex(index)).initialize(to: element)
            }
        }
        
        return (value: value, sign: sign)
    }
}
