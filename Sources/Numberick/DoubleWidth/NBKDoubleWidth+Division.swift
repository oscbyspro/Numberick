//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Double Width x Division
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func divideReportingOverflow(by divisor: Self) -> Bool {
        fatalError()
    }
    
    @inlinable public func dividedReportingOverflow(by rhs: Self) -> PVO<Self> {
        fatalError()
    }
    
    @inlinable public mutating func formRemainderReportingOverflow(dividingBy divisor: Self) -> Bool {
        fatalError()
    }
    
    @inlinable public func remainderReportingOverflow(dividingBy rhs: Self) -> PVO<Self> {
        fatalError()
    }
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>> {
        fatalError()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        fatalError()
    }
}
