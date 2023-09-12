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
        fatalError("TODO")
    }
    
    @inlinable public var isLessThanZero: Bool {
        fatalError("TODO")
    }
    
    @inlinable public var isMoreThanZero: Bool {
        fatalError("TODO")
    }
    
    @inlinable public var isPowerOf2: Bool {
        fatalError("TODO")
    }
    
    @inlinable public func signum() -> Int {
        fatalError("TODO")
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
        lhs.compared(to: rhs).isZero
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        fatalError("TODO")
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x Unsigned
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
        
    @inlinable public var isZero: Bool {
        self.storage.count == 1 && self.storage.first!.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.storage.withUnsafeBufferPointer({ NBK.nonzeroBitCount(of: $0, equals: 1) })
    }
    
    @inlinable public func signum() -> Int {
        Int(bit: !self.isZero)
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
        lhs.compared(to: rhs).isZero
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self .storage.withUnsafeBufferPointer { lhs in
        other.storage.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .storage.withUnsafeBufferPointer { lhs in
        other.storage.withUnsafeBufferPointer { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.storage.withUnsafeBufferPointer { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.storage.withUnsafeBufferPointer { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index)
        }}
    }
}
