//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Integer
//*============================================================================*

extension NBK {
    
    /// A namespace for tuple integer algorithms.
    @frozen public enum TupleInteger<High> where High: NBKFixedWidthInteger {
        
        /// An integer split into 2 parts.
        public typealias Wide2 = NBK.Wide2<High>
        
        /// An integer split into 3 parts.
        public typealias Wide3 = NBK.Wide3<High>
        
        //*====================================================================*
        // MARK: * Magnitude
        //*====================================================================*
        
        public typealias Magnitude = TupleInteger<High.Magnitude>
    }
}
