//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Precondition
//*============================================================================*

/// A property wrapper that validates some predicate on creation.
@frozen @propertyWrapper public struct _NBKPrecondition<Predicate: _NBKPrecondition_Predicate> {
    
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
    ///
    /// ```swift
    /// func algorithm(@ZeroOrMore count: Int) { ... }
    /// ```
    ///
    /// - Note: This method is called when this type is used as an attribute.
    ///
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
// MARK: * NBK x Precondition x Aliases
//*============================================================================*

extension NBK {
    
    /// A precondition asserting that a value is zero.
    public typealias Zero<Value> = _NBKPrecondition<IsZero<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is not zero.
    public typealias NonZero<Value> = _NBKPrecondition<IsNonZero<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is zero or less.
    public typealias ZeroOrLess<Value> = _NBKPrecondition<IsZeroOrLess<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is zero or more.
    public typealias ZeroOrMore<Value> = _NBKPrecondition<IsZeroOrMore<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is less than zero.
    public typealias LessThanZero<Value> = _NBKPrecondition<IsLessThanZero<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is more than zero.
    public typealias MoreThanZero<Value> = _NBKPrecondition<IsMoreThanZero<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is a power of two.
    public typealias PowerOf2<Value> = _NBKPrecondition<IsPowerOf2<Value>> where Value: NBKBinaryInteger
    
    /// A precondition asserting that a value is not a power of two.
    public typealias NonPowerOf2<Value> = _NBKPrecondition<IsNonPowerOf2<Value>> where Value: NBKBinaryInteger
}

//*============================================================================*
// MARK: * NBK x Precondition x Predicate
//*============================================================================*

/// A predicate that can be referenced by the type system.
///
/// ### Development
///
/// Imagine this not-yet-expressible structure:
///
/// ```swift
/// public protocol NBKPrecondition.Predicate<Value> { ... }
/// ```
///
public protocol _NBKPrecondition_Predicate<Value> {
    
    /// The type this predicate can validate.
    associatedtype Value
    
    /// Returns whether the given `value` satisfies this predicate.
    @inlinable static func validate(_ value: Value) -> Bool
}

//*============================================================================*
// MARK: * NBK x Precondition x Predicate x Types & Aliases
//*============================================================================*

extension NBK {
    
    //*========================================================================*
    // MARK: * Is Not
    //*========================================================================*
    
    @frozen public enum IsNot<Predicate>: _NBKPrecondition_Predicate where Predicate: _NBKPrecondition_Predicate {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Predicate.Value) -> Bool {
            !Predicate.validate(value)
        }
    }
    
    //*============================================================================*
    // MARK: * Is Zero
    //*============================================================================*
    
    @frozen public enum IsZero<Value>: _NBKPrecondition_Predicate where Value: NBKBinaryInteger {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isZero
        }
    }
    
    //*============================================================================*
    // MARK: * Is Less Than Zero
    //*============================================================================*
    
    @frozen public enum IsLessThanZero<Value>: _NBKPrecondition_Predicate where Value: NBKBinaryInteger {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isLessThanZero
        }
    }
    
    //*============================================================================*
    // MARK: * Is More Than Zero
    //*============================================================================*
    
    @frozen public enum IsMoreThanZero<Value>: _NBKPrecondition_Predicate where Value: NBKBinaryInteger {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isMoreThanZero
        }
    }
    
    //*============================================================================*
    // MARK: * Is Non Zero
    //*============================================================================*
    
    public typealias IsNonZero<Value> = IsNot<IsZero<Value>> where Value: NBKBinaryInteger
    
    //*============================================================================*
    // MARK: * Is Zero Or Less
    //*============================================================================*
    
    public typealias IsZeroOrLess<Value> = IsNot<IsMoreThanZero<Value>> where Value: NBKBinaryInteger
    
    //*============================================================================*
    // MARK: * Is Zero Or More
    //*============================================================================*
    
    public typealias IsZeroOrMore<Value> = IsNot<IsLessThanZero<Value>> where Value: NBKBinaryInteger
    
    //*============================================================================*
    // MARK: * Is Power Of 2
    //*============================================================================*
    
    @frozen public enum IsPowerOf2<Value>: _NBKPrecondition_Predicate where Value: NBKBinaryInteger {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Value) -> Bool {
            value.isPowerOf2
        }
    }
    
    //*============================================================================*
    // MARK: * Is Non Power Of 2
    //*============================================================================*
    
    public typealias IsNonPowerOf2<Value> = IsNot<IsPowerOf2<Value>> where Value: NBKBinaryInteger
}
