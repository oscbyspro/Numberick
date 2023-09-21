//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Bit Pattern
//*============================================================================*

extension NBK {
    
    /// A namespace for strict bit pattern algorithms.
    ///
    /// The `base` must be `nonempty` at the start and end of each access.
    ///
    /// ```swift
    /// static func algorithm(_ base: inout Base, input: Input) -> Output
    /// ```
    ///
    /// ### Development 1
    ///
    /// The base needs `zero` to `count` indices for performance reasons.
    ///
    /// ### Development 2
    ///
    /// Remaking this as a view when Swift gets view types might be neat.
    ///
    /// ### Development 3
    ///
    /// Some of its algorithms can be made lenient, but meh. Keep it simple.
    ///
    @frozen public struct StrictBitPattern<Base> where Base: NBKOffsetAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable static func validate(_ base: Base) -> Bool { !base.isEmpty }
    }
}
