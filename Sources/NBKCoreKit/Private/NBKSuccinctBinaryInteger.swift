//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Succinct Binary Integer
//*============================================================================*

extension NBK {
    
    /// A namespace for succinct binary integer algorithms.
    ///
    /// The `base` must be `succinct` at the start and end of each access.
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
    @frozen public enum SuccinctBinaryInteger<Base> where Base: NBKOffsetAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        //*====================================================================*
        // MARK: * Components
        //*====================================================================*
        
        public typealias Components = (body: Base, sign: Bool)
    }
}
