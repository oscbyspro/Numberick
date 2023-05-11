//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Addition
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func addReportingOverflow(_ amount: Self) -> Bool {
        fatalError()
    }
    
    @inlinable public func addingReportingOverflow(_ rhs: Self) -> PVO<Self> {
        fatalError()
    }
    
    @inlinable public mutating func subtractReportingOverflow(_ amount: Self) -> Bool {
        fatalError()
    }
    
    @inlinable public func subtractingReportingOverflow(_ rhs: Self) -> PVO<Self> {
        fatalError()
    }
}
