//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer
//*============================================================================*

extension NBK {
    
    /// A namespace for proper binary integer algorithms.
    ///
    /// - Note: Proper binary integer models conform to ``NBKBinaryInteger``.
    ///
    @frozen public enum ProperBinaryInteger<Integer> where Integer: NBKBinaryInteger {
        
        //*====================================================================*
        // MARK: * Magnitude
        //*====================================================================*
        
        public typealias Magnitude = ProperBinaryInteger<Integer.Magnitude>
    }
}
