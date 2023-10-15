//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Guarantee
//*============================================================================*

/// A property wrapper that validates some predicate on creation.
@frozen @propertyWrapper public struct _NBKGuarantee<Predicate: _NBKPredicate> {
    
    /// The predicate of this type.
    public typealias Predicate = Predicate
    
    /// The value of this type.
    public typealias Value = Predicate.Value
    
    /// The inverse of this type.
    public typealias Inverse = _NBKGuarantee<Predicate.Inverse>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A value that satisfies the predicate of this type.
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Wraps the given `value` or returns nil.
    @inlinable public init?(exactly value: Value) {
        guard Predicate.validate(value) else { return nil }
        self.value = value
    }
    
    /// Wraps the given `value` or crashes in RELEASE mode.
    @inlinable public init(_ value: Value, message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        precondition(Predicate.validate(value), message(), file: file, line: line)
        self.value = value
    }
    
    /// Wraps the given `value` or crashes in DEBUG mode.
    @inlinable public init(unchecked value: Value, message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        Swift.assert(Predicate.validate(value), message(), file: file, line: line)
        self.value = value
    }
    
    /// Wraps the given `value` or crashes in RELEASE mode.
    @inlinable public init(wrappedValue: Value, message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line) {
        self.init(wrappedValue, message: message(), file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// A value that satisfies the predicate of this type.
    @inlinable public var wrappedValue: Value {
        self.value
    }
    
    /// This predicate wrapper.
    @inlinable public var projectedValue: Self {
        self
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

extension NBK {
    
    /// A precondition asserting that a value is zero.
    public typealias Zero<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsZero<Value>>
    
    /// A precondition asserting that a value is not zero.
    public typealias NonZero<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsNot<IsZero<Value>>>
    
    /// A precondition asserting that a value is zero or less.
    public typealias ZeroOrLess<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsNot<IsMoreThanZero<Value>>>
    
    /// A precondition asserting that a value is zero or more.
    public typealias ZeroOrMore<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsNot<IsLessThanZero<Value>>>
    
    /// A precondition asserting that a value is less than zero.
    public typealias LessThanZero<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsLessThanZero<Value>>
    
    /// A precondition asserting that a value is more than zero.
    public typealias MoreThanZero<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsMoreThanZero<Value>>
    
    /// A precondition asserting that a value is a power of two.
    public typealias PowerOf2<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsPowerOf2<Value>>
    
    /// A precondition asserting that a value is not a power of two.
    public typealias NonPowerOf2<Value: NBKBinaryInteger>
    = _NBKGuarantee<IsNot<IsPowerOf2<Value>>>
}

//*============================================================================*
// MARK: * NBK x Guarantee x Predicate
//*============================================================================*

/// A predicate that can be referenced by the type system.
public protocol _NBKPredicate<Value> {
    
    /// The type this predicate can validate.
    associatedtype Value
    
    /// A predicate with the opposite assertion of this type.
    associatedtype Inverse: _NBKPredicate<Value> = NBK.IsNot<Self>
    
    /// Returns whether the given `value` satisfies this predicate.
    @inlinable static func validate(_ value: Value) -> Bool
}

//=----------------------------------------------------------------------------=
// MARK: + Models
//=----------------------------------------------------------------------------=

extension NBK {
    
    /// A predicate that returns the inverse result of another predicate.
    @frozen public enum IsNot<Predicate: _NBKPredicate>: _NBKPredicate {
                
        public typealias Inverse = Predicate
        
        @inlinable static public func validate(_ value: Predicate.Value) -> Bool {
            !Predicate.validate(value)
        }
    }
    
    /// A predicate that returns whether a value is zero.
    @frozen public enum IsZero<Value: NBKBinaryInteger>: _NBKPredicate {
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isZero
        }
    }
    
    /// A predicate that returns whether a value is less than zero.
    @frozen public enum IsLessThanZero<Value: NBKBinaryInteger>: _NBKPredicate {
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isLessThanZero
        }
    }
    
    /// A predicate that returns whether a value is more than zero.
    @frozen public enum IsMoreThanZero<Value: NBKBinaryInteger>: _NBKPredicate {
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isMoreThanZero
        }
    }
    
    /// A predicate that returns whether a value is a power of two.
    @frozen public enum IsPowerOf2<Value: NBKBinaryInteger>: _NBKPredicate {
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isPowerOf2
        }
    }
}

//*============================================================================*
// MARK: * NBK x Guarantee x Miscellaneous
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Switch
//=----------------------------------------------------------------------------=

extension _NBKGuarantee {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs an action on this type or its inverse.
    @inlinable public static func `switch`<T>(_ value: Value, true: (Self) throws -> T, false: (Inverse) throws -> T) rethrows -> T {
        switch Predicate.validate(value) {
        case  true: return try `true` (Self   (unchecked: value))
        case false: return try `false`(Inverse(unchecked: value)) }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Power of 2
//=----------------------------------------------------------------------------=

extension NBK.PowerOf2 {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Wraps the fixed bit width of the given integer type.
    ///
    /// - Note: All core integer bit widths are powers of 2.
    ///
    @inlinable public init<T>(bitWidth: T.Type) where T: NBKCoreInteger, Value: NBKCoreInteger<UInt>  {
        self.init(unchecked: Value(bitPattern: T.bitWidth))
    }
}
