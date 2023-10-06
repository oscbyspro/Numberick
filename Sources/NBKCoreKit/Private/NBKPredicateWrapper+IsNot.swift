//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Predicate Wrapper x Predicate
//*============================================================================*

extension NBK {
    
    //*========================================================================*
    // MARK: * Is Not
    //*========================================================================*
    
    @frozen public enum IsNot<Predicate>: _NBKPredicate where Predicate: _NBKPredicate {
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable static public func validate(_ value: Predicate.Value) -> Bool {
            !Predicate.validate(value)
        }
    }
}
