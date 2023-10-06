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
    
    public typealias PowerOf2<Value> = _NBKPredicateWrapper<IsPowerOf2<Value>> where Value: NBKFixedWidthInteger
    
    public typealias NonPowerOf2<Value> = _NBKPredicateWrapper<IsNonPowerOf2<Value>> where Value: NBKFixedWidthInteger
}

//*============================================================================*
// MARK: * Predicate Wrapper x Predicate
//*============================================================================*

extension NBK {
    
    //*============================================================================*
    // MARK: * Is Power Of 2
    //*============================================================================*
    
    @frozen public enum IsPowerOf2<Value>: _NBKPredicate where Value: NBKFixedWidthInteger {
        
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
    
    public typealias IsNonPowerOf2<Value> = IsNot<IsPowerOf2<Value>> where Value: NBKFixedWidthInteger
}
