//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer
//*============================================================================*

extension NBK {
    
    /// A namespace for strict unsigned integer algorithms.
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
    @frozen public enum StrictUnsignedInteger<Base> where Base: NBKOffsetAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        /// The bit pattern namespace of this type.
        public typealias BitPattern = NBK.StrictBitPattern<Base>
        
        //*====================================================================*
        // MARK: * Sub Sequence
        //*====================================================================*
        
        /// The sub sequence namespace of this type.
        ///
        /// The `base` may be `empty` at the start and end of each access.
        ///
        @frozen public enum SubSequence { }
    }
}
