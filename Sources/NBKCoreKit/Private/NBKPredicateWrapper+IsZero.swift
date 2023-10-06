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

extension NBK {
    
    public typealias Zero<Value> = _NBKPredicateWrapper<IsZero<Value>> where Value: NBKBinaryInteger
    
    public typealias NonZero<Value> = _NBKPredicateWrapper<IsNonZero<Value>> where Value: NBKBinaryInteger
    
    public typealias ZeroOrLess<Value> = _NBKPredicateWrapper<IsZeroOrLess<Value>> where Value: NBKBinaryInteger
    
    public typealias ZeroOrMore<Value> = _NBKPredicateWrapper<IsZeroOrMore<Value>> where Value: NBKBinaryInteger
    
    public typealias LessThanZero<Value> = _NBKPredicateWrapper<IsLessThanZero<Value>> where Value: NBKBinaryInteger
    
    public typealias MoreThanZero<Value> = _NBKPredicateWrapper<IsMoreThanZero<Value>> where Value: NBKBinaryInteger
}

//*============================================================================*
// MARK: * Predicate Wrapper x Predicate
//*============================================================================*

extension NBK {
    
    //*============================================================================*
    // MARK: * Is Zero
    //*============================================================================*
    
    @frozen public enum IsZero<Value>: _NBKPredicate where Value: NBKBinaryInteger {
        
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
    
    @frozen public enum IsLessThanZero<Value>: _NBKPredicate where Value: NBKBinaryInteger {
        
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
    
    @frozen public enum IsMoreThanZero<Value>: _NBKPredicate where Value: NBKBinaryInteger {
        
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
}
