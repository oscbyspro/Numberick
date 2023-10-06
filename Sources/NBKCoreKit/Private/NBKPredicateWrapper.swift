//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Predicate Wrapper
//*============================================================================*

/// A model that validates some predicate on creation.
@frozen @propertyWrapper public struct _NBKPredicateWrapper<Predicate: _NBKPredicate> {
    
    /// The predicate of this type.
    public typealias Predicate = Predicate
    
    /// The value of this type.
    public typealias Value = Predicate.Value
    
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

//*============================================================================*
// MARK: * Predicate Wrapper x Predicate
//*============================================================================*

/// A predicate that can be referenced by the type system.
public protocol _NBKPredicate<Value> {
    
    associatedtype Value
    
    @inlinable static func validate(_ value: Value) -> Bool
}
