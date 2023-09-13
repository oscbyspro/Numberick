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
// MARK: * NBK x Flexible Width x IntXL
//*============================================================================*

/// A signed, flexible-width, binary integer.
@frozen public struct NBKFlexibleWidth: PrivateIntXLOrUIntXL, NBKSignedInteger {
    
    public typealias Digit = Int
    
    public typealias Words = ContiguousArray<UInt>
    
    @usableFromInline typealias Elements = ContiguousArray<UInt>
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The integer's underlying storage.
    ///
    /// It must be `normal` and `nonempty` at the start and end of each access.
    ///
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage) {
        self.storage = storage
        precondition(Self.isNormal(self.storage))
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
        Swift.assert(Self.isNormal(self.storage))
    }
    
    @inlinable init(normalizing storage: Storage) {
        self.storage = storage
        Self.normalize(&self.storage)
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, flexible-width, binary integer.
    @frozen public struct Magnitude: PrivateIntXLOrUIntXL, NBKUnsignedInteger {
        
        public typealias Digit = UInt
        
        public typealias Words = NBKFlexibleWidth.Words
                
        @usableFromInline typealias Storage  = NBKFlexibleWidth.Storage
        
        @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
                        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The integer's underlying storage.
        ///
        /// It must be `normal` and `nonempty` at the start and end of each access.
        ///
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ storage: Storage) {
            self.storage = storage
            precondition(Self.isNormal(self.storage))
        }
        
        @inlinable init(unchecked storage: Storage) {
            self.storage = storage
            Swift.assert(Self.isNormal(self.storage))
        }
        
        @inlinable init(normalizing storage: Storage) {
            self.storage = storage
            Self.normalize(&self.storage)
        }
    }
    
    //*============================================================================*
    // MARK: * Storage
    //*============================================================================*

    /// IntXL's and UIntXL's underlying storage.
    ///
    /// It has fixed-width semantics unless stated otherwise.
    ///
    @frozen @usableFromInline struct Storage {
                
        @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
                
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        /// The integer's underlying storage.
        ///
        /// It must be `nonempty` at the start and end of each access.
        ///
        @usableFromInline var elements: Elements
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ elements: Elements) {
            self.elements = elements
            precondition(!self.elements.isEmpty)
        }
        
        @inlinable init(unchecked elements: Elements) {
            self.elements = elements
            Swift.assert(!self.elements.isEmpty)
        }
        
        @inlinable init(nonemptying elements: Elements) {
            self.elements = elements
            if  self.elements.isEmpty {
                self.elements.append(0)
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Aliases
//*============================================================================*

/// A signed, flexible-width, integer.
public typealias IntXL = NBKFlexibleWidth

/// An unsigned, flexible-width, integer.
public typealias UIntXL = NBKFlexibleWidth.Magnitude

/// IntXL's and UIntXL's underlying storage.
@usableFromInline typealias StorageXL = NBKFlexibleWidth.Storage

//*============================================================================*
// MARK: * NBK x Flexible Width x Protocol
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger, ExpressibleByStringLiteral where
Digit: NBKCoreInteger<UInt>, Magnitude == UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, at index: Int)
    
    @inlinable func adding(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable mutating func add(_ other: Digit, at index: Int)
    
    @_disfavoredOverload @inlinable func adding(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, at index: Int)
    
    @inlinable func subtracting(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable mutating func subtract(_ other: Digit, at index: Int)
    
    @_disfavoredOverload @inlinable func subtracting(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func bitshiftLeftSmart(by distance: Int)
    
    @inlinable func bitshiftedLeftSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(by distance: Int)
    
    @inlinable func bitshiftedLeft(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int, bits: Int)
    
    @inlinable func bitshiftedLeft(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int)
    
    @inlinable func bitshiftedLeft(words: Int) -> Self
    
    @inlinable mutating func bitshiftRightSmart(by distance: Int)
    
    @inlinable func bitshiftedRightSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(by distance: Int)
    
    @inlinable func bitshiftedRight(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int, bits: Int)
    
    @inlinable func bitshiftedRight(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int)
    
    @inlinable func bitshiftedRight(words: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func updateZeroValue()
    
    @inlinable mutating func update(_ value: Digit)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A `description` of this type.
    ///
    /// ```
    /// ┌─────────────────────────── → ────────────┐
    /// │ type                       │ description │
    /// ├─────────────────────────── → ────────────┤
    /// │ NBKFlexibleWidth           │  "IntXL"    │
    /// │ NBKFlexibleWidth.Magnitude │ "UIntXL"    │
    /// └─────────────────────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        self.isSigned ? "IntXL" : "UIntXL"
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Protocol x Private
//*============================================================================*

@usableFromInline protocol PrivateIntXLOrUIntXL: IntXLOrUIntXL where Words == NBKFlexibleWidth.Words {
    
    typealias Storage  = NBKFlexibleWidth.Storage
    
    typealias Elements = NBKFlexibleWidth.Elements
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var storage: Storage { get set }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage)
    
    @inlinable init(unchecked storage: Storage)
    
    @inlinable init(normalizing storage: Storage)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Storage
    //=------------------------------------------------------------------------=
    
    @inlinable static func isNormal(_ storage: Storage) -> Bool
    
    @inlinable static func normalize(_ storage: inout Storage)
}
