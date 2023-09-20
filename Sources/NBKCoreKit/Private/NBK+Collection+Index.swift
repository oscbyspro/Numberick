//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Collection x Index
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func index<Base>(_ base: Base, pushing index: inout Base.Index) -> Base.Index where Base: Collection {
        defer{ base.formIndex(after: &index) }
        return index as Base.Index
    }
    
    @inlinable public static func index<Base>(_ base: Base, pulling index: inout Base.Index) -> Base.Index where Base: BidirectionalCollection {
        base.formIndex(before: &index)
        return index as Base.Index
    }
}

