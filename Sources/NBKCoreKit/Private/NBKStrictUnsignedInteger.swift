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
    /// ### Development
    ///
    /// Remaking this as a view when Swift gets view types might be neat.
    /// 
    @frozen public enum StrictUnsignedInteger<Base> where Base: RandomAccessCollection, Base.Element: NBKCoreInteger & NBKUnsignedInteger {
        
        /// The binary integer namespace of this type.
        public typealias Binary = NBK.StrictBinaryInteger<Base>
        
        /// The signed integer namespace of this type.
        public typealias Signed = NBK.StrictSignedInteger<Base>
        
        //*====================================================================*
        // MARK: * Sub Sequence
        //*====================================================================*
        
        /// The sub sequence namespace of this type.
        ///
        /// The `base` may be `empty` at the start and end of each access.
        ///
        @frozen public enum SubSequence {
            
            /// The binary integer namespace of this type.
            public typealias Binary = NBK.StrictBinaryInteger<Base>.SubSequence
            
            /// The signed integer namespace of this type.
            public typealias Signed = NBK.StrictSignedInteger<Base>.SubSequence
        }
    }
}
