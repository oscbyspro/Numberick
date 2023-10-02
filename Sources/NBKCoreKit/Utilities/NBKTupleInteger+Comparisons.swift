//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Integer x Comparisons
//*============================================================================*

extension NBK.TupleInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @_transparent public static func compare22S(_ lhs: Wide2, to rhs: Wide2) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        return  lhs.low .compared(to: rhs.low );
    }
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @_transparent public static func compare33S(_ lhs: Wide3, to rhs: Wide3) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        let b = lhs.mid .compared(to: rhs.mid ); if !b.isZero { return b }
        return  lhs.low .compared(to: rhs.low );
    }
}
