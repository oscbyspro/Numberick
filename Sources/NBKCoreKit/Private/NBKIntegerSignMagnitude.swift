//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Sign Magnitude
//*============================================================================*

extension NBK {
    
    /// A namespace for integer sign-magnitude algorithms.
    @frozen public enum IntegerSignMagnitude<Magnitude> where Magnitude: NBKUnsignedInteger {
        
        /// The sign and of this type.
        public typealias Sign = NBK.Sign
        
        /// The sign and a magnitude of this type.
        public typealias Components = SM<Magnitude>
    }
}
