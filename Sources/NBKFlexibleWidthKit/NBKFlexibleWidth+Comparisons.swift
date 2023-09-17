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
        self.withUnsafeStrictUnsignedInteger({ $0.base.count == 1 && $0.first.isZero })
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.withUnsafeBufferPointer({ NBK.nonzeroBitCount(of: $0, equals: 1) })
    }
    
    @inlinable public func signum() -> Int {
        Int(bit: !self.isZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage.elements)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs).isZero
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.storage.elements.withUnsafeBufferPointer { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.storage.elements.withUnsafeBufferPointer { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
}
