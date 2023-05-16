//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Black Hole
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Opaquely uses the argument.
    ///
    /// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
    ///
    @inline(never) @_semantics("optimize.no.crossmodule")
    public static func blackHole<T>(_ x: T) {  }

    /// Opaquely returns the argument.
    ///
    /// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
    ///
    @inline(never) @_semantics("optimize.no.crossmodule")
    public static func blackHoleIdentity<T>(_ x: T) -> T { x }

    /// Opaquely mutates the argument.
    ///
    /// Optimizer folklore has it that its secrets are revealed only to the supreme architect.
    ///
    @inline(never) @_semantics("optimize.no.crossmodule")
    public static func blackHoleInoutIdentity<T>(_ x: inout T) { }
}
