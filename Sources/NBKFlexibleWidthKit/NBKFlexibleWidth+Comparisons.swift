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
// MARK: * NBK x Flexible Width x Comparisons x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.storage.elements.isEmpty
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public func signum() -> Int {
        Int(bit: !self.isZero)
    }
    
    @inlinable public var isPowerOf2: Bool {
        var nonzeroBitCountLowerBound = 0
        var index = self.storage.elements.startIndex
        //=--------------------------------------=
        while index < self.storage.elements.endIndex, nonzeroBitCountLowerBound < 2 {
            nonzeroBitCountLowerBound &+= self.storage.elements[index].nonzeroBitCount
            self.storage.elements.formIndex(after: &index)
        }
        //=--------------------------------------=
        return nonzeroBitCountLowerBound == 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.storage == rhs.storage
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            let partition = Swift.min(lhs.count - 1, index)
            let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
            let comparison = Self.compareWordsUnchecked(suffix, to: rhs)
            if !comparison.isZero { return comparison }
            let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
            return Int(bit: !prefix.allSatisfy({ $0.isZero }))
        }}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable static func compareWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        assert(lhs.count == 0 || !lhs.last!.isZero)
        assert(rhs.count == 0 || !rhs.last!.isZero)
        //=--------------------------------------=
        if  lhs.count != rhs.count {
            return lhs.count < rhs.count ? -1 : 1
        }
        //=--------------------------------------=
        for index in lhs.indices.reversed() {
            let lhsWord  = lhs[index] as UInt
            let rhsWord  = rhs[index] as UInt
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return Int.zero
    }
}
