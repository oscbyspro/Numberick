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
// MARK: * NBK x Flexible Width x Comparisons x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.storage.elements.count == 1 && self.storage.first.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        self.storage.last.mostSignificantBit
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isLessThanZero && !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        !self.isLessThanZero && self.withUnsafeBufferPointer({ NBK.nonzeroBitCount(of: $0, equals: 1) })
    }
    
    @inlinable public func signum() -> Int {
        self.isLessThanZero ? -1 : self.isZero ? 0 : 1
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
        self .withUnsafeBufferPointer { lhs in
        other.withUnsafeBufferPointer { rhs in
            NBK.compareStrictSignedInteger(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .withUnsafeBufferPointer { lhs in
        other.withUnsafeBufferPointer { rhs in
            NBK.compareStrictSignedInteger(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.withUnsafeBufferPointer {    lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareStrictSignedInteger(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.withUnsafeBufferPointer {    lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareStrictSignedInteger(lhs, to: rhs, at: index)
        }}
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable public var isZero: Bool {
        self.storage.elements.count == 1 && self.storage.first.isZero
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
        self .withUnsafeBufferPointer { lhs in
        other.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .withUnsafeBufferPointer { lhs in
        other.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.withUnsafeBufferPointer {    lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.withUnsafeBufferPointer {    lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x Storage
//*============================================================================*

extension PrivateIntXLOrUIntXLStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable static var isSigned: Bool {
        Digit.isSigned
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self.last.mostSignificantBit
    }
}
