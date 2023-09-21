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
    /// ### Development
    ///
    /// The base needs `zero` to `count` indices for performance reasons.
    ///
    /// ### Development 2
    ///
    /// Remaking this as a view when Swift gets view types could be neat.
    ///
    /// ### Development 3
    ///
    /// Some algorithms can be made lenient, but meh.
    ///
    @frozen public struct StrictUnsignedInteger<Base> where Base: NBKOffsetAccessCollection,
    Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        public typealias BitPattern = NBK.StrictBitPattern<Base>
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable static func validate(_ base: Base) -> Bool { !base.isEmpty }
    }
}
